//
//  ViewController.h
//  PunchList
//
//  Created by apple on 12/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>
{
    AppDelegate *appDel;
}
-(void)submitUserNameforForgotPassword :(NSString*)username;

@end

