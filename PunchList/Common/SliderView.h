 //
//  SliderView.h
//  SmartTrack
//
//  Created by User1 on 4/6/15.
//
//

#import <UIKit/UIKit.h>

@interface SliderView : UITableView<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>{
    id currentViewController;
}
+(UITableView*)createSliderForView:(UIViewController*)currentViewController withActionList:(NSArray*)ActionList;
+(void)showSlider;
+(void)hideSlider;
@property (nonatomic, strong)id currentViewController;

@end
