//
//  RecycleViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RecycleViewController.h"

@interface RecycleViewController ()
@end

@implementation RecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SLRecycleView* scollView1=[[SLRecycleView alloc]initWithFrame:CGRectMake(10,80, 160,320)];
    scollView1.indicatorColor = [UIColor whiteColor];
    scollView1.currentIndicatorColor = [UIColor redColor];
    scollView1.autoTime = 3.0f;
    scollView1.imageDatas=@[@"cir0EFJOIWFU319FJQWEOIFJEFJEOJF01I3JF032JF03FJ0JF031JF013FJ0",@"cir1",@"cir2",@"cir3"];
    scollView1.titleDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    scollView1.showTitle = YES;
    scollView1.layer.masksToBounds=YES;
    scollView1.layer.borderColor=[[UIColor redColor]CGColor];
    scollView1.layer.borderWidth=2;
    [self.view addSubview:scollView1];
    [scollView1 startLoading];
    
    SLRecycleView* scollView2=[[SLRecycleView alloc]initWithFrame:CGRectMake(180,80, 160,320)];
    scollView2.indicatorColor = [UIColor whiteColor];
    scollView2.currentIndicatorColor = [UIColor redColor];
    scollView2.layer.masksToBounds=YES;
    scollView2.layer.borderColor=[[UIColor redColor]CGColor];
    scollView2.layer.borderWidth=2;
    scollView2.autoTime = 3.0f;
    scollView2.imageDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    scollView1.titleDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    scollView2.verticalScroll=YES;
    [scollView2 startLoading];
    [self.view addSubview:scollView2];
}

@end
