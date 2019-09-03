//
//  ReportsViewController.m
//  PunchList
//
//  Created by Nitin Vatsya on 25/08/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import "ReportsViewController.h"
#import "InterfaceViewController.h"
#import "SliderView.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "DataConnection.h"
#import "AppDelegate.h"

@interface ReportsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *reportOptionArray;
    NSMutableArray *dropDownArray;
    UITableView *optionListView;
    UITableView *dropDownList;
    DataConnection *dataCon;
    UIPickerView *optPicker;
    NSString *selectedType, *selectedItemCode;
    AppDelegate *appDel;
    UILabel *instructionLabel;
}
@end

@implementation ReportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForActions:self forScreen:@"Generate Report"];
    [InterfaceViewController addSlideMenuToView:self];
    
    instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/24, self.view.frame.size.height/9, self.view.frame.size.width-(self.view.frame.size.width/12), 25)];
    // instructionLabel.text = @"Swipe cell left to get Punch options";
    instructionLabel.text = @"Select any one type to generate report.";
    [instructionLabel setTextColor:[CommonClass getColorFromColorCode:themeColor]];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:instructionLabel];
    
    NSArray *slideActions = [NSArray arrayWithObjects:@"Landing",@"New User",@"New Project",@"New Department",@"New Status", nil];
    [SliderView createSliderForView:self withActionList:slideActions];
    reportOptionArray = [[NSArray alloc] initWithObjects:@"Punch",@"Department",@"Project", nil];
    [self createReportTypeView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createDropdownListView];
    [self hideDropdownListView];
}
-(void)createReportTypeView
{
    optionListView = [[UITableView alloc]initWithFrame:CGRectMake(0, instructionLabel.frame.origin.y+instructionLabel.frame.size.height, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    optionListView.delegate = self;
    optionListView.dataSource = self;
    optionListView.tag = 200;
   // optionListView.center = self.view.center;
    [optionListView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:optionListView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 200){
        return [reportOptionArray count];
    }else{
        return [dropDownArray count];
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
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    if (tableView.tag == 200){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ wise", [reportOptionArray objectAtIndex:indexPath.row]];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        if ([selectedType isEqualToString:@"Department"]) {
            cell.textLabel.text = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"DepartmentName"];
        }
        if ([selectedType isEqualToString:@"Project"]) {
            cell.textLabel.text = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"ProjectName"];
        }
        if ([selectedType isEqualToString:@"Punch"]) {
            cell.textLabel.text = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"StatusDetail"];
        }
        
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [accessoryView setBackgroundColor:[UIColor clearColor]];
    [cell setAccessoryView:accessoryView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UIView *layerview = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, tableView.frame.size.width, 1)];
    layerview.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:layerview];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [accessoryView setImage:[UIImage imageNamed:@"checkMark64.png"]];
    [cell setAccessoryView:accessoryView];
    
    if (tableView.tag == 200) {
        selectedType = [reportOptionArray objectAtIndex:indexPath.row];
        if (indexPath.row==1) {
            dropDownArray = appDel.departmentArr;
        }else if (indexPath.row == 2){
            dropDownArray = appDel.projectArr;
        }else{
            dropDownArray = appDel.statusArr;
        }
        
        [self showDropdownListView];
    }else{
        if ([selectedType isEqualToString:@"Department"]) {
            selectedItemCode = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"DepartmentId"];
        }
        if ([selectedType isEqualToString:@"Project"]) {
            selectedItemCode = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"ProjectId"];
        }
        if ([selectedType isEqualToString:@"Punch"]) {
            selectedItemCode = [[dropDownArray objectAtIndex:indexPath.row] valueForKey:@"StatusId"];
        }
        [self getConfirmationToGenerateReport:cell.textLabel.text];
    }
}
-(void)getConfirmationToGenerateReport :(NSString *)itemStr
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reports"
                                                                   message:[NSString stringWithFormat:@"%@ report will be sent to your registered email.",itemStr]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [self hideDropdownListView];
                                 [self->optionListView reloadData];
                             }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [self callingReportAPI];
                             }];
        [alert addAction:cancel];
        [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)showDropdownListView
{
    UIView *listView = [self.view viewWithTag:2200];
    [listView setHidden:NO];;
    [dropDownList reloadData];
}
-(void)hideDropdownListView
{
    UIView *listView = [self.view viewWithTag:2200];
    [listView setHidden:YES];
    //[dropDownList reloadData];
}
-(void)createDropdownListView
{
    UIView *listBgView = [[UIView alloc] initWithFrame:CGRectMake(0, optionListView.frame.origin.y+optionListView.frame.size.height+70, self.view.frame.size.width, 350)];
   // [listBgView setBackgroundColor:[UIColor whiteColor]];
    [listBgView setTag:2200];
    
    UILabel *instructionForItem = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/24, 10, self.view.frame.size.width-(self.view.frame.size.width/12), 25)];
    instructionForItem.text = @"Select an item to generate report.";
    [instructionForItem setTextColor:[CommonClass getColorFromColorCode:themeColor]];
    [instructionForItem setTextAlignment:NSTextAlignmentCenter];
    [listBgView addSubview:instructionForItem];
    
    
    dropDownList = [[UITableView alloc] initWithFrame:CGRectMake(0, instructionForItem.frame.origin.y+instructionForItem.frame.size.height, listBgView.frame.size.width, listBgView.frame.size.height-120) style:UITableViewStylePlain];
    listBgView.center = self.view.center;
    [dropDownList setBackgroundColor:[UIColor clearColor]];
    [dropDownList setDelegate:self];
    [dropDownList setDataSource:self];
    [listBgView addSubview:dropDownList];
    [self.view addSubview:listBgView];
}

-(void)createOptionPicker :(NSArray*)options
{
    optPicker = [[UIPickerView alloc] init];
    // [optPicker ];
    
}
-(void)callingReportAPI
{
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"key", nil];
    NSDictionary *itemDict = [[NSDictionary alloc] initWithObjectsAndKeys:selectedItemCode,@"key", nil];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:userDict forKey:@"ReportRequestUser"];
    [dict setObject:itemDict forKey:selectedType];
    
    //Building json string for login request.
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options: NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *urlstr = baseURL;
    NSString *myUrlString = [NSString stringWithFormat:@"%@RecordExport/ExportFile",urlstr];
    
    dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
    
    NSLog(@"my logurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
}

-(void)dataLoadingFinished:(NSMutableData*)data{
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([[responseDict valueForKey:@"code"] isEqualToString:@"EXPORTMAIL"]) {
        [CommonClass showAlert:self messageString:[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"value"]] withTitle:@"Reports" OKbutton:@"OK" cancelButton:@"Cancel"];
    }else{
        [CommonClass showAlert:self messageString:[NSString stringWithFormat:@"Temporary error!\nPlease try later."] withTitle:@"Reports" OKbutton:@"OK" cancelButton:@"Cancel"];
    }
    
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
