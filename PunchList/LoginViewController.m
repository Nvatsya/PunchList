//
//  ViewController.m
//  PunchList
// test for Master code
//  Created by apple on 12/08/18.
//  Copyright © 2018 gjit. All rights reserved.
// My testing1 code
// Test code change from main branch.
//my testing commit from master branch with text with change.

#import "LoginViewController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "AdminViewController.h"
#import "Common/VSProgressHud.h"
#import "DataConnection.h"
#import "Base64.h"
#import "ProjListViewController.h"
#import "DropdownDataManager.h"


@interface LoginViewController ()
{
    UIButton *button;
    NSString *username, *password;
    UITextField *selectedTF;
    NSMutableData *downloadData;
    UIActivityIndicatorView *spinner;
    DataConnection *dataCon;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[UIViewController prefersStatusBarHidden];
    appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationController setNavigationBarHidden:YES];
    [self createLoginUI];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
   // [self uploadTestImage];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)createLoginUI
{
    [InterfaceViewController createUserInterface:self];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    //Put username field - starts
    UITextField *usernameTF = [[UITextField alloc] init];
    usernameTF.frame = CGRectMake(self.view.frame.size.width/14, self.view.frame.size.height/2.6, self.view.frame.size.width-(self.view.frame.size.width/8), 40);
    usernameTF.tag = 101;
    usernameTF.delegate = self;
    UIColor *color = [UIColor whiteColor];
    usernameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:usernameTF];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user.png"]];
    //iconView.bounds = CGRectInset(iconView.frame, 25, 10);
    iconView.frame = CGRectMake(0, 0, 25, 25);
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [paddingView addSubview:iconView];
    usernameTF.leftView=paddingView;
    usernameTF.leftViewMode=UITextFieldViewModeAlways;
    
    CALayer* borderLayer = [usernameTF layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.opacity = 0.50;
    bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
    [borderLayer addSublayer:bottomBorder];
    //Put username field - End
    
    //Put password field - starts
    UITextField *passwordTF = [[UITextField alloc] init];
    passwordTF.frame = CGRectMake(self.view.frame.size.width/14, usernameTF.frame.size.height+usernameTF.frame.origin.y+30, self.view.frame.size.width-(self.view.frame.size.width/8), 40);
    passwordTF.tag = 102;
    passwordTF.delegate = self;
    passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:passwordTF];
    
    UIImageView *iconView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password.png"]];
    iconView1.bounds = CGRectInset(iconView1.frame, 25, 10);
    iconView1.frame = CGRectMake(0, 0, 25, 25);
    iconView1.contentMode = UIViewContentModeScaleAspectFit;
    [paddingView1 addSubview:iconView1];
    passwordTF.leftView=paddingView1;
    passwordTF.leftViewMode=UITextFieldViewModeAlways;
    
    CALayer* borderLayer1 = [passwordTF layer];
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder1.borderWidth = 1;
    bottomBorder1.opacity = 0.50;
    bottomBorder1.frame = CGRectMake(0, borderLayer1.frame.size.height-1, borderLayer1.frame.size.width, 1);
    [borderLayer1 addSublayer:bottomBorder1];
    //Put password field - End
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(appDel.isIphone?(self.view.frame.size.width-(self.view.frame.size.width/2.3)):(self.view.frame.size.width-(self.view.frame.size.width/4)), passwordTF.frame.origin.y+passwordTF.frame.size.height+40, 140, 30);
    [forgetBtn setTitle:@"Forgot Password?" forState:UIControlStateNormal] ;
    [forgetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:appDel.isIphone?8:16];
    forgetBtn.titleLabel.font = [UIFont fontWithName:@"AvenirLTM" size:appDel.isIphone?8:16];
    [forgetBtn addTarget:self action:@selector(handleForgotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width-40, self.view.frame.size.height/14);
    [loginBtn setCenter: CGPointMake(self.view.center.x, loginBtn.center.y)];
    [loginBtn setTitle:@"Continue" forState:UIControlStateNormal] ;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:appDel.isIphone?18:26];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:appDel.isIphone?18:26];
    [loginBtn addTarget:self action:@selector(handleLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //temp code
    //username = usernameTF.text = @"Harry@insigniamgmt.com"; password = passwordTF.text = @"7266";
}

-(void)handleForgotAction
{
    NSMutableArray *fieldArr = [[NSMutableArray alloc] init];
    NSDictionary *fieldDict1 =[[NSDictionary alloc] initWithObjectsAndKeys:@"User Name",@"fieldname", nil];
    [fieldArr addObject:fieldDict1];
    [CommonClass showPopupWithTextfield:self withTitle:@"Forgot Password" messageString:@"Password will be sent to the registered email id." OKbutton:@"Submit" CancelButton:@"Cancel" textFieldsDetails:fieldArr];
}
-(void)submitUserNameforForgotPassword :(NSString*)username
{
    NSLog(@"forget password submit %@",username);
}
-(void)handleLoginAction
{
     [selectedTF resignFirstResponder];
    username = @"dev@insigniamgmt.com";
    password = @"2328";
    if (username.length!=0 && password.length!=0) {
        [self callLoginMethod];
    }else{
        
//        ProjListViewController *projVC=[[ProjListViewController alloc] init];
//        [self.navigationController pushViewController:projVC animated:YES];
        
      [CommonClass showAlert:self messageString:@"All Fields are mandatory" withTitle:@"" OKbutton:@"" cancelButton:@"OK"];
    }
}


-(void)dataLoadingFinished:(NSMutableData*)data
{
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"login data is...%@",responseString);
}
#pragma mark - Login method
-(void)showLoadingActivity :(UIViewController *)VC needToShow:(BOOL)isNeeded
{
    
    if (isNeeded) {
        
        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
        [spinner.layer setCornerRadius:20];
        [spinner setBackgroundColor:[CommonClass getColorFromColorCode:themeColor]];
        [VC.view addSubview:spinner];
        spinner.center = VC.view.center;
        [spinner startAnimating];
        [VC.view setUserInteractionEnabled:FALSE];
    }else{
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        [spinner hidesWhenStopped];
        [VC.view setUserInteractionEnabled:YES];
    }
    
}
-(void)callLoginMethod
{
    [VSProgressHud presentIndicator:self];
   // [VSProgressHud.indecatorView bringSubviewToFront:self.view];
   
    
    
    NSString *urlstr = baseURL;
    NSString *myUrlString = [NSString stringWithFormat:@"%@User/UserLogin",urlstr];
    
    NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultCon.timeoutIntervalForResource = 60.00;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:myUrlString];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:username forHTTPHeaderField:@"username"];
    [urlRequest setValue:password forHTTPHeaderField:@"userpassword"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSHTTPURLResponse *myresonse = (NSHTTPURLResponse *)response;
                                                           NSLog(@"response is..%ld",[myresonse statusCode]);
                                                           if([myresonse statusCode] == 200)
                                                           {
                                                               self->downloadData = [NSMutableData data];
                                                               [self->downloadData appendData:data];
                                                               [self loginDataLoadingFinished:self-> downloadData];
                                                           }else
                                                           {
                                                               NSLog(@"error is..%@",error.userInfo);
                                                               [CommonClass showAlert:self messageString:@"Authentication failed" withTitle:@"" OKbutton:@"" cancelButton:@"OK"];
                                                           }
                                                           
                                                           [VSProgressHud removeIndicator:self];
                                                       }];
    [dataTask resume];
}


