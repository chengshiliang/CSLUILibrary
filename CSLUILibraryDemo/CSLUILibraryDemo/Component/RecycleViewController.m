//
//  RecycleViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RecycleViewController.h"

@interface RecycleViewController ()
@property (weak, nonatomic) IBOutlet SLRecycleView *scollView1;
@property (weak, nonatomic) IBOutlet SLRecycleView *scollView2;
@end

@implementation RecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scollView1.backgroundColor = [UIColor redColor];
    self.scollView1.autoScroll = NO;
    self.scollView1.indicatorColor = [UIColor whiteColor];
    self.scollView1.currentIndicatorColor = [UIColor redColor];
    self.scollView1.autoTime = 3.0f;
    self.scollView1.cellMargin = 100.f;
    self.scollView1.imageDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    self.scollView1.titleDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    self.scollView1.showTitle = YES;
    self.scollView1.layer.masksToBounds=YES;
    self.scollView1.titleSpace = 15.0f;
    [self.scollView1 startLoading];

    self.scollView2.backgroundColor = [UIColor yellowColor];
    self.scollView2.autoScroll = NO;
    self.scollView2.indicatorColor = [UIColor whiteColor];
    self.scollView2.currentIndicatorColor = [UIColor redColor];
    self.scollView2.layer.masksToBounds=YES;
    self.scollView2.autoTime = 3.0f;
    self.scollView2.cellMargin = 10.f;
    self.scollView2.imageDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    self.scollView2.titleDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    self.scollView2.verticalScroll=YES;
    [self.scollView2 startLoading];
}

@end
