//
//  ProjDetailViewController.m
//  PunchList
//
//  Created by apple on 22/10/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "PunchViewController.h"
#import "InterfaceViewController.h"
#import "Form.h"
#import "ConstantFile.h"
#import "VSProgressHUD.h"
#import "DataConnection.h"
#import "CommonClass.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Base64.h"
#import "AppDelegate.h"
#import "PunchImageViewController.h"


@interface PunchViewController ()
{
    NSMutableArray *fieldsArr, *punchImageArr, *imgDataArray;
    NSArray *departmentArr;
    NSArray *usersArr;
    NSArray *statusArr;
    NSArray *pickerDataArr;
    UITapGestureRecognizer *closeTap;
    UIPickerView *pickerV;
    UIImage *selectedImage;
    UIToolbar *toolbar;
    DataConnection *dataCon;
    UITextField *selectedTF;
    NSString *selectedItem;
    NSInteger selectedrow;
    UIAlertController *actionPopup;
    NSData *imageBinaryData;
    NSString *imageBase64data;
    NSString *selectedImageName;
    NSString *updatedDescription;
    NSString *assignedToStr;
    NSString *updatedStatusStr;
    NSString *updatedDeptStr;
    NSString *selectedStatusId;
    NSString *issueName;
    BOOL isSaveNew, isLargeImage;
    AppDelegate *appDel;
}
@end

