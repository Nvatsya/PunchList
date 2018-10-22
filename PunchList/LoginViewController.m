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



@interface LoginViewController ()
{
    UIButton *button;
    NSString *username, *password;
    UITextField *selectedTF;
    NSMutableData *downloadData;
    UIActivityIndicatorView *spinner;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[UIViewController prefersStatusBarHidden];
    [self.navigationController setNavigationBarHidden:YES];
    [self createLoginUI];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
   // [self uploadTestImage];
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
    passwordTF.frame = CGRectMake(self.view.frame.size.width/14, usernameTF.frame.size.height+usernameTF.frame.origin.y+20, self.view.frame.size.width-(self.view.frame.size.width/8), 40);
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
    forgetBtn.frame = CGRectMake(self.view.frame.size.width-(self.view.frame.size.width/2.3), self.view.frame.size.height/1.7, 140, 30);
    [forgetBtn setTitle:@"Forgot Password?" forState:UIControlStateNormal] ;
    [forgetBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    forgetBtn.titleLabel.font = [UIFont fontWithName:@"AvenirLTM" size:8];
    [forgetBtn addTarget:self action:@selector(handleForgotAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width-40, 50);
    [loginBtn setCenter: CGPointMake(self.view.center.x, loginBtn.center.y)];
    [loginBtn setTitle:@"Continue" forState:UIControlStateNormal] ;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    loginBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:18];
    [loginBtn addTarget:self action:@selector(handleLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

-(void)handleForgotAction
{
    NSLog(@"forget");
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
    if (username.length!=0 && password.length!=0) {
        [self callLoginMethod];
    }else{
//        ProjListViewController *projVC=[[ProjListViewController alloc] init];
//        [self.navigationController pushViewController:projVC animated:YES];
        
        [CommonClass showAlert:self messageString:@"All Fields are mandatory" withTitle:@"" OKbutton:@"" cancelButton:@"OK"];
    }
}

-(void)uploadTestImage
{
    //NSString *urlstr = @"http://punch.gjitsolution.in/api/Image/UploadImage";
    NSString *urlstr = @"http://punch.gjitsolution.in/api/Image/GetImage";
    
    NSString *pathStr1 = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"jpg"];
    NSString *pathStr2 = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"jpg"];
    NSData *imgData1 = [NSData dataWithContentsOfFile:pathStr1];
    NSString *image64Str1=[Base64 encode:imgData1];
    
    NSData *imgData2 = [NSData dataWithContentsOfFile:pathStr2];
    NSString *image64Str2=[Base64 encode:imgData2];
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    NSDictionary *jsonDictionary1 = [[NSDictionary alloc] initWithObjectsAndKeys:image64Str1,@"ImgStr",@"misthi_100",@"Id", nil];
    NSDictionary *jsonDictionary2 = [[NSDictionary alloc] initWithObjectsAndKeys:image64Str2,@"ImgStr",@"Pari_100",@"Id", nil];
    [dataArr addObject:jsonDictionary1];
    [dataArr addObject:jsonDictionary2];

    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArr options:0 error:&error];

    NSURLSessionConfiguration *defaultCon = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultCon.timeoutIntervalForResource = 60.00;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultCon delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"Content-Type" forHTTPHeaderField:@"application/json"];
    [urlRequest setHTTPBody:jsonData];
    
    //Building json string for upload request.
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    //NSString *jsonString = [CommonClass convertingToJsonFormat:dataArr];

    DataConnection *dataCon = [[DataConnection alloc] initWithUrlStringFromData:urlstr withJsonString:jsonString delegate:self];


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
                                                           }
                                                           
                                                           [VSProgressHud removeIndicator:self];
                                                       }];
    [dataTask resume];
}


#pragma mark connection delegate methods
-(void)loginDataLoadingFinished:(NSMutableData*)data
{
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"login data is...%@",responseString);
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if ([[responseDict valueForKey:@"UserId"] length]!=0) {
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"UserId"] forKey:@"userToken"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseDict valueForKey:@"FirstName"] forKey:@"userName"];
        if ([[responseDict valueForKey:@"UserType"] isEqualToString:@"Admin"]) {
            AdminViewController *admin=[[AdminViewController alloc] init];
            [self.navigationController pushViewController:admin animated:YES];
        }else{
            ProjListViewController *projVC=[[ProjListViewController alloc] init];
            [self.navigationController pushViewController:projVC animated:YES];
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
