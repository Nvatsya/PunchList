//
//  VSProgressHud.m
//  PunchList
//
//  Created by apple on 22/09/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "VSProgressHud.h"
#import "CommonClass.h"
#import "ConstantFile.h"


@implementation VSProgressHud
{
    UIActivityIndicatorView *spinner;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(VSProgressHud*)indecatorView
{
    static dispatch_once_t once;
    static VSProgressHud *indecatorView;
   
    dispatch_once(&once, ^{ indecatorView = [[VSProgressHud alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
        
        // Alpha view to make background blur.
        UIView *alphaview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, indecatorView.frame.size.width, indecatorView.frame.size.height)];
        alphaview.backgroundColor=[UIColor clearColor];
        alphaview.alpha=0.7f;
        [indecatorView addSubview:alphaview];
        
        indecatorView.backgroundColor = [UIColor clearColor];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
        [spinner.layer setCornerRadius:20];
        [spinner setBackgroundColor:[CommonClass getColorFromColorCode:themeColor]];
        [indecatorView addSubview:spinner];
        [indecatorView bringSubviewToFront:spinner];
        
        spinner.center = indecatorView.center;
        [spinner startAnimating];
       
        
    });
    return indecatorView;
}
-(void)showLoadingActivity :(UIViewController *)VC needToShow:(BOOL)isNeeded
{
    
    if (isNeeded) {
        [[[UIApplication sharedApplication] delegate].window addSubview:[VSProgressHud indecatorView]];
//        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
//        [spinner.layer setCornerRadius:20];
//        [spinner setBackgroundColor:[CommonClass getColorFromColorCode:themeColor]];
//        [[VC.view] addSubview:spinner];
//        spinner.center = VC.view.center;
//        [spinner startAnimating];
        [VC.view setUserInteractionEnabled:FALSE];
    }else{
        
        [VC.view setUserInteractionEnabled:YES];
    }
    
}

+(void)presentIndicator :(UIViewController *)viewcController
{
    [[self indecatorView] showLoadingActivity:viewcController needToShow:YES];
}

+(void)removeIndicator :(UIViewController *)viewcController
{
    [[self indecatorView] removeFromSuperview];
    [[self indecatorView] showLoadingActivity:viewcController needToShow:NO];
}

@end
