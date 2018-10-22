//
//  InterfaceViewController.h
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterfaceViewController : NSObject <UITableViewDelegate, UITableViewDataSource>

+(void)createUserInterface :(UIViewController *)VC;
+(void)createInterfaceForAdminAction :(UIViewController *)VC forScreen:(NSString*)title;
+(void)createListView :(UIViewController*)VC;
@end
