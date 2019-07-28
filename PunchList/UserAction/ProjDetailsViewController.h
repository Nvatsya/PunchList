//
//  ProjDetailsViewController.h
//  PunchList
//
//  Created by Nitin Vatsya on 23/07/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, retain)NSDictionary *projDict;

@end

NS_ASSUME_NONNULL_END
