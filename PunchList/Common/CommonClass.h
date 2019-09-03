//
//  CommonClass.h
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonClass : NSObject

+(void)showLoadingActivity :(UIViewController *)VC needToShow:(BOOL)isNeeded;
+(bool)connectedToInternet;
+(void)showAlert:(UIViewController*)actionVC messageString:(NSString*)message withTitle:(NSString*)title OKbutton:(NSString*)okTitle cancelButton:(NSString*)cancelTitle;

+(void)showPopupWithTextfield:(UIViewController*)VC withTitle:(NSString*)title messageString:(NSString*)message OKbutton:(NSString*)okTitle CancelButton:(NSString*)cancelTitle textFieldsDetails:(NSMutableArray*)tfArray;
+(void)showPopupWithSelectedDropdown:(UIViewController*)VC withTitle:(NSString*)title messageString:(NSString*)message OKbutton:(NSString*)okTitle CancelButton:(NSString*)cancelTitle textFieldsDetails:(NSMutableArray*)tfArray;

+(NSString *)convertingToJsonFormat:(NSDictionary *)dictJson;
+(UIColor*)getColorFromColorCode:(NSString*)colorCode;

@end
