//
//  TableViewCell.m
//  PunchList
//
//  Created by apple on 07/09/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "TableViewCell.h"
#import "ConstantFile.h"
#import "CommonClass.h"

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
            namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];
            
            UILabel *datalbl = [[UILabel alloc] init];
            datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 0, VC.view.frame.size.width-120, 22);
            datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"FirstName"]];
            //[CommonClass getColorFromColorCode:fontColor];
            [datalbl setTextColor:[UIColor whiteColor]];
            [self.contentView addSubview:namelbl];
            [self.contentView addSubview:datalbl];
            
            UILabel *namelbl1 = [[UILabel alloc] init];
            namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+5, 100, 22);
            namelbl1.text = [lableDict valueForKey:@"statuslbl"];
            namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
            
            UILabel *datalbl1 = [[UILabel alloc] init];
            datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"Status"]];
        //[CommonClass getColorFromColorCode:fontColor];
            [datalbl1 setTextColor:[UIColor whiteColor]];
            [self.contentView addSubview:namelbl1];
            [self.contentView addSubview:datalbl1];
            
            UILabel *namelbl2 = [[UILabel alloc] init];
            namelbl2.frame = CGRectMake(5, namelbl1.frame.origin.y+namelbl1.frame.size.height+5, 100, 22);
            namelbl2.text = [lableDict valueForKey:@"emaillbl"];
            namelbl2.textColor = [CommonClass getColorFromColorCode:lableColor];
            
            UILabel *datalbl2 = [[UILabel alloc] init];
            datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, VC.view.frame.size.width-120, 22);
            datalbl2.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"UserEmail"]];
            //[CommonClass getColorFromColorCode:fontColor];
            [datalbl2 setTextColor:[UIColor whiteColor]];
            [self.contentView addSubview:namelbl2];
            [self.contentView addSubview:datalbl2];
    }else if ([listname isEqualToString:@"dept"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 0, 120, 22);
        namelbl.text = [lableDict valueForKey:@"deptlbl"];
        namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 0, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentName"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 120, 22);
        namelbl1.text = [lableDict valueForKey:@"namelbl"];
        namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentAdmin"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl1 setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
        UILabel *namelbl2 = [[UILabel alloc] init];
        namelbl2.frame = CGRectMake(5, namelbl1.frame.origin.y+namelbl1.frame.size.height+10, 120, 22);
        namelbl2.text = [lableDict valueForKey:@"emaillbl"];
        namelbl2.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl2 = [[UILabel alloc] init];
        datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl2.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"DepartmentAdminEmail"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl2 setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl2];
        [self.contentView addSubview:datalbl2];
    }else if ([listname isEqualToString:@"project"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 20, 130, 22);
        namelbl.text = [lableDict valueForKey:@"namelbl"];
        namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 20, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectName"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 130, 22);
        namelbl1.text = [lableDict valueForKey:@"statuslbl"];
        namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectCode"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl1 setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
    }else if ([listname isEqualToString:@"status"]) {
        UILabel *namelbl = [[UILabel alloc] init];
        namelbl.frame = CGRectMake(5, 20, 130, 22);
        namelbl.text = [lableDict valueForKey:@"namelbl"];
        namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl = [[UILabel alloc] init];
        datalbl.frame = CGRectMake(namelbl.frame.size.width+10, 20, VC.view.frame.size.width-120, 22);
        datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"StatusDetail"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl];
        [self.contentView addSubview:datalbl];
        
        UILabel *namelbl1 = [[UILabel alloc] init];
        namelbl1.frame = CGRectMake(5, namelbl.frame.origin.y+namelbl.frame.size.height+10, 130, 22);
        namelbl1.text = [lableDict valueForKey:@"statuslbl"];
        namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
        
        UILabel *datalbl1 = [[UILabel alloc] init];
        datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, VC.view.frame.size.width-120, 22);
        datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"StatusCode"]];
        //[CommonClass getColorFromColorCode:fontColor];
        [datalbl1 setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:namelbl1];
        [self.contentView addSubview:datalbl1];
        
    }
//        CALayer* borderLayer = [self.contentView layer];
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
//        bottomBorder.borderWidth = 1;
//        bottomBorder.opacity = 0.50;
//        bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
//        [borderLayer addSublayer:bottomBorder];
}

