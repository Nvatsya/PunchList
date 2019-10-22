//
//  AddNewDeptController.m
//  PunchList
//
//  Created by apple on 26/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AddNewDeptController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "TableViewCell.h"
#import "DataConnection.h"
#import "VSProgressHud.h"
#import "AppDelegate.h"
#import "DropdownDataManager.h"

@interface AddNewDeptController ()
{
    NSMutableArray *fieldsArr;
    NSMutableArray *dataArray;
    NSString *ufname, *ulname, *uemail, *mobilestr;
    UITextField *selectedTF;
    NSDictionary *lableDict;
    NSMutableData *downloadData;
    DataConnection *dataCon;
    AppDelegate *appDel;
}
@end

@implementation AddNewDeptController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForActions:self forScreen:@"Department List"];
    [self createFieldsInfo];
    [Form createFormWithList:self forAction:@"dept" fieldsInfo:fieldsArr];
    appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dataArray = [[NSMutableArray alloc] initWithArray:appDel.departmentArr];
    lableDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Department",@"deptlbl",@"Admin Name",@"namelbl",@"Admin Email",@"emaillbl", nil];
    
    //[self fetchDepartmentList];
}

-(void)createFieldsInfo
{
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Department name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"101",@"tagval", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Department's Admin name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"102",@"tagval", nil];
    NSDictionary *field3Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Admin Email",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"103",@"tagval", nil];
    NSDictionary *field4Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Admin Mobile number",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"104",@"tagval", nil];
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
    [fieldsArr addObject:field3Dict];
    [fieldsArr addObject:field4Dict];
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
    [cell createCellForViewController:self forList:@"dept" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataDict andFieldName:lableDict];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
//-(void)fetchDepartmentList{
//    [VSProgressHud presentIndicator:self];
//    
//    NSString *urlstr = baseURL;
//    NSString *myUrlString = [NSString stringWithFormat:@"%@Department/GetAllRecord",urlstr];
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
-(void)handleAddNewAction{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        if (ufname.length>0 && ulname.length>0 && uemail.length>0 && mobilestr.length>0) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:@"" forKey:@"DepartmentId"];
            [dict setValue:ufname forKey:@"DepartmentName"];
            [dict setValue:ulname forKey:@"DepartmentAdmin"];
            [dict setValue:uemail forKey:@"DepartmentAdminEmail"];
            [dict setValue:mobilestr forKey:@"DepartmentAdminMobile"];
            
            //Building json string for login request.
            NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
            NSString *urlstr = baseURL;
            NSString *myUrlString = [NSString stringWithFormat:@"%@Department/CreateNewDepartment",urlstr];
            
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadListData) name:@"DataWithNewDept" object:nil];
        DropdownDataManager *dataManager = [[DropdownDataManager alloc] init];
        [dataManager getListDataForDepartmentDropdown];
    }
    [VSProgressHud removeIndicator:self];
}
-(void)reloadListData
{
    [dataArray removeAllObjects];
    dataArray = appDel.departmentArr;
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
    if (textField.tag==104) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
    }else if (textField.tag==103) {
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==101) {
        ufname = textField.text;
    }else if (textField.tag==102){
        ulname = textField.text;
    }else if (textField.tag==103){
        if ([self validateEmailWithString:textField.text]) {
            uemail = textField.text;
        }else{
            textField.text=@"";
            [CommonClass showAlert:self messageString:@"Invalid Email" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        }
        
    }else if (textField.tag==104){
        mobilestr = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    selectedTF = nil;
    [textField resignFirstResponder];
    return YES;
}

/* Method: validateEmailWithString
 * Purpose: validate Email
 * Input Params: user entered text in Email/UserName field
 * Output: If valid email return YES, if not return NO.
 */
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
