//
//  ProjDetailViewController.h
//  PunchList
//
//  Created by apple on 22/10/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PunchViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain)NSMutableDictionary *detailDict;
@property (nonatomic)BOOL isCreateIssue;

@end

NS_ASSUME_NONNULL_END
