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
    self.sliderView.progressView.trackerImage = [UIImage imageNamed:@"3.jpg"];
    self.sliderView.progressView.normalImage = [UIImage imageNamed:@"cir0.png"];
    self.sliderView.minValue = 0.2;
    self.sliderView.maxValue = 0.8;
    self.sliderView.progressChange = ^(CGFloat progress) {
        NSLog(@"%.2lf",progress);
    };
    self.verticalSliderView.progressView.trackerImage = [UIImage imageNamed:@"3.jpg"];
    self.verticalSliderView.progressView.normalImage = [UIImage imageNamed:@"cir0.png"];
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
//    self.doubleSliderView.progressWH = 20;
//    self.doubleSliderView.slideSize = CGSizeMake(50, 50);
//    for (UIView *subView in self.doubleSliderView.slideViewArray) {
//        SLImageView *imageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
//        [imageView sl_setImage:[UIImage imageNamed:@"3.jpg"]];
//        [subView addSubview:imageView];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [subView addCornerRadius:25 borderWidth:5.0 borderColor:[UIColor redColor] backGroundColor:[UIColor whiteColor]];
//        });
//        [imageView addCorner:YES];
//    }
    
    [self.doubleSliderView setStartProgress:0.4 endProgress:0.8 animated:YES];
}

@end
