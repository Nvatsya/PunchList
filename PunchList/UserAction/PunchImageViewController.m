//
//  PunchImageViewController.m
//  PunchList
//
//  Created by Nitin Vatsya on 23/09/19.
//  Copyright © 2019 gjit. All rights reserved.
//

#import "PunchImageViewController.h"
#import "PunchViewController.h"
#import "CommonClass.h"
#import "ConstantFile.h"
#import "SliderView.h"

@interface PunchImageViewController ()
{
    NSArray *colorMarkerArray;
}
@end

@implementation PunchImageViewController
@synthesize selectedImage;
@synthesize canvas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.frame;
    canvas = [[CanvasUIView alloc] initWithFrame:frame];
    [self.view addSubview:canvas];
    [canvas setImage:self.selectedImage];
    [self setupCanvasView];
}
-(void)setupMarkerViewForButton
{
    UIScrollView *markerView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 150, self.view.frame.size.width-10, 30)];
    //[markerView setBackgroundColor:[UIColor whiteColor]];
    [markerView setAlpha:0.9];
    [self.view addSubview:markerView];
    
    colorMarkerArray = [[NSArray alloc] initWithObjects:[UIColor redColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor greenColor],[UIColor blueColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor whiteColor],[UIColor grayColor],[UIColor lightTextColor], nil];
    CGFloat xPos = 0;
    for (int i=0; i<[colorMarkerArray count]; i++) {
        UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        colorBtn.frame = CGRectMake(xPos, 0, 60, 30);
        [colorBtn setBackgroundColor:[colorMarkerArray objectAtIndex:i]];
        [colorBtn setTag:i];
        [colorBtn addTarget:self action:@selector(selectColorForMarker:) forControlEvents:UIControlEventTouchUpInside];
        [markerView addSubview:colorBtn];
        xPos = colorBtn.frame.size.width+xPos+0.2;
    }
    [markerView setContentSize:CGSizeMake([colorMarkerArray count]*60, 30)];
    [markerView setShowsHorizontalScrollIndicator:false];
}
- (void)setupCanvasView
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/24, self.view.frame.size.height/10, self.view.frame.size.width-(self.view.frame.size.width/12), 25)];
    [instructionLabel setTextColor:[CommonClass getColorFromColorCode:themeColor]];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionLabel setText:@"Highlight the Issue with Marker"];
    [instructionLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [self.view addSubview:instructionLabel];
    
    [self setupMarkerViewForButton];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height-200, 200, 40)];
    [saveBtn setTitle:@"Save Image With Marks" forState:UIControlStateNormal];
    [saveBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(didTapSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor = [CommonClass getColorFromColorCode:themeColor];
    [self.view addSubview:saveBtn];
    
}

- (void)getImageToProcessAtCanvas: (UIImage *)selectedImage
{
    self.selectedImage = selectedImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectColorForMarker:(id)sender {
    NSInteger buttonIndex = [sender tag];
    canvas.lineColor= [colorMarkerArray objectAtIndex:buttonIndex];
}

- (IBAction)handelDoneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapErazerBtn:(id)sender {
    
      canvas.erasing=YES;
}

- (IBAction)didTapSaveBtn:(id)sender {

    UIImage *newImage=[canvas getTheImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GET_MARKED_IMAGE" object:@{@"newImg" : newImage}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
