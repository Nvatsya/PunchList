//
//  ProjDetailsViewController.m
//  PunchList
//
//  Created by Nitin Vatsya on 23/07/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import "ProjDetailsViewController.h"
#import "InterfaceViewController.h"
#import "PunchViewController.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "TableViewCell.h"
#import "AppDelegate.h"

@interface ProjDetailsViewController ()
{
    UIView *projDetailsView;
    UITableView *punchList;
    NSDictionary *lableDict;
    AppDelegate *appDel;
}

@end

@implementation ProjDetailsViewController
@synthesize projDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    lableDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Punch Name", @"PunchName", @"Description", @"PunchDetail", @"Created On", @"PunchDate", @"Assigned To", @"PunchHolder", @"Status", @"PunchStatus", nil];
    [InterfaceViewController createInterfaceForActions:self forScreen:[NSString stringWithFormat:@"%@",[self.projDict valueForKey:@"ProjectName"]]];
     [InterfaceViewController createListView:self];
    [self createViewForProjDetails];
   // [self createViewForPunchList];
    [self addCreatePunchButton];
}
-(void)addCreatePunchButton
{
    UIButton *punchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    punchBtn.frame = CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width-40, self.view.frame.size.height/14);
    [punchBtn setCenter: CGPointMake(self.view.center.x, punchBtn.center.y)];
    [punchBtn setTitle:@"Create Punch" forState:UIControlStateNormal] ;
    [punchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    punchBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    punchBtn.titleLabel.font = [UIFont systemFontOfSize:appDel.isIphone?18:26];
    punchBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:appDel.isIphone?18:26];
    [punchBtn addTarget:self action:@selector(createPunchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:punchBtn];
}
-(void)createViewForProjDetails
{
    projDetailsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    [projDetailsView.layer setBorderColor:[UIColor blackColor].CGColor];
    [projDetailsView.layer setBorderWidth:0.5];
    [projDetailsView.layer setOpaque:YES];
    [projDetailsView.layer setShadowOffset:CGSizeMake(5, 1)];
    [self.view addSubview:projDetailsView];
    
    //Adding Labels for Project details info
    UILabel *codeLbl = [[UILabel alloc] init];
    codeLbl.frame = CGRectMake(5, self.view.frame.size.height/10.5, 100,25);
    [codeLbl setText:@"Code : "];
    [codeLbl setTextColor:[CommonClass getColorFromColorCode:lableColor]];
    [projDetailsView addSubview:codeLbl];
    
    UILabel *projNameLbl = [[UILabel alloc] init];
    projNameLbl.frame = CGRectMake(codeLbl.frame.origin.x+codeLbl.frame.size.width+5, codeLbl.frame.origin.y, self.view.frame.size.width-105,25);
    [projNameLbl setText:[NSString stringWithFormat:@"%@",[self.projDict valueForKey:@"ProjectCode"]]];
    [projNameLbl setTextColor:[CommonClass getColorFromColorCode:fontColor]];
    [projDetailsView addSubview:projNameLbl];
    
    UILabel *addLbl = [[UILabel alloc] init];
    addLbl.frame = CGRectMake(5, codeLbl.frame.origin.y+codeLbl.frame.size.height+5, 100,25);
    [addLbl setText:[NSString stringWithFormat:@"Address :"]];
    [addLbl setTextColor:[CommonClass getColorFromColorCode:lableColor]];
    [projDetailsView addSubview:addLbl];
    
    UILabel *projAddLbl = [[UILabel alloc] init];
    projAddLbl.frame = CGRectMake(addLbl.frame.origin.x+addLbl.frame.size.width+5, addLbl.frame.origin.y, self.view.frame.size.width-105,45);
    [projAddLbl setNumberOfLines:2];
    [projAddLbl setText:[NSString stringWithFormat:@"Short Address of Project (will remove it, if not require)"]]; //[self.projDict valueForKey:@"ProjectAddress"]
    [projAddLbl setTextColor:[CommonClass getColorFromColorCode:fontColor]];
    [projDetailsView addSubview:projAddLbl];
    
    UILabel *dateLbl = [[UILabel alloc] init];
    dateLbl.frame = CGRectMake(5, addLbl.frame.origin.y+projAddLbl.frame.size.height+5, 100,25);
    [dateLbl setText:[NSString stringWithFormat:@"Created On :"]];
    [dateLbl setTextColor:[CommonClass getColorFromColorCode:lableColor]];
    [projDetailsView addSubview:dateLbl];
    
    UILabel *projdateLbl = [[UILabel alloc] init];
    projdateLbl.frame = CGRectMake(dateLbl.frame.origin.x+dateLbl.frame.size.width+5, dateLbl.frame.origin.y, self.view.frame.size.width-105,25);
    [projdateLbl setText:[self.projDict valueForKey:@"dateCreated"]];
    [projdateLbl setTextColor:[CommonClass getColorFromColorCode:fontColor]];
    [projDetailsView addSubview:projdateLbl];
    
    UILabel *punchLbl = [[UILabel alloc] init];
    punchLbl.frame = CGRectMake(5, projdateLbl.frame.origin.y+projdateLbl.frame.size.height+5, 100,25);
    [punchLbl setText:[NSString stringWithFormat:@"Total Punch :"]];
    [punchLbl setTextColor:[CommonClass getColorFromColorCode:lableColor]];
    [projDetailsView addSubview:punchLbl];
    
    UILabel *totPunchLbl = [[UILabel alloc] init];
    totPunchLbl.frame = CGRectMake(punchLbl.frame.origin.x+punchLbl.frame.size.width+5, punchLbl.frame.origin.y, self.view.frame.size.width-105,25);
    [totPunchLbl setText:[NSString stringWithFormat:@"%lu",(unsigned long)[[self.projDict valueForKey:@"PunchIssues"] count]]];
    [totPunchLbl setTextColor:[CommonClass getColorFromColorCode:fontColor]];
    [projDetailsView addSubview:totPunchLbl];
    
    //Adding instruction to the user
    UILabel *instructionLabel = [[UILabel alloc] init];
    instructionLabel.frame = CGRectMake(5, totPunchLbl.frame.origin.y+totPunchLbl.frame.size.height+15, self.view.frame.size.width,25);
    instructionLabel.text = @"Swipe left to Update or View any of the Punch";
    [instructionLabel setTextColor:[CommonClass getColorFromColorCode:themeColor]];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [projDetailsView addSubview:instructionLabel];
}
-(void)createViewForPunchList
{
    punchList = [[UITableView alloc] initWithFrame:CGRectMake(0, projDetailsView.frame.origin.y+projDetailsView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(projDetailsView.frame.origin.y+projDetailsView.frame.size.height+60)) style:UITableViewStylePlain];
    [punchList setDelegate:self];
    [punchList setDataSource:self];
    [punchList setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:punchList];
}