@implementation PunchViewController
@synthesize detailDict;
@synthesize isCreateIssue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForActions:self forScreen:[NSString stringWithFormat:@"%@",isCreateIssue?@"Create Punch":[self.detailDict valueForKey:@"IssueName"]]];
     //[self getListDataForDropdowns];
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    departmentArr =  appDel.departmentArr; //[[NSUserDefaults standardUserDefaults] valueForKey:@"departmentArr"];
    usersArr = appDel.userArr; //[[NSUserDefaults standardUserDefaults] valueForKey:@"usersArr"];
    statusArr = appDel.statusArr; //[[NSUserDefaults standardUserDefaults] valueForKey:@"statusArr"];
    punchImageArr = [[NSMutableArray alloc] initWithCapacity:0];
    imgDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    pickerV = [[UIPickerView alloc] init];
    [pickerV setDelegate:self];
    [pickerV setDataSource:self];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIBarButtonItem *donebarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDoneAction:)];
    UIBarButtonItem *closebarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(handleCloseAction:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:@[closebarBtn,space,donebarBtn]];
    
    closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeIssueImage:)];
    [closeTap setNumberOfTapsRequired:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedImageWithMark :) name:@"GET_MARKED_IMAGE" object:nil];
    [self createFieldsInfo];
    [Form createPunchView:self fieldsInfo:fieldsArr];
    [self createViewForIssueImage];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!isCreateIssue) {
        [self updateFieldInfo];
    }else{
        if (selectedTF.tag!=5011)
            [self loadPunchFieldValuesForNew];
    }
}
-(void)updateFieldInfo
{
    NSString *departmentName = [[departmentArr objectAtIndex:0]valueForKey:@"DepartmentName"];
    updatedDeptStr = [[departmentArr objectAtIndex:0] valueForKey:@"DepartmentId"];
    NSString *assignedName = @"";
    assignedToStr = isCreateIssue? [[usersArr objectAtIndex:selectedrow] valueForKey:@"UserId"] : [self.detailDict valueForKey:@"AssignedToUserName"];
    updatedStatusStr = isCreateIssue?@"":[self.detailDict valueForKey:@"IssueStatus"];
    updatedDescription = isCreateIssue?@"":[self.detailDict valueForKey:@"IssueDescription"];
    issueName = isCreateIssue?@"":[self.detailDict valueForKey:@"IssueName"];
    //Update data dict with field values
    //get Department name
    for (int i=0; i<[departmentArr count]; i++) {
        if ([[self.detailDict valueForKey:@"DepartmentId"] isEqualToString:[[departmentArr objectAtIndex:i]valueForKey:@"DepartmentId"]]) {
            departmentName = [[departmentArr objectAtIndex:i]valueForKey:@"DepartmentName"];
            updatedDeptStr = [[departmentArr objectAtIndex:i] valueForKey:@"DepartmentId"];
            break;
        }
    }
    
    //get Assigned name
    for (int i=0; i<[usersArr count]; i++) {
        if ([[self.detailDict valueForKey:@"AssignedTo"] isEqualToString:[[usersArr objectAtIndex:i]valueForKey:@"UserId"] ]) {
            [[NSUserDefaults standardUserDefaults] setObject:[[usersArr objectAtIndex:i]valueForKey:@"UserName"]  forKey:@"AssignedName"];
            assignedName = [NSString stringWithFormat:@"%@ %@", [[usersArr objectAtIndex:i]valueForKey:@"FirstName"], [[usersArr objectAtIndex:i]valueForKey:@"LastName"]];
            assignedToStr = [[usersArr objectAtIndex:i] valueForKey:@"UserId"];
            break;
        }
    }
    
    for (int i=0; i<[fieldsArr count]; i++) {
        if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:department]) {
            [[fieldsArr objectAtIndex:i] setValue:departmentName forKey:@"Value"];
        }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:assignedTo]) {
            [[fieldsArr objectAtIndex:i] setValue:assignedName forKey:@"Value"];
        }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:punchStatus]) {
            [[fieldsArr objectAtIndex:i] setValue:updatedStatusStr forKey:@"Value"];
        }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:description]) {
            [[fieldsArr objectAtIndex:i] setValue:updatedDescription forKey:@"Value"];
        }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:punchTitle]) {
            [[fieldsArr objectAtIndex:i] setValue:issueName forKey:@"Value"];
        }
    }
    
    //update screen with values
    UIView *formView = [self.view viewWithTag:5001];
    [formView removeFromSuperview];
    [Form createPunchView:self fieldsInfo:fieldsArr];
}
-(void)loadPunchFieldValuesForNew
{
    UIView *bgView = [self.view viewWithTag:5001];
    for(UITextField *field in [bgView subviews]){
        if (field.tag == 101) {
            updatedDeptStr = [[departmentArr objectAtIndex:0] valueForKey:@"DepartmentId"];
                field.text = [[departmentArr objectAtIndex:0] valueForKey:@"DepartmentName"];;
            }else if (field.tag == 102) {
                field.text = isCreateIssue?@"":[self.detailDict valueForKey:@"AssignedTo"];
                assignedToStr = Nil;
            }else if (field.tag == 103) {
                updatedStatusStr = field.text = [[statusArr objectAtIndex:0] valueForKey:@"StatusDetail"];
                selectedStatusId = [[statusArr objectAtIndex:0] valueForKey:@"StatusId"];
            }else if (field.tag == 104) {
                field.text = @"";
                issueName = Nil;
            }else if (field.tag == 303) {
                field.text = @"";
                updatedDescription = Nil;
            }
        }
    UIScrollView *imgScroll = [self.view viewWithTag:6001];
    for (UIImageView *imgV in [imgScroll subviews]){
        [imgV removeFromSuperview];
    }
    UITextField *txtF = [[self.view viewWithTag:5002] viewWithTag:5011];
    txtF.text = @"";
    imageBase64data = Nil;
    selectedImageName = @"";
    selectedImage= Nil;
    [imgDataArray removeAllObjects];
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
                    self->departmentArr = [[NSArray alloc] initWithArray:deptListArray];
                    self->pickerDataArr =[[NSArray alloc] initWithArray: self->departmentArr];
                    
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
                NSArray *userListArray = [NSJSONSerialization JSONObjectWithData:bodyData options:NSJSONReadingMutableLeaves error:nil];
                
                if ([userListArray isKindOfClass:[NSArray class]]&&[userListArray count]!=0) {
                    self->usersArr = [[NSArray alloc] initWithArray:userListArray];
                    self->pickerDataArr =[[NSArray alloc] initWithArray: self->usersArr];
                }
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
                    self->statusArr = [[NSArray alloc] initWithArray:userListArray];
                    self->pickerDataArr =[[NSArray alloc] initWithArray: self->statusArr];
                }
            } failtureResponse:^(NSError *error) {
                NSLog(@"Error %@",error.localizedDescription);
                
            }checkConnectionStatus: ^(BOOL isNetwork){
                
                [CommonClass showAlert:self messageString:@"No Network" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            }];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [VSProgressHud removeIndicator:self];
            [ self->pickerV reloadAllComponents];
        });
    
    });
}

