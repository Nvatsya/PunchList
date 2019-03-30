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


@interface PunchViewController ()
{
    NSMutableArray *fieldsArr;
    NSArray *departmentArr;
    NSArray *usersArr;
    NSArray *statusArr;
    NSArray *pickerDataArr;
    NSData *issueImgData;
    UITapGestureRecognizer *closeTap;
    UIPickerView *pickerV;
    UIToolbar *toolbar;
    DataConnection *dataCon;
    UITextField *selectedTF;
    NSString *selectedItem;
    NSInteger selectedrow;
    UIAlertController *actionPopup;
    NSData *imageBinaryData;
    NSString *imageBase64data;
    UIImage *selectedImage;
    NSString *selectedImageName;
    NSString *updatedDescription;
    NSString *assignedToStr;
    NSString *updatedStatusStr;
    NSString *updatedDeptStr;
    NSString *selectedStatusId;
    NSString *issueName;
}
@end

@implementation PunchViewController
@synthesize detailDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self getDepartmentList];
    
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:[NSString stringWithFormat:@"%@",[self.detailDict valueForKey:@"ProjectName"]]];
    [self createFieldsInfo];
    
    [Form createPunchView:self fieldsInfo:fieldsArr withData:self.detailDict];
    
    pickerV = [[UIPickerView alloc] init];
    [pickerV setDelegate:self];
    [pickerV setDataSource:self];
    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIBarButtonItem *donebarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(handleDoneAction:)];
    UIBarButtonItem *closebarBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(handleCloseAction:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:@[closebarBtn,space,donebarBtn]];
    
    [self createViewForIssueImage];
    
    closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeIssueImage:)];
    [closeTap setNumberOfTapsRequired:1];
    
    
    [self getListDataForDropdowns];
   
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
    updatedStatusStr = [[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"IssueStatus"]lastObject];
    updatedDeptStr = [[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"department"]lastObject];
    assignedToStr = [[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"AssignedTo"]lastObject];
    
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys: department,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"101",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys: assignmedTo,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"102",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSDictionary *field3Dict = [[NSDictionary alloc] initWithObjectsAndKeys: punchStatus,@"Placeholder",@"",@"Value",@"dropdownW.png",@"leftview",@"",@"rightview",@"103",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
     NSDictionary *field4Dict = [[NSDictionary alloc] initWithObjectsAndKeys: description,@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"303",@"tagval",@"YES",@"isRequired",@"textView",@"fieldType", nil];
    NSDictionary *field5Dict = [[NSDictionary alloc] initWithObjectsAndKeys: punchTitle,@"Placeholder",@"",@"Value",@"",@"leftview",@"",@"rightview",@"104",@"tagval",@"YES",@"isRequired",@"textfield",@"fieldType", nil];
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
    [imageFieldContainer setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:imageFieldContainer];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,  imageFieldContainer.frame.size.width, 30)];
    label.text = @"Upload Image";
    label.textColor = [UIColor whiteColor];
    [imageFieldContainer addSubview:label];
    
    UITextField *textfield = [[UITextField alloc] init];
    textfield.frame = CGRectMake(0, label.frame.origin.y+label.frame.size.height, imageFieldContainer.frame.size.width, 30);
    textfield.tag = 5011;
    textfield.delegate = self;
    UIColor *color = [UIColor whiteColor];
    textfield.textColor=color;
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Select Image"] attributes:@{NSForegroundColorAttributeName: color}];
    [imageFieldContainer addSubview:textfield];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"uploadW.png"]]];
    iconView.bounds = CGRectInset(iconView.frame, 25, 10);
    iconView.frame = CGRectMake(0, 0, 25, 25);
    textfield.rightView = iconView;
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
    [imgScroll setBackgroundColor:[UIColor yellowColor]];
    [imageFieldContainer addSubview:imgScroll];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [tap setNumberOfTapsRequired:1];
    
    int xPos = 0;
    for (int i=0; i<[[self.detailDict valueForKey:@"PunchIssues"] count]; i++) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(xPos, 1, imageFieldContainer.frame.size.height/2, imageFieldContainer.frame.size.height/2);
        imageV.tag = 3000+0+1;
        [imgScroll addSubview:imageV];
        [imageV setUserInteractionEnabled:YES];
        [imageV setGestureRecognizers:@[tap]];
        issueImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[[self.detailDict valueForKey:@"PunchIssues"] objectAtIndex:i] valueForKey:@"IssueImages"]lastObject]valueForKey:@"ImgStr"]]];
        [imageV setImage:[UIImage imageWithData:issueImgData]];
        xPos = xPos + imageFieldContainer.frame.size.height/2+5;
        
        [imgScroll setContentSize:CGSizeMake(xPos, 0)];
    }
