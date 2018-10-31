//
//  CommonClass.m
//  PunchList
//
//  Created by apple on 15/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "CommonClass.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "ConstantFile.h"
#import <CoreText/CoreText.h>

@implementation CommonClass


+(void)showLoadingActivity :(UIViewController *)VC needToShow:(BOOL)isNeeded
{
    UIActivityIndicatorView *spinner;
    if (isNeeded) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
        [spinner.layer setCornerRadius:20];
        [spinner setBackgroundColor:[self getColorFromColorCode:themeColor]];
        [VC.view addSubview:spinner];
        spinner.center = VC.view.center;
        [spinner startAnimating];
        [VC.view setUserInteractionEnabled:FALSE];
    }else{
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        [spinner hidesWhenStopped];
        [VC.view setUserInteractionEnabled:YES];
    }
    
}
+(bool)connectedToInternet
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    bool result = false;
    if (internetStatus == ReachableViaWiFi)
    {
        result = true;
    }
    else if(internetStatus==ReachableViaWWAN){
        result=true;
    }
    
    return result;
}

+(void)showAlert:(UIViewController*)actionVC messageString:(NSString*)message withTitle:(NSString*)title OKbutton:(NSString*)okTitle cancelButton:(NSString*)cancelTitle
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    if (okTitle.length>0) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                // [self.navigationController ];
                                 //BUTTON OK CLICK EVENT
                             }];
        [alert addAction:cancel];
        [alert addAction:ok];
    }else{
        [alert addAction:cancel];
    }
    
    [actionVC presentViewController:alert animated:YES completion:nil];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:actionVC cancelButtonTitle:cancelTitle otherButtonTitles:okTitle.length>0?okTitle:nil, nil];
//    alert.delegate = actionVC;
//
//    [alert show];
}

+(void)showPopupWithTextfield:(UIViewController*)VC withTitle:(NSString*)title messageString:(NSString*)message OKbutton:(NSString*)okTitle CancelButton:(NSString*)cancelTitle textFieldsDetails:(NSMutableArray*)tfArray
{
    NSMutableAttributedString *titleString = [[ NSMutableAttributedString alloc]initWithString:title];
    NSUInteger len = [title length];
    NSRange strRange=NSMakeRange(0, len);
    
    [titleString addAttribute:NSForegroundColorAttributeName value:[CommonClass getColorFromColorCode:themeColor] range:strRange];
    [titleString addAttribute: NSFontAttributeName
                       value:[UIFont systemFontOfSize:16 weight:UIFontWeightBold]
                       range:strRange];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @""
                                                                              message: message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:titleString forKey:@"attributedTitle"];
    
    for (int i=0; i<[tfArray count]; i++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = [[tfArray objectAtIndex:i] valueForKey:@"fieldname"];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//            textField.borderStyle = UITextBorderStyleRoundedRect;
//            textField.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
        }];
    }
    
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                         {
                             NSArray * textfields = alertController.textFields;
                             UITextField * namefield = textfields[0];
                             
                             LoginViewController *logVC=[[LoginViewController alloc] init];
                             [logVC submitUserNameforForgotPassword:namefield.text];
                         }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    if (okTitle.length>0) {
        [alertController addAction:ok];
        [alertController addAction:cancel];
    }
    alertController.view.tintColor = [CommonClass getColorFromColorCode:themeColor];
    alertController.transitioningDelegate = VC.transitioningDelegate;
    
    [VC presentViewController:alertController animated:YES completion:nil];

}

+(NSString *)convertingToJsonFormat:(NSDictionary *)dictJson
{
    NSString *jsonString=@"{";
    int count=0;
    
    for (id key in dictJson){
        count++;
        if (count<dictJson.count) {
            
            if ([[dictJson valueForKey:key] isKindOfClass:[NSString class]]) {
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":\"%@\",",key,[dictJson objectForKey:key]];
            }else{
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":%@,",key,[dictJson objectForKey:key]];
            }
            
        }
        else {
            
            if ([[dictJson valueForKey:key] isKindOfClass:[NSString class]]) {
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":\"%@\"}",key,[dictJson objectForKey:key]];
            }else{
                jsonString=[jsonString stringByAppendingFormat:@"\"%@\":%@}",key,[dictJson objectForKey:key]];
            }
            
            
        }
        
    }
    
    return jsonString;
}

+(UIColor*)getColorFromColorCode:(NSString*)colorCode{
    
    NSString *redString=[colorCode substringWithRange:NSMakeRange(1, 2)];
    NSString *greenString=[colorCode substringWithRange:NSMakeRange(3, 2)];
    NSString *blueString=[colorCode substringWithRange:NSMakeRange(5, 2)];
    
    NSString *rStr=redString;
    NSScanner *rScanner=[NSScanner scannerWithString:rStr];
    
    unsigned int rHexValue;
    [rScanner scanHexInt:&rHexValue];
    
    NSString *gStr=greenString;
    NSScanner *gScanner=[NSScanner scannerWithString:gStr];
    
    unsigned int gHexValue;
    [gScanner scanHexInt:&gHexValue];
    
    NSString *bStr=blueString;
    NSScanner *bScanner=[NSScanner scannerWithString:bStr];
    
    unsigned int bHexValue;
    [bScanner scanHexInt:&bHexValue];
    
    CGFloat redValue=((float)rHexValue/255);
    CGFloat greenValue=((float)gHexValue/255);
    CGFloat blueValue=((float)bHexValue/255);
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1];
}
@end
