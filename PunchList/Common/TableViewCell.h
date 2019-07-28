//
//  TableViewCell.h
//  PunchList
//
//  Created by apple on 07/09/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

-(void)createCellForViewController :(UIViewController*)VC forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict andFieldName:(NSDictionary*)lableDict;

-(void)createCellForProjectList :(UIViewController*)VC onTable:(UITableView*)table forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict forLables:(NSDictionary *)labelDict;

-(void)createCellForPunchList :(UIViewController*)VC onTable:(UITableView*)table forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict forLables:(NSDictionary *)labelDict;

@end
