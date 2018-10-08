//
//  AddNewUserController.m
//  PunchList
//
//  Created by apple on 26/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AddNewUserController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "TableViewCell.h"
#import "DataConnection.h"

@interface AddNewUserController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *fieldsArr;
    NSMutableArray *dataArray;
    NSString *ufname, *ulname, *uemail;
    UITextField *selectedTF;
    NSMutableData *downloadData;
    NSDictionary *lableDict;
}
@end

@implementation AddNewUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:@"User List"];
    [self createFieldsInfo];
    [Form createFormWithList:self forAction:@"user" fieldsInfo:fieldsArr];
    
    dataArray = [[NSMutableArray alloc] init];
    
    lableDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"FirstName",@"namelbl",@"Status",@"statuslbl",@"UserEmail",@"emaillbl", nil];
    
    [self fetchUserList];
}

-(void)createFieldsInfo
{
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"First name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"101",@"tagval",@"YES",@"isRequired", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Last name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"102",@"tagval",@"YES",@"isRequired", nil];
    NSDictionary *field3Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Email Id",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"103",@"tagval",@"YES",@"isRequired", nil];
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
    [fieldsArr addObject:field3Dict];
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
    [cell createCellForViewController:self forList:@"user" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataDict andFieldName:lableDict];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)fetchUserList{
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:@"123" forKey:@"id"];
    NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
    
    NSString *urlstr = baseURL;
    NSString *myUrlString = [NSString stringWithFormat:@"%@Department/GetUser",urlstr];
    
    DataConnection *dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
    
    [dataCon setAccessibilityLabel:@"fetch"];
    NSLog(@"my logurl %@ connection %@",myUrlString, dataCon);
}
-(void)handleAddNewAction
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        if ((ufname.length>0)&&(uemail.length>0)) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:ufname forKey:@"FirstName"];
            [dict setValue:ulname forKey:@"LastName"];
            [dict setValue:uemail forKey:@"UserEmail"];
            [dict setValue:@"noimage" forKey:@"UserProfileImage"];
            [dict setValue:@"nopass" forKey:@"ConfirmPassword"];
            [dict setValue:@"nopasss" forKey:@"Password"];
            [dict setValue:@"UserId" forKey:@"UserId"];
            
            
            //Building json string for login request.
            NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
            NSString *urlstr = baseURL;
            NSString *myUrlString = [NSString stringWithFormat:@"%@User/SaveNewUser",urlstr];
            
            DataConnection *dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
            
            NSLog(@"my logurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
            
        }else{
            [CommonClass showAlert:self messageString:@"Please fill required field" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        }
        
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
    NSLog(@"test");
}

-(void)dataLoadingFinished:(NSMutableData*)data
{
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"login data is...%@",responseString);
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    UIView *formV = [self.view viewWithTag:5001];
    [formV removeFromSuperview];
    UIView *tableV = [self.view viewWithTag:1001];
    [tableV removeFromSuperview];
    [Form createFormWithList:self forAction:@"user" fieldsInfo:fieldsArr];
    
    if ([[responseDict valueForKey:@"UserList"] count]!=0) {
        [dataArray removeAllObjects];
        [dataArray addObjectsFromArray:[responseDict valueForKey:@"UserList"]];

        for (UIView *tableV in [self.view subviews]) {
          
            if ([tableV isKindOfClass:[UITableView class]]) {
                UITableView *listTable = (UITableView*)tableV;
                NSLog(@"table %@",listTable);
                [listTable reloadData];
            }
        }
    }
    
    ufname=@"";
    ulname=@"";
    uemail=@"";
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
    }else if (textField.tag==103){
        if ([self validateEmailWithString:textField.text]) {
            uemail = textField.text;
        }else{
            textField.text=@"";
            [CommonClass showAlert:self messageString:@"Invalid Email" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        }
        
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