-(void)createCellForPunchList :(UIViewController*)VC onTable:(UITableView*)table forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict forLables:(NSDictionary *)labelDict
{
    UIView *contentBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, height)];
    
    
    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.frame = CGRectMake(5, 10, 100, 22);
    namelbl.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchName"]];
    namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];;
    UILabel *datalbl = [[UILabel alloc] init];
    datalbl.frame = CGRectMake(namelbl.frame.size.width+10, namelbl.frame.origin.y, table.frame.size.width-(namelbl.frame.size.width+16), 22);
    datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"IssueName"]];
    datalbl.textColor = [UIColor whiteColor];// [CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl1 = [[UILabel alloc] init];
    namelbl1.frame = CGRectMake(5, (namelbl.frame.origin.y+namelbl.frame.size.height), 100, 22);
    namelbl1.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchDetail"]];
    namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl1 = [[UILabel alloc] init];
    datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, table.frame.size.width-(namelbl1.frame.size.width+16), 22);
    datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"IssueDescription"]];
    datalbl1.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl2 = [[UILabel alloc] init];
    namelbl2.frame = CGRectMake(5, (namelbl1.frame.origin.y+namelbl1.frame.size.height), 100, 22);
    namelbl2.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchDate"]];
    namelbl2.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl2 = [[UILabel alloc] init];
    datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, table.frame.size.width-(namelbl2.frame.size.width+16), 22);
    datalbl2.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"CreatedOn"]];
    datalbl2.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl3 = [[UILabel alloc] init];
    namelbl3.frame = CGRectMake(5, (namelbl2.frame.origin.y+namelbl2.frame.size.height), 100, 22);
    namelbl3.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchHolder"]];
    namelbl3.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl3 = [[UILabel alloc] init];
    datalbl3.frame = CGRectMake(namelbl3.frame.size.width+10, namelbl3.frame.origin.y, table.frame.size.width-(namelbl3.frame.size.width+16), 22);
    datalbl3.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"AssignedToUserName"]];
    datalbl3.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl4 = [[UILabel alloc] init];
    namelbl4.frame = CGRectMake(5, (namelbl3.frame.origin.y+namelbl3.frame.size.height), 100, 22);
    namelbl4.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchStatus"]];
    namelbl4.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl4 = [[UILabel alloc] init];
    datalbl4.frame = CGRectMake(namelbl4.frame.size.width+10, namelbl4.frame.origin.y, table.frame.size.width-(namelbl4.frame.size.width+16), 22);
    datalbl4.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"IssueStatus"]];
    datalbl4.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    [contentBG addSubview:namelbl];
    [contentBG addSubview:datalbl];
    [contentBG addSubview:namelbl1];
    [contentBG addSubview:datalbl1];
    [contentBG addSubview:namelbl2];
    [contentBG addSubview:datalbl2];
    [contentBG addSubview:namelbl3];
    [contentBG addSubview:datalbl3];
    [contentBG addSubview:namelbl4];
    [contentBG addSubview:datalbl4];
    [self.contentView addSubview:contentBG];
    
    
    CALayer* borderLayer = [contentBG layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.opacity = 0.50;
    bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
    [borderLayer addSublayer:bottomBorder];
}

-(void)createCellForProjectList :(UIViewController*)VC onTable:(UITableView*)table forList:(NSString*)listname heightOfRow:(float)height withData:(NSDictionary*)dataDict forLables:(NSDictionary *)labelDict
{
    UIView *contentBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, height)];
    
    
    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.frame = CGRectMake(5, 10, 130, 22);
    namelbl.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"ProjectName"]];
    namelbl.textColor = [CommonClass getColorFromColorCode:lableColor];;
    UILabel *datalbl = [[UILabel alloc] init];
    datalbl.frame = CGRectMake(namelbl.frame.size.width+10, namelbl.frame.origin.y, table.frame.size.width-(namelbl.frame.size.width+16), 22);
    datalbl.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectName"]];
    datalbl.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl1 = [[UILabel alloc] init];
    namelbl1.frame = CGRectMake(5, (namelbl.frame.origin.y+namelbl.frame.size.height), 130, 22);
    namelbl1.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"ProjectCode"]];
    namelbl1.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl1 = [[UILabel alloc] init];
    datalbl1.frame = CGRectMake(namelbl1.frame.size.width+10, namelbl1.frame.origin.y, table.frame.size.width-(namelbl1.frame.size.width+16), 22);
    datalbl1.text = [NSString stringWithFormat:@"%@",[dataDict valueForKey:@"ProjectCode"]];
    datalbl1.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
    UILabel *namelbl2 = [[UILabel alloc] init];
    namelbl2.frame = CGRectMake(5, (namelbl1.frame.origin.y+namelbl1.frame.size.height), 130, 22);
    namelbl2.text = [NSString stringWithFormat:@"%@",[labelDict valueForKey:@"PunchIssues"]];
    namelbl2.textColor = [CommonClass getColorFromColorCode:lableColor];
    UILabel *datalbl2 = [[UILabel alloc] init];
    datalbl2.frame = CGRectMake(namelbl2.frame.size.width+10, namelbl2.frame.origin.y, table.frame.size.width-(namelbl2.frame.size.width+16), 22);
    datalbl2.text = [NSString stringWithFormat:@"%lu",[[dataDict valueForKey:@"PunchIssues"] count]];
    datalbl2.textColor = [UIColor whiteColor];//[CommonClass getColorFromColorCode:fontColor];
    
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
