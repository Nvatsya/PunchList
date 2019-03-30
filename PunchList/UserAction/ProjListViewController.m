//
//  ProjListViewController.m
//  PunchList
//
//  Created by apple on 21/10/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "ProjListViewController.h"
#import "InterfaceViewController.h"
#import "TableViewCell.h"
#import "VSProgressHUD.h"
#import "DataConnection.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "PunchViewController.h"
#import "SliderView.h"

@interface ProjListViewController ()
{
    DataConnection *dataCon;
    NSMutableArray *dataArray;
    NSDictionary *lableDict;
}
@end

@implementation ProjListViewController

-(void)showSlideMenuItem
{
    BOOL isTapped = (BOOL) [[NSUserDefaults standardUserDefaults] valueForKey:@"isTapped"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isTapped"]) {
        [SliderView hideSlider];
    }else{
        isTapped = 1;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isTapped] forKey:@"isTapped"];
        [SliderView showSlider];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    lableDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Code",@"ProjectCode",@"Name",@"ProjectName",@"Total Punch",@"PunchIssues", nil];
    
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:@"My Projects"];
    [InterfaceViewController createListView:self];
    
    [SliderView createSliderForView:self withActionList:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self fetchProjectList];
}
#pragma mark - LoadProjectList by calling API
-(void)fetchProjectList{
    [VSProgressHud presentIndicator:self];
    
    NSString *urlstr = baseURL;
    NSString *myUrlString = [NSString stringWithFormat:@"%@Project/GetAllRecord",urlstr];
    
    if ([CommonClass connectedToInternet]) {
        dataCon = [[DataConnection alloc] initGetDataWithUrlString:myUrlString withJsonString:@"" delegate:self];
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
    
    [dataCon setAccessibilityLabel:@"fetch"];
    
}

-(void)dataLoadingFinished:(NSMutableData*)data{
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"login data is...%@",responseString);
    NSArray *projListArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    UIView *formV = [self.view viewWithTag:5001];
    [formV removeFromSuperview];
    UIView *tableV = [self.view viewWithTag:1001];
    [tableV removeFromSuperview];
    
    [InterfaceViewController createListView:self];
    
    if ([projListArray count]!=0) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:projListArray];
        
        for (UIView *tableV in [self.view subviews]) {
            
            if ([tableV isKindOfClass:[UITableView class]]) {
                UITableView *listTable = (UITableView*)tableV;
                NSLog(@"table %@",listTable);
                [listTable reloadData];
            }
        }
    }
    [VSProgressHud removeIndicator:self];
}

#pragma mark - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=(TableViewCell *)[[TableViewCell alloc] init];
    }
    NSDictionary *dataDict = [dataArray objectAtIndex:indexPath.row];
    [cell createCellForProjectList:self onTable:tableView forList:@"" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataDict forLables:lableDict];
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Update\nPunch" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self updatePunchDetails:indexPath.row];
    }];
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Create\nPunch" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self updatePunchDetails:indexPath.row];
    }];
    
    editAction.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    addAction.backgroundColor = [CommonClass getColorFromColorCode:createColor];
    
    if ([[[dataArray objectAtIndex:indexPath.row] valueForKey:@"PunchIssues"] count]>0) {
        return @[editAction];
    }else{
        return @[addAction];
    }
    return nil;
}
- (void)updatePunchDetails:(NSInteger)rowItem {
    NSLog(@"Edit action clicked %@",[dataArray objectAtIndex:rowItem]);
    PunchViewController *punch = [[PunchViewController alloc] init];
    punch.detailDict = [dataArray objectAtIndex:rowItem];
    [self.navigationController pushViewController:punch animated:YES];
}
- (void)addPunchDetails:(NSInteger)rowItem {
    NSLog(@"add action clicked %@",[dataArray objectAtIndex:rowItem]);
    
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ProjDetailViewController *detail = [[ProjDetailViewController alloc] init];
//    detail.detailDict = [dataArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