//    for (int i=0; i<[[[[self.detailDict valueForKey:@"PunchIssues"] lastObject]valueForKey:@"IssueImages"] count]; i++) {
//        UIImageView *imageV = [[UIImageView alloc] init];
//        imageV.frame = CGRectMake(xPos, 1, imageFieldContainer.frame.size.height/2, imageFieldContainer.frame.size.height/2);
//        imageV.tag = 3000+0+1;
//        [imgScroll addSubview:imageV];
//        [imageV setUserInteractionEnabled:YES];
//        [imageV setGestureRecognizers:@[tap]];
//        issueImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[[self.detailDict valueForKey:@"PunchIssues"] lastObject]valueForKey:@"IssueImages"]lastObject]valueForKey:@"ImgStr"]]];
//        [imageV setImage:[UIImage imageWithData:issueImgData]];
//        xPos = xPos + imageFieldContainer.frame.size.height/2+5;
//
//        [imgScroll setContentSize:CGSizeMake(xPos, 0)];
//    }
    //Adding action button
    UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(0, imageFieldContainer.frame.size.height-self.view.frame.size.height/14, imgScroll.frame.size.width, self.view.frame.size.height/14);
    [actionBtn setTitle:[[self.detailDict valueForKey:@"PunchIssues"] count]==0?@"Create":@"Update" forState:UIControlStateNormal] ;
    [actionBtn setTag:[[self.detailDict valueForKey:@"PunchIssues"] count]==0?441:442] ;
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    actionBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    actionBtn.titleLabel.font = [UIFont fontWithName:@"AvenirBook.otf" size:18];
    [actionBtn addTarget:self action:@selector(handlePunchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [imageFieldContainer addSubview:actionBtn];
}

#pragma mark - API calls handler

-(void)uploadSelectedImage
{
    
    //NSString *urlstr = @"http://punch.gjitsolution.in/api/Image/UploadImage";
    NSString *urlstr = @"http://punch.gjitsolution.in/api/Image/GetImage";
    
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    
    NSDictionary *jsonDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"IssueId"]lastObject],@"Id",imageBase64data,@"ImgStr", nil];
    
    [dataArr addObject:jsonDictionary];
    
    
    
    NSError *error = nil;
    
    //Building json string for upload request.
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", jsonString);
    
    DataConnection *dataCon = [[DataConnection alloc] initWithUrlStringFromData:urlstr withJsonString:jsonString delegate:self];
    dataCon.accessibilityLabel = @"ImageUpload";
}
-(NSString *)convertingToJsonFormat:(NSDictionary *)dictJson
{
    NSString *jsonString=@"{";
    int count=0;
    
    for (id key in dictJson){
        count++;
        if (count<dictJson.count) {
            
            if ([[dictJson valueForKey:key] isKindOfClass:[NSString class]]) {
                
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":\"%@\",",key,[dictJson objectForKey:key]];
                
                
            }else{
                
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":%@,",key,[dictJson objectForKey:key]];
                
            }
            
        }
        else {
            
            if ([[dictJson valueForKey:key] isKindOfClass:[NSString class]]) {
                
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":\"%@\"}",key,[dictJson objectForKey:key]];
                
            }else{
                
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":%@}",key,[dictJson objectForKey:key]];
                
            }
            
            
        }
        
    }
    
    return jsonString;
}

