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

@interface PunchViewController ()
{
    NSMutableArray *fieldsArr;
}
@end

@implementation PunchViewController
@synthesize detailDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:[NSString stringWithFormat:@"%@",[self.detailDict valueForKey:@"ProjectName"]]];
    [self createFieldsInfo];
    
    [Form createPunchView:self fieldsInfo:fieldsArr withData:self.detailDict];
    NSLog(@"details dict %@",self.detailDict);
    
    /*
    UITextField *textfield = [[UITextField alloc] init];
    [textfield setBackgroundColor:[UIColor orangeColor]];
    textfield.frame = CGRectMake(40, 100, 200, 40);
    //textfield.tag = [[[fieldsArr objectAtIndex:i] valueForKey:@"tagval"] intValue];
    textfield.delegate = self;
    UIColor *color = [UIColor whiteColor];
    textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"testing"] attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:textfield];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Applogo.png"]]];
    iconView.bounds = CGRectInset(iconView.frame, 25, 10);
    iconView.frame = CGRectMake(0, 0, 25, 25);
   // textfield.leftView=iconView;
   textfield.rightView = iconView;
    //textfield.leftViewMode=UITextFieldViewModeAlways;
    textfield.rightViewMode=UITextFieldViewModeAlways;
    */
    
    
    
}

-(void)createFieldsInfo
{
    NSDictionary *field1Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Department",@"Placeholder",@"",@"Value",@"dropdown.png",@"leftview",@"",@"rightview",@"101",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSDictionary *field2Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Assign To",@"Placeholder",@"",@"Value",@"dropdown.png",@"leftview",@"",@"rightview",@"102",@"tagval",@"YES",@"isRequired",@"dropdown",@"fieldType", nil];
    NSDictionary *field3Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Punch Name",@"Placeholder",@"",@"Value",@"dropdown.png",@"leftview",@"",@"rightview",@"103",@"tagval",@"YES",@"isRequired",@"textfield",@"fieldType", nil];
     NSDictionary *field4Dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Add Discription",@"Placeholder",@"",@"Value",@"dropdown.png",@"leftview",@"",@"rightview",@"103",@"tagval",@"YES",@"isRequired",@"textView",@"fieldType", nil];
    fieldsArr = [[NSMutableArray alloc] init];
    [fieldsArr addObject:field1Dict];
    [fieldsArr addObject:field2Dict];
    [fieldsArr addObject:field3Dict];
    [fieldsArr addObject:field4Dict];
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