-(void)createFieldsInfo
{
    NSMutableDictionary *field1Dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: department,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"101",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSMutableDictionary *field2Dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: assignedTo,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"102",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSMutableDictionary *field3Dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: punchStatus,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"103",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
     NSMutableDictionary *field4Dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: description,@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"303",@"tagval",@"YES",@"isRequired",@"textView",@"fieldType", nil];
    NSMutableDictionary *field5Dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: punchTitle,@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"104",@"tagval",@"YES",@"isRequired",@"textfield",@"fieldType", nil];
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
    [fieldsArr addObject:field3Dict];
    [fieldsArr addObject:field4Dict];
    [fieldsArr addObject:field5Dict];
}

// Issue Image section
-(void)createViewForIssueImage
{
    UIView *view = [self.view viewWithTag:5001];
    NSLog(@"bgview height %f and ypos %f",view.frame.size.height, view.frame.origin.y);
    UIView *imageFieldContainer = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, (view.frame.origin.y+view.frame.size.height), view.frame.size.width, self.view.frame.size.height-(view.frame.origin.y+view.frame.size.height+20))];
    [imageFieldContainer setTag:5002];
    [self.view addSubview:imageFieldContainer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,  imageFieldContainer.frame.size.width, 30)];
    label.text = @"Upload Image";
    label.textColor = [UIColor whiteColor];
    [imageFieldContainer addSubview:label];
    
    UITextField *textfield = [[UITextField alloc] init];
    textfield.frame = CGRectMake(0, label.frame.origin.y+label.frame.size.height, imageFieldContainer.frame.size.width, 30);
    textfield.tag = 5011;
    textfield.delegate = self;
    UIColor *color = [UIColor whiteColor];
    textfield.textColor=color;
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Select Image"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [imageFieldContainer addSubview:textfield];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"uploadW.png"]]];
    iconView.bounds = CGRectInset(iconView.frame, 25, 10);
    iconView.frame = CGRectMake(0, 0, 25, 25);
    [paddingView addSubview:iconView];
    textfield.rightView = paddingView;
    textfield.rightViewMode=UITextFieldViewModeAlways;
    
    CALayer* borderLayer = [textfield layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.opacity = 0.50;
    bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
    [borderLayer addSublayer:bottomBorder];
    
    //Adding scroll view for image scroll
    UIScrollView *imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, textfield.frame.origin.y+textfield.frame.size.height, imageFieldContainer.frame.size.width, imageFieldContainer.frame.size.height/2)];
    [imgScroll setTag:6001];
    [imageFieldContainer addSubview:imgScroll];
    
    
    for (int i=0; i<[[self.detailDict valueForKey:@"IssueImages"] count]; i++) {
        NSString *imgURL = [[[self.detailDict valueForKey:@"IssueImages"] objectAtIndex:i] valueForKey:@"ImgStr"];
        NSMutableDictionary *imgDict = [[NSMutableDictionary alloc] init];
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: imgURL]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *issueImage = [UIImage imageWithData: data];
                [imgDict setObject:issueImage forKey:@"image"];
                [imgDict setObject:@"OldImage" forKey:@"imageName"];
                [self->punchImageArr addObject:imgDict];
                [self drawPunchImageOnView];
            });
            
        });
    }
    
    //Adding action button
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *actionNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isCreateIssue) {
        
        actionBtn.frame = CGRectMake(0, imageFieldContainer.frame.size.height-self.view.frame.size.height/18, imgScroll.frame.size.width/2-5, self.view.frame.size.height/14);
        [actionBtn setTitle:@"Save" forState:UIControlStateNormal] ;
        [actionBtn setTag:441] ;
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        actionBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:18];
        [actionBtn addTarget:self action:@selector(handlePunchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //Adding New button
        actionNewBtn.frame = CGRectMake(actionBtn.frame.origin.x+actionBtn.frame.size.width+10, imageFieldContainer.frame.size.height-self.view.frame.size.height/18, imgScroll.frame.size.width/2-5, self.view.frame.size.height/14);
        [actionNewBtn setTitle:@"Save & New" forState:UIControlStateNormal] ;
        [actionNewBtn setTag:443] ;
        [actionNewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionNewBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
        actionNewBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        actionNewBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:18];
        [actionNewBtn addTarget:self action:@selector(handlePunchAction:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        actionBtn.frame = CGRectMake(0, imageFieldContainer.frame.size.height-self.view.frame.size.height/18, imgScroll.frame.size.width, self.view.frame.size.height/14);
        [actionBtn setTitle:@"Update" forState:UIControlStateNormal] ;
        [actionBtn setTag:442] ;
        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
        actionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        actionBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:18];
        [actionBtn addTarget:self action:@selector(handlePunchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [imageFieldContainer addSubview:actionBtn];
    [imageFieldContainer addSubview:actionNewBtn];
}

-(void)getSelectedImageWithMark :(NSNotification *)note
{
    selectedImage = [[note object] valueForKey:@"newImg"];
    NSDictionary *imgDict = [[NSDictionary alloc] initWithObjectsAndKeys:selectedImage,@"image",selectedImageName,@"imageName", nil];
    [punchImageArr addObject:imgDict];
    [self getBinaryDataForImage];
    [self drawPunchImageOnView];
}
#pragma mark - API calls handler
-(void)callingAddNewPunch
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
       // [dict setValue:[self.detailDict valueForKey:@"IssueId"] forKey:@"IssueId"];
        [dict setValue:[self.detailDict valueForKey:@"ProjectId"] forKey:@"ProjectId"];
        [dict setValue:updatedStatusStr forKey:@"IssueStatus"];
        if (issueName.length!=0) {
            [dict setValue: issueName forKey:@"IssueName"];
        }
        if (updatedDescription.length!=0) {
            [dict setValue:updatedDescription forKey:@"IssueDescription"];
        }
        [dict setValue:assignedToStr forKey:@"AssignedTo"];
        [dict setValue:updatedDeptStr forKey:@"DepartmentId"];
        [dict setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]] forKey:@"CreatedBy"];
        [dict setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"CreatedOn"];
        [dict setValue:imgDataArray forKey:@"IssueImages"];
        
        if ([dict count]<9) {
            [CommonClass showAlert:self messageString:@"All fields are mandatory" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
            return;
        }
        //Building json string for API request.
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        NSString *urlstr = baseURL;
        NSString *myUrlString = [NSString stringWithFormat:@"%@Issue/CreateNewIssue",urlstr];
        
        dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
        dataCon.accessibilityLabel = @"AddNewPunch";
        UIView *btnView1 = [[self.view viewWithTag:5002] viewWithTag:441];
        [btnView1 setUserInteractionEnabled:FALSE];
        UIView *btnView2 = [[self.view viewWithTag:5002] viewWithTag:443];
        [btnView2 setUserInteractionEnabled:FALSE];
        NSLog(@"my punchUpdateurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
}
-(void)callingUpdatePunch
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:[self.detailDict valueForKey:@"ProjectId"] forKey:@"ProjectId"];
        [dict setValue:[self.detailDict valueForKey:@"IssueId"] forKey:@"IssueId"];
        [dict setValue:updatedStatusStr forKey:@"IssueStatus"];
        [dict setValue:issueName forKey:@"IssueName"];
        [dict setValue:updatedDescription forKey:@"IssueDescription"];
        [dict setValue:assignedToStr forKey:@"AssignedTo"];
        [dict setValue:updatedDeptStr forKey:@"DepartmentId"];
        [dict setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]] forKey:@"CreatedBy"];
        [dict setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"CreatedOn"];
        [dict setValue:imgDataArray forKey:@"IssueImages"];
        //Building json string for API request.
        NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
        NSString *urlstr = baseURL;
        NSString *myUrlString = [NSString stringWithFormat:@"%@Issue/UpdateIssue",urlstr];
        
        dataCon = [[DataConnection alloc] initUpdateDataWithUrlString:myUrlString withJsonString:jsonString delegate:self];
        dataCon.accessibilityLabel = @"updatePunch";
        UIView *btnView3 = [[self.view viewWithTag:5002] viewWithTag:442];
        [btnView3 setUserInteractionEnabled:FALSE];
        NSLog(@"my punchUpdateurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
}
-(void)dataLoadingFinished:(NSMutableData*)data{
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response data is...%@",responseString);
    UIView *btnView1 = [[self.view viewWithTag:5002] viewWithTag:441];
    [btnView1 setUserInteractionEnabled:TRUE];
    UIView *btnView2 = [[self.view viewWithTag:5002] viewWithTag:443];
    [btnView2 setUserInteractionEnabled:TRUE];
    UIView *btnView3 = [[self.view viewWithTag:5002] viewWithTag:442];
    [btnView3 setUserInteractionEnabled:TRUE];
    
    if ([[dataCon accessibilityLabel] isEqualToString:@"updatePunch"]){
       // NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:nil];
        if ([[responseDict valueForKey:@"value"] length]>0) {
          //  [CommonClass showAlert:self messageString:@"Punch Updated Successfully" withTitle:@"Updated" OKbutton:nil cancelButton:@"OK"];
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
        }else{
            [CommonClass showAlert:self messageString:@"Encountered some error.\nPlease try later." withTitle:@"Error!!" OKbutton:nil cancelButton:@"OK"];
        }
       
        
    }else if ([[dataCon accessibilityLabel] isEqualToString:@"AddNewPunch"]){
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        if ([responseString rangeOfString:@"value"].location != NSNotFound) {
            if ([[responseDict valueForKey:@"value"] length]>0) {
                if (isSaveNew){
                    [CommonClass showAlert:self messageString:@"New Punch Added" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
                    [self loadPunchFieldValuesForNew];
                }
                else
                    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
            }
        }
        
    }else if ([[dataCon accessibilityLabel] isEqualToString:@"ImageUpload"]){
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"uploadImgResponse  %@", responseString);
        
        [CommonClass showAlert:self messageString:responseString withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
    
    
    [VSProgressHud removeIndicator:self];
}
-(void)urlConnectionError :(NSError*)error
{
    [VSProgressHud removeIndicator:self];
}
#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerDataArr count];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (selectedTF.tag==101) {
        pickerDataArr = departmentArr;
        return [NSString stringWithFormat:@"%@",[[pickerDataArr objectAtIndex:row] valueForKey:@"DepartmentName"]];
    }else if (selectedTF.tag==102){
        pickerDataArr = usersArr;
        return [NSString stringWithFormat:@"%@ %@",[[pickerDataArr objectAtIndex:row] valueForKey:@"FirstName"], [[pickerDataArr objectAtIndex:row] valueForKey:@"LastName"]] ;
    }else if (selectedTF.tag==103) {
        pickerDataArr = statusArr;
        return [NSString stringWithFormat:@"%@",[[pickerDataArr objectAtIndex:row] valueForKey:@"StatusDetail"]];
    }
    return @"text";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row %ld",row);
    
    selectedrow = row;
}

