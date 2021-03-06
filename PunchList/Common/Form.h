//
//  Form.h
//  PunchList
//
//  Created by apple on 18/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataConnection.h"

@interface Form : NSObject <UITextFieldDelegate>

@property(nonatomic,retain)DataConnection *dataCon;

+(void)createFormWithTextField :(UIViewController *)VC PlaceholderText:(NSString *)placeholder FieldNameText:(NSString*)fieldTitle RightViewImage:(UIImage*)rightImage LeftViewImage:(UIImage*)leftImage FieldTagValue:(int)tagVal;

+(void)createFormWithList :(UIViewController *)VC forAction:(NSString*)name fieldsInfo:(NSMutableArray*)fieldsArr;

//+(void)createPunchView :(UIViewController*)VC fieldsInfo:(NSMutableArray*)fieldsArr withData:(NSDictionary*)dataDict;
+(void)createPunchView :(UIViewController*)VC fieldsInfo:(NSMutableArray*)fieldsArr;

@end
