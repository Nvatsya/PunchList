//
//  TableViewCell.m
//  PunchList
//
//  Created by apple on 07/09/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)createCellForViewController :(UIViewController*)VC forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict andFieldName:(NSDictionary*)lableDict
{
    if ([listname isEqualToString:@"user"]) {
        //for (int i=0; i<[dataArr count]; i++) {
            UILabel *namelbl = [[UILabel alloc] init];
            namelbl.frame = CGRectMake(5, 0, 100, 22);
            namelbl.text = [lableDict valueForKey:@"namelbl"];
            namelbl.textColor = [UIColor grayColor];
            
            UILabel *datalbl = [[UILabel alloc] init];
            datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 0, VC.view.frame.size.width-120, 22);
            datalbl.text = [NSString stringWithFormat:@"User %@",[dataDict valueForKey:@"FirstName"]];
            datalbl.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl];
            [self.contentView addSubview:datalbl];
            
            UILabel *namelbl1 = [[UILabel alloc] init];
            namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 100, 22);
            namelbl1.text = [lableDict valueForKey:@"statuslbl"];
            namelbl1.textColor = [UIColor grayColor];
            
            UILabel *datalbl1 = [[UILabel alloc] init];
            datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl1.text = [NSString stringWithFormat:@"User %@",[lableDict valueForKey:@"statuslbl"]];
            datalbl1.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl1];
            [self.contentView addSubview:datalbl1];
            
            UILabel *namelbl2 = [[UILabel alloc] init];
            namelbl2.frame = CGRectMake(5, namelbl1.frame.origin.y+namelbl1.frame.size.height+10, 100, 22);
            namelbl2.text = [lableDict valueForKey:@"emaillbl"];
            namelbl2.textColor = [UIColor grayColor];
            
            UILabel *datalbl2 = [[UILabel alloc] init];
            datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl2.text = [NSString stringWithFormat:@"User %@",[dataDict valueForKey:@"UserEmail"]];
            datalbl2.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl2];
            [self.contentView addSubview:datalbl2];
       // }
    }
    
}
@end
