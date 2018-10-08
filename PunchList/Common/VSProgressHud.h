//
//  VSProgressHud.h
//  PunchList
//
//  Created by apple on 22/09/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSProgressHud : UIView

+ (VSProgressHud*)indecatorView;
-(void)showLoadingActivity :(UIViewController *)VC needToShow:(BOOL)isNeeded;

+(void)presentIndicator :(UIViewController *)viewcController;
+(void)removeIndicator :(UIViewController *)viewcController;

@end

NS_ASSUME_NONNULL_END