#pragma mark - UITextField & TextView Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [selectedTF resignFirstResponder];
    selectedrow = 0;
    selectedItem = @"";
    selectedTF = textField;
    if (textField.tag==101) {
        pickerDataArr = appDel.departmentArr;//[[NSUserDefaults standardUserDefaults] valueForKey:@"departmentArr"];//[[NSArray alloc] initWithArray:departmentArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==102){
        pickerDataArr = appDel.userArr;//[[NSUserDefaults standardUserDefaults] valueForKey:@"usersArr"];//[[NSArray alloc] initWithArray:usersArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==103){
        pickerDataArr = appDel.statusArr;//[[NSUserDefaults standardUserDefaults] valueForKey:@"statusArr"];//[[NSArray alloc] initWithArray:statusArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==5011){
        actionPopup = [UIAlertController alertControllerWithTitle:@"Select Image Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self imageSelectionAction];
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    updatedDescription = textView.text;
    selectedTF = (UITextField*)textView;
    textView.inputAccessoryView = toolbar;
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    updatedDescription = selectedTF.text;
    [textView resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==103){
        updatedStatusStr = textField.text;
    }
    if (textField.tag==104){
        issueName = textField.text;
    }
    [textField resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"done"]||[text isEqualToString:@"close"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark - UIGestureRecognizer and action handler
-(void)imageSelectionAction
{
    [actionPopup addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self presentCameraForImage];
    }]];
    [actionPopup addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self presentGalleryForImage];
    }]];
    [actionPopup addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self->actionPopup dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    UIPopoverPresentationController *popPresenter = [actionPopup
                                                     popoverPresentationController];
    popPresenter.sourceView = selectedTF;
    popPresenter.sourceRect = selectedTF.bounds;
    [self presentViewController:actionPopup animated:YES completion:nil];
}

