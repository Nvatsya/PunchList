//
//  AddNewStatusController.m
//  PunchList
//
//  Created by apple on 26/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AddNewStatusController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "TableViewCell.h"
#import "DataConnection.h"

@interface AddNewStatusController ()
{
    NSMutableArray *fieldsArr;
    NSMutableArray *dataArr;
    NSString *ufname, *ulname, *uemail;
    UITextField *selectedTF;
    NSMutableData *downloadData;
}
@end

@implementation AddNewStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:@"Status List"];
    [self createFieldsInfo];
    [Form createFormWithList:self forAction:@"status" fieldsInfo:fieldsArr];
    
    dataArr = [[NSMutableArray alloc] init];
    for (int i=0; i<5; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Name",@"namelbl",@"Status",@"statuslbl",@"Email",@"emaillbl", nil];
        [dataArr addObject:dict];
    }
}
-(void)createFieldsInfo
{
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Status name",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"101",@"tagval", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Status code",@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"102",@"tagval", nil];
    
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
}

#pragma mark - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
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
    
   // [cell createCellForViewController:self forList:@"user" heightOfRow:[self tableView:tableView heightForRowAtIndexPath:indexPath] withData:dataArr];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)handleAddNewAction
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:ufname forKey:@"StatusDetail"];
        [dict setValue:ulname forKey:@"StatusCode"];
        [dict setValue:@"UserId" forKey:@"StatusId"];
        
        
        //Building json string for login request.
        NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
        NSString *urlstr = baseURL;
        NSString *myUrlString = [NSString stringWithFormat:@"%@Status/CreateStatus",urlstr];
        
        DataConnection *dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
        
        NSLog(@"my logurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
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
    if ([[responseDict valueForKey:@"UserId"] length]!=0) {
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"UserId"] forKey:@"userToken"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"FirstName"] forKey:@"userName"];
        //        AdminViewController *admin=[[AdminViewController alloc] init];
        //        [self.navigationController pushViewController:admin animated:YES];
    }
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
