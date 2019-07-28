//
//  Form.m
//  PunchList
//
//  Created by apple on 18/08/18.
//  Copyright © 2018 gjit. All rights reserved.
//

#import "Form.h"
#import "CommonClass.h"
#import "ConstantFile.h"

@implementation Form

+(void)createFormWithList :(UIViewController *)VC forAction:(NSString*)name fieldsInfo:(NSMutableArray*)fieldsArr
{
    UIView *fieldBgView = [[UIView alloc] initWithFrame:CGRectMake(VC.view.frame.size.width/14, VC.view.frame.size.height/6.8, VC.view.frame.size.width-(VC.view.frame.size.width/8),(66*[fieldsArr count]))];
    fieldBgView.tag = 5001;
    
    int yPos = 0;
    for (int i=0; i<[fieldsArr count]; i++) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        
        //Put username field - starts
        UITextField *textfield = [[UITextField alloc] init];
        textfield.frame = CGRectMake(0, yPos, fieldBgView.frame.size.width, 40);
        textfield.tag = [[[fieldsArr objectAtIndex:i] valueForKey:@"tagval"] intValue];
        textfield.delegate = VC;
        UIColor *color = [UIColor whiteColor];
        textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"]] attributes:@{NSForegroundColorAttributeName: color}];
        [fieldBgView addSubview:textfield];
        
        if ([[[fieldsArr objectAtIndex:i] valueForKey:@"leftview"] length]>0) {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"leftview"]]]];
            iconView.bounds = CGRectInset(iconView.frame, 25, 10);
            iconView.frame = CGRectMake(0, 0, 25, 25);
            //iconView.contentMode = UIViewContentModeScaleAspectFit;
            [paddingView addSubview:iconView];
            textfield.leftView=paddingView;
            textfield.leftViewMode=UITextFieldViewModeAlways;
        }
        if ([[[fieldsArr objectAtIndex:i] valueForKey:@"rightview"] length]>0) {
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"rightview"]]]];
            iconView.bounds = CGRectInset(iconView.frame, 25, 10);
            iconView.frame = CGRectMake(0, 0, 25, 25);
           // iconView.contentMode = UIViewContentModeScaleAspectFit;
            [paddingView addSubview:iconView];
            textfield.leftView=paddingView;
            textfield.leftViewMode=UITextFieldViewModeAlways;
        }
        
        CALayer* borderLayer = [textfield layer];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
        bottomBorder.borderWidth = 1;
        bottomBorder.opacity = 0.50;
        bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
        [borderLayer addSublayer:bottomBorder];
        //Put username field - End
        
        yPos =yPos + textfield.frame.size.height+10;
    }
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(fieldBgView.frame.size.width-(fieldBgView.frame.size.width/2.3), [fieldsArr count]*52, 140, 30);
    [addBtn setTitle:@"Add New" forState:UIControlStateNormal] ;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[CommonClass getColorFromColorCode:themeColor]];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:8];
    addBtn.titleLabel.font = [UIFont fontWithName:@"AvenirLTM" size:8];
    [addBtn addTarget:VC action:@selector(handleAddNewAction) forControlEvents:UIControlEventTouchUpInside];
    [fieldBgView addSubview:addBtn];
    fieldBgView.clipsToBounds = YES;
    [VC.view addSubview:fieldBgView];
    
    UITableView *table = [[UITableView alloc] init];
    table.frame = CGRectMake(fieldBgView.frame.origin.x, (fieldBgView.frame.size.height+fieldBgView.frame.origin.y), fieldBgView.frame.size.width, VC.view.frame.size.height-(fieldBgView.frame.size.height+fieldBgView.frame.origin.y+10));
    [table setBackgroundColor:[UIColor clearColor]];
    table.delegate = VC;
    table.dataSource = VC;
    [table setTag:1001];
    [VC.view addSubview:table];
}

