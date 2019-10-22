//
//  AddNewProjController.m
//  PunchList
//
//  Created by apple on 26/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AddNewProjController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "TableViewCell.h"
#import "DataConnection.h"
#import "VSProgressHud.h"
#import "AppDelegate.h"
#import "DropdownDataManager.h"

@interface AddNewProjController ()
{
    NSMutableArray *fieldsArr;
    NSMutableArray *dataArray;
    NSString *ufname, *ulname, *uemail;
    UITextField *selectedTF;
    NSMutableData *downloadData;
    DataConnection *dataCon;
    NSDictionary *lableDict;
    AppDelegate *appDel;
}
@end

@implementation AddNewProjController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForActions:self forScreen:@"Project List"];
    [self createFieldsInfo];
    [Form createFormWithList:self forAction:@"proj" fieldsInfo:fieldsArr];
    appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dataArray = [[NSMutableArray alloc] initWithArray:appDel.projectArr];
    
    lableDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Project Name",@"namelbl",@"Project Code",@"statuslbl", nil];
    
    //[self fetchProjectList];
    
}
-(void)createFieldsInfo
{
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Project name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"101",@"tagval", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Project code",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"102",@"tagval", nil];
    
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
}
-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = newBackButton;
}
-(void)backAction
{
    [self.navigationController popToViewController:[[self.navigationController viewControllers]objectAtIndex:1] animated:YES];
}

#pragma mark - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=(TableViewCell *)[[TableViewCell alloc] init];
    }
    
    NSDictionary *dataDict = [dataArray objectAtIndex:indexPath.row];
    [cell createCellForViewController:self forList:@"project" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataDict andFieldName:lableDict];
    
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//-(void)fetchProjectList{
//    [VSProgressHud presentIndicator:self];
//    
//    NSString *urlstr = baseURL;
//    NSString *myUrlString = [NSString stringWithFormat:@"%@Project/GetAllRecord",urlstr];
//    
//    if ([CommonClass connectedToInternet]) {
//        dataCon = [[DataConnection alloc] initGetDataWithUrlString:myUrlString withJsonString:@"" delegate:self];
//    }else{
//        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
//    }
//    
//    [dataCon setAccessibilityLabel:@"fetch"];
//    
//}

-(void)handleAddNewAction
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        if (ufname.length>0 && ulname>0) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:ufname forKey:@"ProjectName"];
            [dict setValue:ulname forKey:@"ProjectCode"];
            [dict setValue:@"UserId" forKey:@"ProjectId"];
            //Building json string for login request.
            NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
            NSString *urlstr = baseURL;
            NSString *myUrlString = [NSString stringWithFormat:@"%@Project/CreateNewProject",urlstr];
            
            dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
            [dataCon setAccessibilityLabel:@"addNew"];
            [VSProgressHud presentIndicator:self];
            NSLog(@"my logurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
        }else{
            [CommonClass showAlert:self messageString:@"Please fill required field" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        }
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
}

-(void)dataLoadingFinished:(NSMutableData*)data{
    
    if ([[dataCon accessibilityLabel] isEqualToString:@"addNew"]==YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListData) name:@"DataWithNewProj" object:nil];
        DropdownDataManager *dataManager = [[DropdownDataManager alloc] init];
        [dataManager getListDataForProjectDropdown];
    }
    
    [VSProgressHud removeIndicator:self];
    ufname=@"";
    ulname=@"";
    uemail=@"";
}
-(void)reloadListData
{
    [dataArray removeAllObjects];
    dataArray = appDel.projectArr;
    UIView *formV = [self.view viewWithTag:5001];
        [formV removeFromSuperview];
        UIView *tableV = [self.view viewWithTag:1001];
        [tableV removeFromSuperview];
        [Form createFormWithList:self forAction:@"user" fieldsInfo:fieldsArr];
        
            
            for (UIView *tableV in [self.view subviews]) {
                
                if ([tableV isKindOfClass:[UITableView class]]) {
                    UITableView *listTable = (UITableView*)tableV;
                    NSLog(@"table %@",listTable);
                    [listTable reloadData];
                }
            }
}
#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor whiteColor]];
    selectedTF = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==101) {
        ufname = textField.text;
    }else if (textField.tag==102){
        ulname = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    selectedTF = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
