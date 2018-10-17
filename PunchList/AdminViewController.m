//
//  AdminDashboardViewController.m
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AdminViewController.h"
#import "InterfaceViewController.h"
#import "DataConnection.h"
#import "AppDelegate.h"
#import "AddNewUserController.h"
#import "AddNewDeptController.h"
#import "AddNewProjController.h"
#import "AddNewStatusController.h"
#import "AboutViewController.h"
#import "CommonClass.h"

@interface AdminViewController ()
{
    UIButton *button;
    NSString *username, *password;
    DataConnection *dataCon;
    NSDictionary *actionDict;
    NSMutableArray *allActionArr;
    NSArray *actionImageArr;
    AppDelegate *appDel;
    UIScrollView *scroll;
}
@end

@implementation AdminViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    actionImageArr = [[NSArray alloc] initWithObjects:@"dashboard.png",@"newUser.png",@"newProject.png",@"department.png",@"status.png",@"about.png", nil];
    [self getActionsDetailsforDashboard];
    [self createDashboardUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)getActionsDetailsforDashboard
{
    NSArray *tempActionArr = [[NSArray alloc] initWithObjects:@"Dashboard",@"New user",@"New Project",@"New Department",@"New Status",@"About", nil];
    allActionArr = [[NSMutableArray alloc]init];
    for (int i=0; i<[tempActionArr count]; i++) {
        NSMutableDictionary *actionDict = [[NSMutableDictionary alloc] init];
        [actionDict setValue:[tempActionArr objectAtIndex:i] forKey:@"name"];
        [actionDict setValue:[NSString stringWithFormat:@"%d",i+1] forKey:@"Id"];
        [allActionArr addObject:actionDict];
    }
}
-(void)createDashboardUI
{
    [InterfaceViewController createUserInterface:self];
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/18), self.view.frame.size.height/3+10, self.view.frame.size.width-self.view.frame.size.width/9, self.view.frame.size.height-(self.view.frame.size.height/3)-20)];
    
    // Add action buttons on Landing screen
    float xPoint = 0, yPoint = 20;
    for (int k=0; k<[allActionArr count]; k++) {
        if (k!=0 && k%2==0) {
            xPoint = 0;
            yPoint = yPoint + (scroll.frame.size.width/(appDel.isIphone?2.5:3)) + 40;
           //
        }else{
            if (k!=0)
                xPoint = scroll.frame.size.width - ((scroll.frame.size.width/(appDel.isIphone?2.2:3)) );
        }
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        tapAction.numberOfTapsRequired = 1;
        tapAction.delegate = self;
        
        UIView *actionView = [[UIView alloc] init];
        actionView.frame = CGRectMake(xPoint, yPoint, scroll.frame.size.width/(appDel.isIphone?2.2:3), scroll.frame.size.width/(appDel.isIphone?2.2:3));
        [actionView setBackgroundColor:[UIColor blackColor]];
        [actionView setTag: [[[allActionArr objectAtIndex:k] valueForKey:@"Id"]intValue]];
        [actionView setUserInteractionEnabled:YES];
        [actionView addGestureRecognizer:tapAction];
        
        UIImageView *actionImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[actionImageArr objectAtIndex:k]]];
        actionImg.frame = CGRectMake(actionView.frame.size.width/2-(appDel.isIphone?30:45), appDel.isIphone?10:40, appDel.isIphone?60:90, appDel.isIphone?60:90);
        [actionView addSubview:actionImg];
        
        UILabel *actionLable = [[UILabel alloc] init];
        actionLable.frame = CGRectMake(0, actionImg.frame.size.height+10, actionView.frame.size.width, actionView.frame.size.height-70);
        actionLable.textColor = [UIColor whiteColor];
        actionLable.numberOfLines = 0;
        actionLable.text = [NSString stringWithFormat:@"%@",[[allActionArr objectAtIndex:k] valueForKey:@"name"]];
        actionLable.font = [UIFont systemFontOfSize:8];
        actionLable.font = [UIFont fontWithName:@"AvenirLTM" size:8];
        actionLable.lineBreakMode = NSLineBreakByWordWrapping;
        actionLable.textAlignment = NSTextAlignmentCenter;
        [actionView addSubview:actionLable];
        
        [scroll addSubview:actionView];
    }
    [scroll setContentSize:CGSizeMake(0, yPoint+(appDel.isIphone?150:240))];
    [self.view addSubview:scroll];
    
}
-(void)handleTapAction:(UIGestureRecognizer*)tap
{
    for (UIView *view in scroll.subviews)
    {
        if ([view isKindOfClass:[UIView class]]) {
            [view setBackgroundColor:[UIColor blackColor]];
        }
    }
    [tap.view setBackgroundColor:[UIColor colorWithRed:4.0/255 green:187.0/255 blue:176.0/255 alpha:1]];
    NSLog(@"tapview tag %ld",[tap.view tag]);
    if ([tap.view tag]==1) {
        [CommonClass showAlert:self messageString:@"Will be designed as per Admin's feedback including Logout option" withTitle:@"" OKbutton:@"" cancelButton:@"OK"];
    }else if ([tap.view tag]==2){
        AddNewUserController *newUserVC = [[AddNewUserController alloc] init];
        [self.navigationController pushViewController:newUserVC animated:YES];
    }else if ([tap.view tag]==3){
        AddNewProjController *newProjVC = [[AddNewProjController alloc] init];
        [self.navigationController pushViewController:newProjVC animated:YES];
    }else if ([tap.view tag]==4){
        AddNewDeptController *newDeptVC = [[AddNewDeptController alloc] init];
        [self.navigationController pushViewController:newDeptVC animated:YES];
    }else if ([tap.view tag]==5){
        AddNewStatusController *newStatusVC = [[AddNewStatusController alloc] init];
        [self.navigationController pushViewController:newStatusVC animated:YES];
    }else if ([tap.view tag]==6){
        AboutViewController *aboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