#pragma mark - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.projDict valueForKey:@"PunchIssues"] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=(TableViewCell *)[[TableViewCell alloc] init];
    }
    NSDictionary *dataDict = [[self.projDict valueForKey:@"PunchIssues"] objectAtIndex:indexPath.row];
    
    [cell createCellForPunchList:self onTable:tableView forList:@"" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataDict forLables:lableDict];
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Update\nPunch" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self updatePunchDetails:indexPath.row];
    }];
//    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Create\nPunch" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        [self updatePunchDetails:indexPath.row];
//    }];
    
    editAction.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
  //  addAction.backgroundColor = [CommonClass getColorFromColorCode:createColor];
    
    if ([[self.projDict valueForKey:@"PunchIssues"] count]>0) {
        return @[editAction];
    }else{
       // return @[addAction];
    }
    return nil;
}
- (void)updatePunchDetails:(NSInteger)rowItem {
    NSLog(@"Edit action clicked %@",[[self.projDict valueForKey:@"PunchIssues"] objectAtIndex:rowItem]);
    PunchViewController *punch = [[PunchViewController alloc] init];
    [punch.detailDict removeAllObjects];
    punch.detailDict = [[self.projDict valueForKey:@"PunchIssues"] objectAtIndex:rowItem];
    punch.isCreateIssue = NO;
    [self.navigationController pushViewController:punch animated:YES];
}
- (void)createPunchAction
{
    PunchViewController *punch = [[PunchViewController alloc] init];
    [punch.detailDict removeAllObjects];
    NSMutableDictionary *tempDict = [self.projDict mutableCopy];
    [tempDict removeObjectForKey:@"PunchIssues"];
    punch.detailDict = tempDict;
    punch.isCreateIssue = YES;
    [self.navigationController pushViewController:punch animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
