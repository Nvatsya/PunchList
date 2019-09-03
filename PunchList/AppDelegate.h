//
//  AppDelegate.h
//  PunchList
//
//  Created by apple on 12/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic, assign)BOOL isIphone;
@property (nonatomic, retain)NSMutableArray *departmentArr;
@property (nonatomic, retain)NSMutableArray *userArr;
@property (nonatomic, retain)NSMutableArray *statusArr;
@property (nonatomic, retain)NSMutableArray *projectArr;

@end