-(void)callingAddNewPunch
{
    [selectedTF resignFirstResponder];
    if ([CommonClass connectedToInternet]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setValue:[[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"IssueId"]lastObject] forKey:@"IssueId"];
        [dict setValue:[self.detailDict valueForKey:@"ProjectId"] forKey:@"ProjectId"];
        [dict setValue:updatedStatusStr forKey:@"IssueStatus"];
        [dict setValue:issueName forKey:@"IssueName"];
        [dict setValue:updatedDescription forKey:@"IssueDescription"];
        [dict setValue:assignedToStr forKey:@"AssignedTo"];
        [dict setValue:updatedDeptStr forKey:@"DepartmentId"];
        [dict setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]] forKey:@"CreatedBy"];
        [dict setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"CreatedOn"];
//        NSDictionary *imgDict = [[NSDictionary alloc] initWithObjectsAndKeys:imageBase64data,@"ImgStr", nil];
//       // NSArray *imgArr = [[NSArray alloc] initWithObjects:imgDict, nil];
//        [dict setValue:[self convertingToJsonFormat:imgDict] forKey:@"IssueImages"];
        
        
        
        //Building json string for login request.
        NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
        NSString *urlstr = baseURL;
        NSString *myUrlString = [NSString stringWithFormat:@"%@Issue/CreateNewIssue",urlstr];
        
        dataCon = [[DataConnection alloc] initWithUrlStringFromData:myUrlString withJsonString:jsonString delegate:self];
        
        dataCon.accessibilityLabel = @"AddNewPunch";
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
        [dict setValue:[[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"IssueId"]lastObject] forKey:@"IssueId"];
        [dict setValue:updatedStatusStr forKey:@"IssueStatus"];
        [dict setValue:updatedDescription forKey:@"IssueDescription"];
        [dict setValue:assignedToStr forKey:@"AssignedTo"];
        [dict setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]] forKey:@"CreatedBy"];
        [dict setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"CreatedOn"];
       
        
        
        //Building json string for login request.
        NSString *jsonString = [CommonClass convertingToJsonFormat:dict];
        NSString *urlstr = baseURL;
        NSString *myUrlString = [NSString stringWithFormat:@"%@Issue/UpdateIssue",urlstr];
        
        dataCon = [[DataConnection alloc] initUpdateDataWithUrlString:myUrlString withJsonString:jsonString delegate:self];
        
        dataCon.accessibilityLabel = @"updatePunch";
        NSLog(@"my punchUpdateurl %@ and data %@ connection %@",myUrlString,jsonString, dataCon);
    }else{
        [CommonClass showAlert:self messageString:@"No Internet Connection" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
    }
}
-(void)dataLoadingFinished:(NSMutableData*)data{
    NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"response data is...%@",responseString);
    
    if ([[dataCon accessibilityLabel] isEqualToString:@"updatePunch"]){
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"updateResponse  %@", responseString);
       
        [CommonClass showAlert:self messageString:responseString withTitle:@"" OKbutton:nil cancelButton:@"OK"];
         [self.navigationController popViewControllerAnimated:YES];
    }else if ([[dataCon accessibilityLabel] isEqualToString:@"AddNewPunch"]){
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"updateResponse  %@", responseString);
       
        [CommonClass showAlert:self messageString:@"Need to update the recently create Punch in order to add Issue image." withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([[dataCon accessibilityLabel] isEqualToString:@"ImageUpload"]){
        NSString *responseString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"updateResponse  %@", responseString);
        
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
        return [NSString stringWithFormat:@"%@",[[pickerDataArr objectAtIndex:row] valueForKey:@"DepartmentName"]];
    }else if (selectedTF.tag==102){
        return [NSString stringWithFormat:@"%@ %@",[[pickerDataArr objectAtIndex:row] valueForKey:@"FirstName"],[[pickerDataArr objectAtIndex:row] valueForKey:@"LastName"]] ;
    }else if (selectedTF.tag==103) {
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
    selectedrow = 0;
    selectedItem = @"";
    selectedTF = textField;
    if (textField.tag==101) {
        pickerDataArr =[[NSArray alloc] initWithArray:departmentArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==102){
        pickerDataArr =[[NSArray alloc] initWithArray:usersArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==103){
        pickerDataArr =[[NSArray alloc] initWithArray:statusArr];
        [pickerV reloadAllComponents];
        textField.inputView = pickerV;
        textField.inputAccessoryView = toolbar;
    }else if (textField.tag==5011){
        if ([[[[self.detailDict valueForKey:@"PunchIssues"] valueForKey:@"IssueId"]lastObject] length]>0) {
            actionPopup = [UIAlertController alertControllerWithTitle:@"Select Image Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [self imageSelectionAction];
        }
        else{
            [CommonClass showAlert:self messageString:@"Issue image can't be uploaded for New Punch" withTitle:@"" OKbutton:nil cancelButton:@"OK"];
        }
        
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag==103){
        updatedStatusStr = textField.text;
    }
    [textField resignFirstResponder];
   // selectedTF = nil;
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    updatedDescription = textView.text;
    selectedTF = (UITextField*)textView;
    textView.inputAccessoryView = toolbar;
    
    return YES;
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
    [self presentViewController:actionPopup animated:YES completion:nil];
    //[actionPopup showFromRect:popupFrame inView:self.view animated:YES];
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
        [self callingAddNewPunch];
    }else if ([sender tag]==442) {
        [self callingUpdatePunch];
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
        selectedTF.text = selectedItem;
        selectedStatusId = [[statusArr objectAtIndex:selectedrow] valueForKey:@"StatusId"];
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
    NSLog(@"image tapped for tag %ld",tap.view.tag);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setTag:1111];
    [bgView setGestureRecognizers:@[closeTap]];
    [bgView setUserInteractionEnabled:YES];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.view addSubview:bgView];
    UIImageView *imgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width/1.2, bgView.frame.size.width/1.2)];
    [bgView addSubview:imgV];
    imgV.center = bgView.center;
    [imgV setImage:[UIImage imageWithData:issueImgData]];
}
-(void)closeIssueImage:(UITapGestureRecognizer*)closetap
{
    UIView *issueImgView = [self.view viewWithTag:closeTap.view.tag];
    [issueImgView removeFromSuperview];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
   selectedImage = info[UIImagePickerControllerEditedImage];
    
    UIScrollView *imgScroll = [self.view viewWithTag:6001];
    NSLog(@"scroll contentSize %f",imgScroll.contentSize);
    UIImageView *selectedImgV = [[UIImageView alloc] init];
    selectedImgV.frame = CGRectMake(imgScroll.contentSize.width, 1, imgScroll.frame.size.height-5, imgScroll.frame.size.height);
    [selectedImgV setImage:selectedImage];
    [imgScroll addSubview:selectedImgV];
    
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    if (refURL==nil) {
        NSData *dataForImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerEditedImage"], 1.0);
        
        float exactMbSize=(float)dataForImage.length/1024.0f/1024.0f;
        
        if (exactMbSize <=3){
            //[detailsTable reloadData];
             selectedImageName = @"cameraImage.png";
            [self getBinaryDataForImage];
        }else{
            
           // [self showInvalidSizeAlert];
        }
    }else{
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            
            
            float exactMbSize=(float)representation.size/(1024 * 1024);
            NSLog(@"Size: %f", exactMbSize);
            if (exactMbSize <=3){
                selectedImageName=fileName;
                [self getBinaryDataForImage];
            }else{
                
               // [self showInvalidSizeAlert];
            }
            
        };
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
   // [VSProgressHud presentIndicator:self];
}

-(void)getBinaryDataForImage
{
    selectedTF.text=selectedImageName;
    imageBinaryData=UIImageJPEGRepresentation(selectedImage, 0.8);
    imageBase64data=[Base64 encode:imageBinaryData];
    
    //[self uploadSelectedImage];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
