//
//  InterfaceViewController.m
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "InterfaceViewController.h"
#import "AdminViewController.h"
#import "CommonClass.h"
#import "ConstantFile.h"

@interface InterfaceViewController ()
{
    
}
@end

@implementation InterfaceViewController


+(void)createUserInterface :(UIViewController *)VC
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height);
    [bgView setImage:[UIImage imageNamed:@"background.png"]];
    [VC.view addSubview:bgView];
    
    UIView *bgheaderView = [[UIView alloc] init];
    bgheaderView.frame = CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height/3);
    [bgheaderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"headerBG.png"]]];
    [bgView addSubview:bgheaderView];
    
    UILabel *screenTitle = [[UILabel alloc] init];
    screenTitle.frame = CGRectMake(0, bgheaderView.frame.size.height-30, bgheaderView.frame.size.width, 22);
    [screenTitle setTextColor:[UIColor whiteColor]];
    [screenTitle setFont:[UIFont systemFontOfSize:bold]];
    [screenTitle setFont:[UIFont fontWithName:@"AvenirLTM" size:14]];
    screenTitle.text = @"SIGN IN";
    [screenTitle setTextAlignment:NSTextAlignmentCenter];
    [bgheaderView addSubview:screenTitle];
    
    if ([VC isKindOfClass:[AdminViewController class]]) {
        screenTitle.text = @"Good Morning";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSLog(@"Current Date: %@", [[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] lastObject]);
        if ([[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "] lastObject] isEqualToString:@"PM"])
        {
            if ([[[[formatter stringFromDate:[NSDate date]] componentsSeparatedByString:@":"] firstObject] integerValue]<4) {
                screenTitle.text = @"Good Afternoon";
            }else{
                screenTitle.text = @"Good Evening";
            }
            
        }
    }
    UILabel *borderTitle = [[UILabel alloc] init];
    borderTitle.frame = CGRectMake(0, bgheaderView.frame.size.height-2, bgheaderView.frame.size.width/3, 4);
    [borderTitle setCenter: CGPointMake(VC.view.center.x, borderTitle.center.y)];
    [borderTitle setBackgroundColor:[UIColor colorWithRed:4.0/255 green:187.0/255 blue:176.0/255 alpha:1]];
    [bgheaderView addSubview:borderTitle];
    
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.frame = CGRectMake(0, 0, bgheaderView.frame.size.width/3, bgheaderView.frame.size.width/3);
    logoView.center = bgheaderView.center;
    [logoView setImage:[UIImage imageNamed:@"Applogo.png"]];
    [bgheaderView addSubview:logoView];
}

+(void)createInterfaceForAdminAction :(UIViewController *)VC forScreen:(NSString*)title
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height);
    [bgView setImage:[UIImage imageNamed:@"background.png"]];
    [VC.view addSubview:bgView];
    [VC.navigationController setNavigationBarHidden:NO];
    [VC.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [VC.navigationController.navigationBar setBarTintColor:[UIColor grayColor]];
    [VC.navigationController.navigationBar setTranslucent:YES];
    VC.title = title;
}

+(void)createListView :(UIViewController*)VC
{
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(VC.view.frame.size.width/24, VC.view.frame.size.height/10.5, VC.view.frame.size.width-(VC.view.frame.size.width/12), 25)];
    instructionLabel.text = @"Swipe cell left to get Punch options";
    [instructionLabel setTextColor:[CommonClass getColorFromColorCode:themeColor]];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [VC.view addSubview:instructionLabel];
    
    UIView *fieldBgView = [[UIView alloc] initWithFrame:CGRectMake(VC.view.frame.size.width/20, VC.view.frame.size.height/7.5, VC.view.frame.size.width-(VC.view.frame.size.width/10),(VC.view.frame.size.height - (VC.view.frame.size.height/7.5)))];
    fieldBgView.tag = 5001;
    
    UITableView *table = [[UITableView alloc] init];
    table.frame = CGRectMake(0, 0, fieldBgView.frame.size.width, fieldBgView.frame.size.height-20);
    table.delegate = VC;
    table.dataSource = VC;
    [table setTag:1001];
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [fieldBgView addSubview:table];
    [VC.view addSubview:fieldBgView];
}
@end
