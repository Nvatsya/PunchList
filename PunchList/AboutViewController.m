//
//  AboutViewController.m
//  PunchList
//
//  Created by apple on 26/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "AboutViewController.h"
#import "InterfaceViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [InterfaceViewController createInterfaceForAdminAction:self forScreen:@"About App"];
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
