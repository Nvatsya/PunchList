//
//  PunchImageViewController.h
//  PunchList
//
//  Created by Nitin Vatsya on 23/09/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasUIView.h"


NS_ASSUME_NONNULL_BEGIN

@interface PunchImageViewController : UIViewController


- (IBAction)didTapPenSelectionBtn:(id)sender;
- (IBAction)didTapErazerBtn:(id)sender;
- (IBAction)didTapSaveBtn:(id)sender;
- (void)getImageToProcessAtCanvas: (UIImage *)selectedImage;

@property (strong, nonatomic) CanvasUIView *canvas;
@property (nonatomic, assign) UIImage *selectedImage;

@end
NS_ASSUME_NONNULL_END
