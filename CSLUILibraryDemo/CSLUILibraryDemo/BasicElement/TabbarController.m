//
//  TabbarController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/21.
//  Copyright © 2019 csl. All rights reserved.
//

#import "TabbarController.h"

@interface TabbarController ()
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, weak) IBOutlet SLTabbarView *onlyText;
@property (nonatomic, weak) IBOutlet SLTabbarView *onlyImage;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageLeft;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageRight;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageTop;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageBottom;
@end

@implementation TabbarController

#pragma mark 同一个view添加到不同的父视图上，不会被添加两次，他会从原来的父视图移除，然后添加到新的父视图上。
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = @[@"test1", @"test2", @"test3", @"test4", @"test5"];
    NSArray *imageArray = @[@"tabBar_cart_normal", @"tabBar_category_normal", @"tabBar_find_normal", @"tabBar_home_normal", @"tabBar_myJD_normal"];
    NSArray *selectImageArray = @[@"tabBar_cart_press", @"tabBar_category_press", @"tabBar_find_press", @"tabBar_home_press", @"tabBar_myJD_press"];
    NSMutableArray *arrayM1 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM1 addObject:tabbarBt];
    }
    
    NSMutableArray *arrayM2 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM2 addObject:tabbarBt];
    }
    
    NSMutableArray *arrayM3 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM3 addObject:tabbarBt];
    }
    
    NSMutableArray *arrayM4 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM4 addObject:tabbarBt];
    }
    
    NSMutableArray *arrayM5 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM5 addObject:tabbarBt];
    }
    
    NSMutableArray *arrayM6 = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM6 addObject:tabbarBt];
    }
    
    
    
    WeakSelf;
    self.onlyText.clickSLTabbarIndex = ^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        strongSelf.layer.frame = CGRectMake(button.offsetXY, strongSelf.onlyText.frame.size.height-2, button.frame.size.width, 2);
    };
    
    [self.onlyText initButtons:[NSArray arrayWithArray:arrayM1] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        NSInteger index = [arrayM1 indexOfObject:button];
        if (index == 0) {
            button.percent = 50;
        } else {
            button.percent = 150;
        }
        button.tabbarButtonType = SLButtonTypeOnlyTitle;
    }];
    
    self.layer = [CALayer layer];
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer.frame = CGRectMake(0, self.onlyText.frame.size.height-2, 0, 2);
    [self.onlyText.layer addSublayer:self.layer];

    [self.onlyImage initButtons:[NSArray arrayWithArray:arrayM2] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeOnlyImage;
    }];

    [self.imageTop initButtons:[NSArray arrayWithArray:arrayM3] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageTop;
        button.imageTitleSpace = -10.f;
    }];

    [self.imageBottom initButtons:[NSArray arrayWithArray:arrayM4] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageBottom;
        button.imageTitleSpace = -10.f;
    }];

    [self.imageLeft initButtons:[NSArray arrayWithArray:arrayM5] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageLeft;
        button.imageTitleSpace = -20.f;
    }];

    [self.imageRight initButtons:[NSArray arrayWithArray:arrayM6] configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageRight;
        button.imageTitleSpace = -20.f;
    }];
}

@end
