//
//  SliderView.m
//
//  Created by User1 on 3/30/19.
//
//

#import "SliderView.h"
#import "AppDelegate.h"


AppDelegate *appDelegate;
UIView *currentView;
NSMutableArray *actionsListArray;
BOOL isTapped;
UIView *baseview;
SliderView *sliderView;
@implementation SliderView
@synthesize currentViewController;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
CGFloat screenWidth;
CGFloat screenHeight;

+(UITableView*)createSliderForView:(UIViewController*)currentViewController withActionList:(NSArray*)ActionList{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    currentView = currentViewController.view;
    
    
    actionsListArray = [[NSMutableArray alloc] init];
    [actionsListArray removeAllObjects];
    if (ActionList==nil) {
        ActionList = [NSArray arrayWithObjects:@"Logout",@"Exit", nil];
    }
    [actionsListArray setArray:ActionList];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    baseview = [[UIView alloc] initWithFrame:CGRectMake(-screenWidth, appDelegate.isIphone?60:118, screenWidth, screenHeight - 60)];
    baseview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    baseview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    tapGesture.cancelsTouchesInView = NO;
    
    [baseview addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.delegate = self;
    
    
    sliderView= [[SliderView alloc] initWithFrame:CGRectMake(-180, 3, appDelegate.isIphone?180:280, rect.size.height-60) style:UITableViewStyleGrouped];
    sliderView.delegate=sliderView;
    sliderView.dataSource=sliderView;
    sliderView.tag = 2;
    sliderView.userInteractionEnabled = YES;
    sliderView.alpha = 1;
    
    [baseview addSubview:sliderView];
    [appDelegate.window addSubview:baseview];
    sliderView.frame = CGRectMake(-180, 3, 180, rect.size.height-60);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        sliderView.frame=CGRectMake(-280, 3, 280, rect.size.height-113);
    }
    sliderView.backgroundColor = [UIColor lightGrayColor];//[appDelegate getColorFromColorCode:@"#444755"];
    sliderView.bounces=NO;
    isTapped = NO;
    [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
    return sliderView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 2;
    
//    switch (userInfo.numUserTypeID) {
//        case ApprovalTypeID: case SupplierTypeID:
//            section = 1;
//            break;
//        case CWTypeID:
//            section = 2;
//            break;
//
//        default:
//        {
//            /*if (clientListArray.count>0) {
//             section = 3;
//             }else{
//             section=2;
//             }*/
//            section = 2;
//        }
//            break;
//    }
    return section;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return actionsListArray.count;
    }
//    else if (section == 1){
//        return (userInfo.numUserTypeID == CWTypeID) ? appDelegate.mutAryCWNumbers.count : clientListArray.count;
//    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:appDelegate.isIphone ? 13: 13];
    if (indexPath.section == 0) {
        
        if (indexPath.row==0) {
            cell.backgroundColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1];
            cell.backgroundColor = [UIColor clearColor];
            
        }else{
            cell.textLabel.text = [actionsListArray objectAtIndex:indexPath.row-1];
            cell.backgroundColor = [UIColor clearColor];
            
        }
        if(indexPath.row == 2)
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blueColor];
        }
        cell.textLabel.text = [actionsListArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBlack];
        
    }
    
    UIView *layerview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, sliderView.frame.size.width, 1)];
    layerview.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:layerview];
    cell.contentView.tag = indexPath.row;
    cell.tag = indexPath.row;
    cell.userInteractionEnabled = YES;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // NSMutableDictionary *mutDictData = userInfo.mutDictSettings;
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
           // NSDictionary *logOutData = [mutDictData objectForKey:@"Logout"];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"!! Logout !!" message:[NSString stringWithFormat:@"Do you want to Logout"] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            alert.tag=120;
            [alert show];
            
        }else if (indexPath.row==1){
            //NSDictionary * exitData = [mutDictData objectForKey:@"Exit"];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"!!! E X I T !!!" message:[NSString stringWithFormat:@"By Selecting this your unsaved data may loss.\n Still want to Exit?"]  delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            alert.tag=100;
            [alert show];
            
        }
    }
    else if (indexPath.section == 1){
//        if (userInfo.numUserTypeID == CWTypeID) {
//
//            if (userInfo.numCWID == [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] objectForKey:@"saeID"]] integerValue]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"clientChange" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"NO", @"isAPICall", @"", @"info", nil]];
//            }
//            else{
//
//                NSString *strID = [NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"saeID"]];
//                userInfo.numCWID = [strID integerValue];
//                userInfo.strCWID = strID;
//                userInfo.cwID = strID;
//                userInfo.saeID = strID;
//
//                userInfo.clientID = [NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"clientID"]];
//                userInfo.numClientID = [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"clientID"]] integerValue];
//                userInfo.numMspClientID = [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"MSPClientID"]] integerValue];
//                userInfo.numMspID = [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"MspId"]] integerValue];
//                userInfo.numSupplierID = [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"SupplierId"]] integerValue];
//                userInfo.numUserID = [[NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"UserId"]] integerValue];
//                userInfo.strSessionKey = [NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"SessionKey"]];
//                userInfo.sessionKey = [NSString stringWithFormat:@"%@",[[appDelegate.mutAryCWNumbers objectAtIndex:indexPath.row] valueForKey:@"SessionKey"]];
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"clientChange" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"isAPICall", @"", @"info", nil]];
//            }
//
//        }else{
//            userInfo.clientName = [[clientListArray  objectAtIndex:indexPath.row] clientName];
//            userInfo.clientID = [[clientListArray  objectAtIndex:indexPath.row] clientID];
//            userInfo.mspClientID = [[clientListArray  objectAtIndex:indexPath.row] mspClientID];
//
//            userInfo.numMspClientID = [[[clientListArray  objectAtIndex:indexPath.row] mspClientID] integerValue];
//            userInfo.numClientID = [[[clientListArray  objectAtIndex:indexPath.row] clientID] integerValue];
//            userInfo.strClientName = [[clientListArray  objectAtIndex:indexPath.row] clientName];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"clientChange" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[clientListArray objectAtIndex:indexPath.row], @"info", nil]];
//        }
        
        
    }
   // userInfo.isSlider = NO;
    [SliderView hideSlider];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return appDelegate.isIphone? 110:140;
    }
    else if (section == 1)
    {
        return 0.1;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *changeClientLabel = [[UILabel alloc] init];
    return changeClientLabel;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *changeClientLabel = [[UILabel alloc] init];
    if(section == 0)
    {
        int x_pos  = 0;
        int y_pos = 10;
        UIView *headerbaseview = [[UIView alloc] init];
        headerbaseview.backgroundColor = [UIColor clearColor];
      //  headerbaseview.backgroundColor = [appDelegate getColorFromColorCode:BlueColor3];
        headerbaseview.tag = 1;
        UIImageView *logoView1=[[UIImageView alloc]initWithFrame:CGRectMake(appDelegate.isIphone?70:110, y_pos, appDelegate.isIphone?50:75, appDelegate.isIphone?50:75)];
        logoView1.image = [UIImage imageNamed:@"AppIcon"];
        logoView1.frame = CGRectMake(appDelegate.isIphone?sliderView.frame.size.width/2-25:sliderView.frame.size.width/2-38, y_pos, appDelegate.isIphone?50:75, appDelegate.isIphone?50:75);
        [headerbaseview addSubview:logoView1];
        y_pos = logoView1.frame.origin.y+logoView1.frame.size.height+2;
        UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(x_pos,y_pos , sliderView.frame.size.width , 44)];
        nameLbl.numberOfLines = 0;
        nameLbl.font = [UIFont systemFontOfSize:12];
        nameLbl.textAlignment = NSTextAlignmentCenter;
        
//        NSString *userName;
//        if ([CommonMethods checkisStringNotEmpty:[NSString stringWithFormat:@"%@",userInfo.strEnvironementName]]) {
//            userName = [NSString stringWithFormat:@"%@ - %@ %@ : %@\n%@", userInfo.strEnvironementName, AppLabel, [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]], userInfo.strUserType, [[userInfo.strUserName componentsSeparatedByString:@","] lastObject]];
//        }else{
//            userName = [NSString stringWithFormat:@"%@  %@ : %@\n%@", AppLabel,[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]], userInfo.strUserType, [[userInfo.strUserName componentsSeparatedByString:@","] lastObject]];
//        }
//
        NSString *usersName = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
        nameLbl.text=[NSString stringWithFormat:@"Hello, %@", usersName];
        [nameLbl setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightBlack]];
        nameLbl.textColor = [UIColor whiteColor];
        [headerbaseview addSubview:nameLbl];
        UIView *layerview = [[UIView alloc] initWithFrame:CGRectMake(0, headerbaseview.frame.size.height, sliderView.frame.size.width, 1)];
        
        layerview.backgroundColor = [UIColor whiteColor];
        [headerbaseview addSubview:layerview];
        
        
        return headerbaseview;
        
    }
    return changeClientLabel;
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:sliderView]) {
        isTapped = NO;
        [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
        return YES;
    }
    return  YES;
    
}