#pragma mark connection delegate methods
-(void)loginDataLoadingFinished:(NSMutableData*)data
{
    DropdownDataManager *dataManager = [[DropdownDataManager alloc] init];
    [dataManager getListDataForUserDropdown];
    [dataManager getListDataForStatusDropdown];
    [dataManager getListDataForDepartmentDropdown];
    [dataManager getListDataForProjectDropdown];
    [dataManager getListDataForPunchIssueDropdown];
    
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"login data is...%@",responseString);
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([[responseDict valueForKey:@"UserId"] length]!=0) {
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"UserId"] forKey:@"UserId"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"FirstName"] forKey:@"userName"];
        if ([[responseDict valueForKey:@"UserType"] isEqualToString:@"Admin"]) {
            AdminViewController *admin=[[AdminViewController alloc] init];
            [self.navigationController pushViewController:admin animated:YES];
        }else{
           // [self getListDataForDropdowns];
            ProjListViewController *projVC=[[ProjListViewController alloc] init];
            [self.navigationController pushViewController:projVC animated:YES];
        }
        
    }
}

-(void)getListDataForDropdowns
{
    dataCon = [[DataConnection alloc] init];
    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch_queue_#1", 0);
    dispatch_async(backgroundQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *myUrlString = [NSString stringWithFormat:@"%@Department/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *deptListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([deptListArray isKindOfClass:[NSArray class]]&&[deptListArray count]!=0) {
                    NSArray *departmentArr = [[NSArray alloc] initWithArray:deptListArray];
                    [[NSUserDefaults standardUserDefaults] setObject:departmentArr forKey:@"departmentArr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *myUrlString = [NSString stringWithFormat:@"%@User/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *listArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                NSMutableArray *userListArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dict in listArray) {
                    if ([[dict valueForKey:@"Status"] isEqualToString:@"Active"]) {
                        NSDictionary *userDict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"FirstName"],[dict valueForKey:@"LastName"]],@"UserName",[dict valueForKey:@"UserId"],@"UserId",[dict valueForKey:@"UserEmail"],@"UserEmail",[dict valueForKey:@"UserType"],@"UserType", nil];
                        [userListArray addObject:userDict];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:userListArray forKey:@"usersArr"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *myUrlString = [NSString stringWithFormat:@"%@Status/GetAllRecord",baseURL];
            
            [self->dataCon requestListWithUrl:myUrlString bodyDic:nil withResponseData:^(NSData *bodyData) {
                NSArray *userListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([userListArray isKindOfClass:[NSArray class]]&&[userListArray count]!=0) {
                    NSArray *statusArr = [[NSArray alloc] initWithArray:userListArray];
                    [[NSUserDefaults standardUserDefaults] setObject:statusArr forKey:@"statusArr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
                
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [VSProgressHud removeIndicator:self];
          //  [ self->pickerV reloadAllComponents];
        });
        
    });
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
        username = textField.text;
    }else if (textField.tag==102){
        password = textField.text;
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


@end
