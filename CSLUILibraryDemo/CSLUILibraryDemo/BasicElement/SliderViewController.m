//
//  SliderViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/17.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()
@property (nonatomic, weak) IBOutlet SLSliderView *sliderView;
@property (nonatomic, weak) IBOutlet SLSliderView *verticalSliderView;
@property (nonatomic, weak) IBOutlet SLDoubleSliderView *doubleSliderView;
@property (nonatomic, weak) IBOutlet SLDoubleSliderView *verticalDoubleSliderView;
@end

@implementation SliderViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.sliderView.progressChange = ^(CGFloat progress) {
        NSLog(@"%.2lf",progress);
    };
    self.verticalSliderView.vertical = YES;
    self.verticalSliderView.progressChange = ^(CGFloat progress) {
        NSLog(@"%.2lf",progress);
    };
    self.verticalDoubleSliderView.normalImage = [UIImage imageNamed:@"cir0.png"];
    self.verticalDoubleSliderView.trackerImage = [UIImage imageNamed:@"3.jpg"];
    self.verticalDoubleSliderView.vertical = YES;
    self.verticalDoubleSliderView.progressChange = ^(CGFloat startProgress, CGFloat endProgress) {
        NSLog(@"%.2lf~~~~~~%.2lf",startProgress, endProgress);
    };
    self.doubleSliderView.normalImage = [UIImage imageNamed:@"cir0.png"];
    self.doubleSliderView.trackerImage = [UIImage imageNamed:@"3.jpg"];
    self.doubleSliderView.progressChange = ^(CGFloat startProgress, CGFloat endProgress) {
        NSLog(@"%.2lf~~~~~~%.2lf",startProgress, endProgress);
    };
//    self.sliderView.progressHeight = 20;
//    self.sliderView.slideSize = CGSizeMake(50, 50);
    
//    SLImageView *imageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [imageView sl_setImage:[UIImage imageNamed:@"3.jpg"]];
//    SLView *view = [[SLView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [view addSubview:imageView];
//    [view addCornerRadius:25 borderWidth:5.0 borderColor:[UIColor redColor] backGroundColor:[UIColor whiteColor]];
//    [self.sliderView.slideView addSubview:view];
}

@end
