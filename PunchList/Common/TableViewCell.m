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
            UILabel *namelbl = [[UILabel alloc] init];
            namelbl.frame = CGRectMake(5, 0, 100, 22);
            namelbl.text = [lableDict valueForKey:@"namelbl"];
            namelbl.textColor = [UIColor grayColor];
            
            UILabel *datalbl = [[UILabel alloc] init];
            datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 0, VC.view.frame.size.width-120, 22);
            datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"FirstName"]];
            datalbl.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl];
            [self.contentView addSubview:datalbl];
            
            UILabel *namelbl1 = [[UILabel alloc] init];
            namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 100, 22);
            namelbl1.text = [lableDict valueForKey:@"statuslbl"];
            namelbl1.textColor = [UIColor grayColor];
            
            UILabel *datalbl1 = [[UILabel alloc] init];
            datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"Status"]];
            datalbl1.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl1];
            [self.contentView addSubview:datalbl1];
            
            UILabel *namelbl2 = [[UILabel alloc] init];
            namelbl2.frame = CGRectMake(5, namelbl1.frame.origin.y+namelbl1.frame.size.height+10, 100, 22);
            namelbl2.text = [lableDict valueForKey:@"emaillbl"];
            namelbl2.textColor = [UIColor grayColor];
            
            UILabel *datalbl2 = [[UILabel alloc] init];
            datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl2.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"UserEmail"]];
            datalbl2.textColor = [UIColor whiteColor];
            [self.contentView addSubview:namelbl2];
            [self.contentView addSubview:datalbl2];
    }else if ([listname isEqualToString:@"dept"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 0, 120, 22);
        namelbl.text = [lableDict valueForKey:@"deptlbl"];
        namelbl.textColor = [UIColor grayColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 0, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentName"]];
        datalbl.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 120, 22);
        namelbl1.text = [lableDict valueForKey:@"namelbl"];
        namelbl1.textColor = [UIColor grayColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentAdmin"]];
        datalbl1.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
        UILabel *namelbl2 = [[UILabel alloc] init];
        namelbl2.frame = CGRectMake(5, namelbl1.frame.origin.y+namelbl1.frame.size.height+10, 120, 22);
        namelbl2.text = [lableDict valueForKey:@"emaillbl"];
        namelbl2.textColor = [UIColor grayColor];
        
        UILabel *datalbl2 = [[UILabel alloc] init];
        datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl2.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentAdminEmail"]];
        datalbl2.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl2];
        [self.contentView addSubview:datalbl2];
    }else if ([listname isEqualToString:@"project"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 20, 130, 22);
        namelbl.text = [lableDict valueForKey:@"namelbl"];
        namelbl.textColor = [UIColor grayColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 20, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectName"]];
        datalbl.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 130, 22);
        namelbl1.text = [lableDict valueForKey:@"statuslbl"];
        namelbl1.textColor = [UIColor grayColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectCode"]];
        datalbl1.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
    }else if ([listname isEqualToString:@"status"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 20, 130, 22);
        namelbl.text = [lableDict valueForKey:@"namelbl"];
        namelbl.textColor = [UIColor grayColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 20, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"StatusDetail"]];
        datalbl.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 130, 22);
        namelbl1.text = [lableDict valueForKey:@"statuslbl"];
        namelbl1.textColor = [UIColor grayColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"StatusCode"]];
        datalbl1.textColor = [UIColor whiteColor];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
    }
        
}

-(void)createCellForProjectList :(UIViewController*)VC onTable:(UITableView*)table forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict forLables:(NSDictionary *)labelDict
{
    UIView *contentBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, height)];
    
    
    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.frame = CGRectMake(5, 10, 130, 22);
    namelbl.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"ProjectName"]];
    namelbl.textColor = [UIColor grayColor];
    UILabel *datalbl = [[UILabel alloc] init];
    datalbl.frame = CGRectMake(namelbl.frame.size.width+10, namelbl.frame.origin.y, table.frame.size.width-(namelbl.frame.size.width+16), 22);
    datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectName"]];
    datalbl.textColor = [UIColor whiteColor];
    
    UILabel *namelbl1 = [[UILabel alloc] init];
    namelbl1.frame = CGRectMake(5, (namelbl.frame.origin.y+namelbl.frame.size.height), 130, 22);
    namelbl1.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"ProjectCode"]];
    namelbl1.textColor = [UIColor grayColor];
    UILabel *datalbl1 = [[UILabel alloc] init];
    datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, table.frame.size.width-(namelbl1.frame.size.width+16), 22);
    datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectCode"]];
    datalbl1.textColor = [UIColor whiteColor];
    
    UILabel *namelbl2 = [[UILabel alloc] init];
    namelbl2.frame = CGRectMake(5, (namelbl1.frame.origin.y+namelbl1.frame.size.height), 130, 22);
    namelbl2.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchIssues"]];
    namelbl2.textColor = [UIColor grayColor];
    UILabel *datalbl2 = [[UILabel alloc] init];
    datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, table.frame.size.width-(namelbl2.frame.size.width+16), 22);
    datalbl2.text = [NSString stringWithFormat:@"%lu",[[dataDict valueForKey:@"PunchIssues"] count]];
    datalbl2.textColor = [UIColor whiteColor];
    
    [contentBG addSubview:namelbl];
    [contentBG addSubview:datalbl];
    [contentBG addSubview:namelbl1];
    [contentBG addSubview:datalbl1];
    [contentBG addSubview:namelbl2];
    [contentBG addSubview:datalbl2];
    
    [self.contentView addSubview:contentBG];
    
    
    CALayer* borderLayer = [contentBG layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.opacity = 0.50;
    bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
    [borderLayer addSublayer:bottomBorder];
}
@end
