//
//  SliderView.m
//
//  Created by User1 on 3/30/19.
//
//

#import "SliderView.h"
#import "AppDelegate.h"
#import "AddNewuserController.h"
#import "AddNewDeptController.h"
#import "AddNewProjController.h"
#import "AddNewStatusController.h"


AppDelegate *appDelegate;
UIView *currentView;
NSMutableArray *actionsListArray;
NSArray *userActionsArray;
BOOL isTapped;
UIView *baseview;
SliderView *sliderView;
@implementation SliderView
{
    
}
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
    userActionsArray = [NSArray arrayWithObjects:@"Logout",@"Exit", nil];
    [actionsListArray addObjectsFromArray:ActionList];
    
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    baseview = [[UIView alloc] initWithFrame:CGRectMake(-screenWidth, appDelegate.isIphone?70:80, screenWidth, screenHeight - 70)];
    baseview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    baseview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    tapGesture.cancelsTouchesInView = NO;
    
    [baseview addGestureRecognizer:tapGesture];
    tapGesture.numberOfTapsRequired=1;
    tapGesture.delegate = self;
    
    
    sliderView= [[SliderView alloc] initWithFrame:CGRectMake(-180, 3, appDelegate.isIphone?180:280, rect.size.height-(appDelegate.isIphone?70:80)) style:UITableViewStyleGrouped];
    sliderView.delegate=sliderView;
    sliderView.dataSource=sliderView;
    sliderView.tag = 2;
    sliderView.userInteractionEnabled = YES;
    sliderView.alpha = 1;
    
    [baseview addSubview:sliderView];
    [appDelegate.window addSubview:baseview];
    sliderView.frame = CGRectMake(-180, 3, 180, rect.size.height-70);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        sliderView.frame=CGRectMake(-280, 3, 280, rect.size.height-80);
    }
    sliderView.backgroundColor = [UIColor lightGrayColor];//[appDelegate getColorFromColorCode:@"#444755"];
    sliderView.bounces=NO;
    isTapped = NO;
    [[NSUserDefaults standardUserDefaults] setBool:isTapped forKey:@"isTapped"];
    return sliderView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger section = 1;
    if (actionsListArray.count>0) {
        section = 2;
    }
    return section;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return userActionsArray.count;
    }
    else if (section == 1){
        return actionsListArray.count;
    }
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
    if (indexPath.section == 0) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [userActionsArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:appDelegate.isIphone?12:15 weight:UIFontWeightBlack];
    } else if (indexPath.section==1){
        cell.textLabel.text = [actionsListArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:appDelegate.isIphone?12:15 weight:UIFontWeightThin];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1];
    }
    
    cell.backgroundColor = [UIColor clearColor];
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
        if (indexPath.row==0) {
            [appDelegate.navigationController popViewControllerAnimated:YES];
        }else if (indexPath.row==1) {
            AddNewUserController *userS = [[AddNewUserController alloc] init];
            [appDelegate.navigationController pushViewController:userS animated:YES];
        }else if (indexPath.row==2) {
            AddNewProjController *projS = [[AddNewProjController alloc] init];
            [appDelegate.navigationController pushViewController:projS animated:YES];
        }else if (indexPath.row==3) {
            AddNewDeptController *deptS = [[AddNewDeptController alloc] init];
            [appDelegate.navigationController pushViewController:deptS animated:YES];
        }else if (indexPath.row==4) {
            AddNewStatusController *statusS = [[AddNewStatusController alloc] init];
            [appDelegate.navigationController pushViewController:statusS animated:YES];
        }
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
        
        NSString *usersName = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
        nameLbl.text=[NSString stringWithFormat:@"Hello, %@", usersName];
        [nameLbl setFont:[UIFont systemFontOfSize:appDelegate.isIphone?12:15 weight:UIFontWeightBlack]];
        nameLbl.textColor = [UIColor whiteColor];
        [headerbaseview addSubview:nameLbl];
        UIView *layerview = [[UIView alloc] initWithFrame:CGRectMake(0, headerbaseview.frame.size.height, sliderView.frame.size.width, 1)];
        
        layerview.backgroundColor = [UIColor whiteColor];
        [headerbaseview addSubview:layerview];
        
        
        return headerbaseview;
        
    }else{
        UIView *headerbaseview = [[UIView alloc] init];
        headerbaseview.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, 0, 150, 22);
        titleLabel.text = @"Navigate To :";
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerbaseview addSubview:titleLabel];
        return headerbaseview;
    }
    return nil;
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
    
    [appDelegate.window bringSubviewToFront:sliderView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        baseview.frame = CGRectMake(0, 80, screenWidth, screenHeight - 80);
        sliderView.frame=CGRectMake(0, 3, 280, (appDelegate.window.frame.size.height-70));
    }else{
        baseview.frame = CGRectMake(0, 70, screenWidth, screenHeight - 70);
        sliderView.frame=CGRectMake(0, 3, 180, (appDelegate.window.frame.size.height-60));
    }
    
    [UIView commitAnimations];
}

+(void)hideSlider{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        baseview.frame = CGRectMake(-screenWidth, 80, screenWidth, screenHeight - 80);
        sliderView.frame=CGRectMake(-(sliderView.frame.size.width), 3, 280, (appDelegate.window.frame.size.height-70));
    }else{
        baseview.frame = CGRectMake(-screenWidth, 70, screenWidth, screenHeight - 70);
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