+(void) tapGestureHandler:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:sender.view];
    UIView *viewTouched = [sender.view hitTest:point withEvent:nil];
    
    if ([viewTouched isKindOfClass:[UITableViewCell class]]) {
        // Do nothing;
    } else if([viewTouched isKindOfClass:[UIView class]]) {
        if(isTapped)
        {
            isTapped = NO;
           [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
            [SliderView hideSlider];
        }
        else if (point.x > sliderView.frame.size.width)
        {
            isTapped = NO;
            [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
            [SliderView hideSlider];
        }
    }
}

+(void)showSlider{
    
//    if (userInfo.numUserTypeID == CWTypeID || userInfo.numUserTypeID == MSPTypeID) {
//        actionsListArray = [[NSArray alloc] initWithObjects:@"Logout", @"Exit", nil];
//    }else{
//        actionsListArray = [[NSArray alloc] initWithObjects:@"Logout", @"Exit", userInfo.clientName, nil];
//    }
    
    [appDelegate.window bringSubviewToFront:sliderView];
   // [SliderView updateTableData];
//    isTapped = YES;
//    [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        baseview.frame = CGRectMake(0, 113, screenWidth, screenHeight - 113);
        sliderView.frame=CGRectMake(0, 3, 280, (appDelegate.window.frame.size.height-113));
    }else{
        baseview.frame = CGRectMake(0, 60, screenWidth, screenHeight - 60);
        sliderView.frame=CGRectMake(0, 3, 180, (appDelegate.window.frame.size.height-60));
    }
    
    [UIView commitAnimations];
}

+(void)hideSlider{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        baseview.frame = CGRectMake(0, 113, screenWidth, screenHeight - 113);
        sliderView.frame=CGRectMake(0, 3, 280, (appDelegate.window.frame.size.height-113));
    }else{
        baseview.frame = CGRectMake(-screenWidth, 60, screenWidth, screenHeight - 60);
        sliderView.frame=CGRectMake(-(sliderView.frame.size.width), 3, 180, (appDelegate.window.frame.size.height-60));
    }
    
    isTapped = NO;
    [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
   // [[NSNotificationCenter defaultCenter] postNotificationName:ENABLEACCESSIBILITYONVIEW object:nil];
    [UIView commitAnimations];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            exit(0);
        }
    }else if (alertView.tag==120) {
        if (buttonIndex==1) {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserId"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"userName"];
            [appDelegate.navigationController popToRootViewControllerAnimated:YES];
            NSLog(@"logout");
        }
    }
}


@end