-(void)presentCameraForImage
{
    [actionPopup dismissViewControllerAnimated:YES completion:nil];
    [selectedTF resignFirstResponder];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        [CommonClass showAlert:self messageString:@"Unable to find the selected resource" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        [actionPopup dismissViewControllerAnimated:YES completion:^{
           
        }];
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
-(void)presentGalleryForImage
{
    [actionPopup dismissViewControllerAnimated:YES completion:nil];
    [selectedTF resignFirstResponder];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];

}
-(void)handlePunchAction :(id)sender
{
    if ([sender tag]==441) {
        isSaveNew = NO;
        [self callingAddNewPunch];
    }else if ([sender tag]==442) {
        isSaveNew = NO;
        [self callingUpdatePunch];
    }else if ([sender tag]==443) {
        isSaveNew = YES;
        [self callingAddNewPunch];
    }
    
}
-(void)handleDoneAction :(id)sender
{
    selectedItem = [self pickerView:pickerV titleForRow:selectedrow forComponent:1];
    if (selectedTF.tag==303) {
        updatedDescription = selectedTF.text;
    }else if (selectedTF.tag==101){
        selectedTF.text = selectedItem;
        updatedDeptStr = [[departmentArr objectAtIndex:selectedrow] valueForKey:@"DepartmentId"];
    }else if (selectedTF.tag==102){
        selectedTF.text = selectedItem;
        assignedToStr = [[usersArr objectAtIndex:selectedrow] valueForKey:@"UserId"];
    }else if (selectedTF.tag==103){
        updatedStatusStr = selectedTF.text = selectedItem;
    }
    selectedrow = 0;
    [selectedTF resignFirstResponder];
}

-(void)handleCloseAction :(id)sender
{
    if (selectedTF.tag==303) {
        selectedTF.text =  updatedDescription;
    }
    [selectedTF resignFirstResponder];
}
-(void)imageTapped :(UIGestureRecognizer*)tap
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setTag:1111];
    [bgView setGestureRecognizers:@[closeTap]];
    [bgView setUserInteractionEnabled:YES];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.view addSubview:bgView];
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width/1.2, bgView.frame.size.width/1.2)];
    [bgView addSubview:imgV];
    imgV.center = bgView.center;
    [imgV setImage:[[punchImageArr objectAtIndex:(tap.view.tag%3000)-1]valueForKey:@"image"]];
}
-(void)closeIssueImage:(UITapGestureRecognizer*)closetap
{
    UIView *issueImgView = [self.view viewWithTag:closeTap.view.tag];
    [issueImgView removeFromSuperview];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
   selectedImage = info[UIImagePickerControllerEditedImage];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    if (refURL==nil) {
        NSData *dataForImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1.0);
        
        float exactMbSize=(float)dataForImage.length/1024.0f/1024.0f;
        
        if (exactMbSize <=3){
            isLargeImage = NO;
            selectedImageName = @"cameraImage.png";
        }else{
            isLargeImage = YES;
        }
    }else{
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            
            
            float exactMbSize=(float)representation.size/(1024 * 1024);
            NSLog(@"Size: %f", exactMbSize);
            if (exactMbSize <=3){
                self ->isLargeImage = NO;
                self->selectedImageName=fileName;
               // [self getBinaryDataForImage];
            }else{
                self->isLargeImage = YES;
            }
            
        };
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (!isLargeImage) {
        PunchImageViewController *canvas = [[PunchImageViewController alloc] init];
        [canvas getImageToProcessAtCanvas:selectedImage];
        [self.navigationController pushViewController:canvas animated:YES];
    }else{
        [CommonClass showAlert:self messageString:@"Image is too large to upload." withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
}

-(void)drawPunchImageOnView
{
    UIScrollView *imgScroll = [self.view viewWithTag:6001];
    [[imgScroll subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int xPos = 0;
    for (int i=0; i<[punchImageArr count]; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [tap setNumberOfTapsRequired:1];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(xPos, 3, imgScroll.frame.size.height-5, imgScroll.frame.size.height);
        imageV.tag = 3000+i+1;
        [imageV setUserInteractionEnabled:YES];
        [imageV setGestureRecognizers:@[tap]];
        [imgScroll addSubview:imageV];
        [imageV setImage:[[punchImageArr objectAtIndex:i]valueForKey:@"image"]];
        if (![[[punchImageArr objectAtIndex:i] valueForKey:@"imageName"] isEqualToString:@"OldImage"]) {
            UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            delBtn.frame = CGRectMake(imageV.frame.size.width-25, 3, 25, 25);
            [delBtn setBackgroundColor:[UIColor blackColor]];
            [delBtn.layer setCornerRadius:12.5];
            [delBtn setClipsToBounds:YES];
            [delBtn setImage:[UIImage imageNamed:@"delete_cross.png"] forState:UIControlStateNormal];
            [delBtn setTag:3000+i+1];
            [delBtn addTarget:self action:@selector(deleteIssueImage:) forControlEvents:UIControlEventTouchUpInside];
            [imageV addSubview:delBtn];
        }
        xPos = xPos + imageV.frame.size.width+15;
        [imgScroll setContentSize:CGSizeMake(xPos, 0)];
    }
    
}
-(void)deleteIssueImage:(UIButton*)btn
{
    NSInteger tagV = ([btn tag]%3000)-1;
    [punchImageArr removeObjectAtIndex:tagV];
    [self drawPunchImageOnView];
    [self getBinaryDataForImage];
}
-(void)getBinaryDataForImage
{
    [imgDataArray removeAllObjects];
    for (int i = 0; i<[punchImageArr count]; i++) {
        if (![[[punchImageArr objectAtIndex:i] valueForKey:@"imageName"] isEqualToString:@"OldImage"]) {
            NSMutableDictionary *imgDataDict = [[NSMutableDictionary alloc] init];
            NSData *imgBinaryData=UIImageJPEGRepresentation([[punchImageArr objectAtIndex:i] valueForKey:@"image"], 0.8);
            NSString *imgBase64data=[Base64 encode:imgBinaryData];
            [imgDataDict setObject:imgBase64data forKey:@"ImgStr"];
            [imgDataArray addObject:imgDataDict];
        }
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
