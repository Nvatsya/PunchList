//
//  ProjDetailViewController.m
//  PunchList
//
//  Created by apple on 22/10/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "PunchViewController.h"
#import "InterfaceViewController.h"

@interface PunchViewController ()

@end

@implementation PunchViewController
@synthesize detailDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:[NSString stringWithFormat:@"%@",[self.detailDict valueForKey:@"ProjectName"]]];
    
    NSLog(@"details dict %@",self.detailDict);
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