//+(void)createPunchView :(UIViewController*)VC fieldsInfo:(NSMutableArray*)fieldsArr withData:(NSDictionary*)dataDict
+(void)createPunchView :(UIViewController*)VC fieldsInfo:(NSMutableArray*)fieldsArr
{
    UIView *fieldBg = [[UIView alloc] initWithFrame:CGRectMake(VC.view.frame.size.width/30, VC.view.frame.size.height/8, VC.view.frame.size.width-(VC.view.frame.size.width/15), VC.view.frame.size.height-(VC.view.frame.size.height/1.9))];
    [fieldBg setTag:5001];
    [VC.view addSubview:fieldBg];
    
    int yPos = 0;
    for (int i=0; i<[fieldsArr count]; i++) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        if ([[[fieldsArr objectAtIndex:i] valueForKey:@"fieldType"] isEqualToString:@"textView"]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos,  fieldBg.frame.size.width, 30)];
            label.text = [[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"];
            label.textColor = [UIColor whiteColor];
            yPos = yPos + 40;
            [fieldBg addSubview:label];
            
            UITextView *textfield = [[UITextView alloc] init];
            textfield.frame = CGRectMake(0, yPos, fieldBg.frame.size.width, fieldBg.frame.size.height-yPos-30);
            textfield.tag = [[[fieldsArr objectAtIndex:i] valueForKey:@"tagval"] intValue];
            textfield.delegate = VC;
            textfield.text = [[fieldsArr objectAtIndex:i] valueForKey:@"Value"];
            [textfield setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgcopy.png"]] ];
            
            [textfield setTextColor:[UIColor whiteColor]];
            [textfield setOpaque:NO];
            [fieldBg setOpaque:YES];
//            textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"]] attributes:@{NSForegroundColorAttributeName: color}];
            [fieldBg addSubview:textfield];
            
            yPos = yPos + textfield.frame.size.height+10;
        }else{
            //Put textfield - starts
            UITextField *textfield = [[UITextField alloc] init];
            textfield.frame = CGRectMake(0, yPos, fieldBg.frame.size.width, 40);
            textfield.tag = [[[fieldsArr objectAtIndex:i] valueForKey:@"tagval"] intValue];
            textfield.delegate = VC;
            UIColor *color = [UIColor whiteColor];
            textfield.textColor = color;
            textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"]] attributes:@{NSForegroundColorAttributeName: color}];
            [fieldBg addSubview:textfield];
            
            //Put values in textfields
            if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:department]) {
                textfield.text = [NSString stringWithFormat:@"%@", [[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?@"":[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]];
            }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:assignedTo]){
                textfield.text = [NSString stringWithFormat:@"%@", [[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?@"": [[fieldsArr objectAtIndex:i] valueForKey:@"Value"]];
            }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:punchStatus]){
                textfield.text = [NSString stringWithFormat:@"%@", [[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?@"":[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]];
            }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:description]){
                textfield.text = [NSString stringWithFormat:@"%@", [[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?@"":[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]];
            }else if ([[[fieldsArr objectAtIndex:i] valueForKey:@"Placeholder"] isEqualToString:punchTitle]){
                textfield.text = [NSString stringWithFormat:@"%@", [[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?@"":[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]];
                [textfield setUserInteractionEnabled:[[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?YES:NO];
                [textfield setTextColor:[[[fieldsArr objectAtIndex:i] valueForKey:@"Value"]length]==0?color:[UIColor lightGrayColor]];
            }
            
            
            // values ends
            
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[fieldsArr objectAtIndex:i] valueForKey:@"leftview"]]]];
            iconView.bounds = CGRectInset(iconView.frame, 25, 20);
            iconView.frame = CGRectMake(0, 0, 35, 35);
            [paddingView addSubview:iconView];
            textfield.rightView = paddingView;
            textfield.rightViewMode=UITextFieldViewModeAlways;
//            textfield.leftView = paddingView;
//            textfield.leftViewMode = UITextFieldViewModeAlways;
            
            CALayer* borderLayer = [textfield layer];
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.borderColor = [UIColor darkGrayColor].CGColor;
            bottomBorder.borderWidth = 1;
            bottomBorder.opacity = 0.50;
            bottomBorder.frame = CGRectMake(0, borderLayer.frame.size.height-1, borderLayer.frame.size.width, 1);
            [borderLayer addSublayer:bottomBorder];
            //Put username field - End
            
            yPos =yPos + textfield.frame.size.height+10;
        }
    }
    
}


+(void)createFormWithTextField :(UIViewController *)VC PlaceholderText:(NSString *)placeholder FieldNameText:(NSString*)fieldTitle RightViewImage:(UIImage*)rightImage LeftViewImage:(UIImage*)leftImage FieldTagValue:(int)tagVal
{
    
}
@end
