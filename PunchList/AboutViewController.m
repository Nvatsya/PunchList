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
    
    [self createAboutView];
}

-(void)createAboutView
{
    UIView *fieldBgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/14, self.view.frame.size.height/6.8, self.view.frame.size.width-(self.view.frame.size.width/8),(self.view.frame.size.height -(self.view.frame.size.height/6.4) ))];
    fieldBgView.tag = 5001;
    [self.view addSubview:fieldBgView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, fieldBgView.frame.size.width, fieldBgView.frame.size.height)];
    [webView loadHTMLString:@"<html><body><h2 allign='center'>Introduction</h2><br><p>Description here</p><br><ul><li>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.</li><li>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.</li><li>Phasellus ultrices nulla quis nibh. Quisque a lectus. Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam, gravida non, commodo a, sodales sit amet, nisi.</li><li>Pellentesque fermentum dolor. Aliquam quam lectus, facilisis auctor, ultrices ut, elementum vulputate, nunc.</li></ul></br></body></html>" baseURL:nil];
    
    [fieldBgView addSubview:webView];
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
