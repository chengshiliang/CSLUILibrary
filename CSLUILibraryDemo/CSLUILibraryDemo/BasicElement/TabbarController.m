//
//  TabbarController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/21.
//  Copyright © 2019 csl. All rights reserved.
//

#import "TabbarController.h"

@interface TabbarController ()
@property (nonatomic, weak) IBOutlet SLTabbarView *onlyText;
@property (nonatomic, weak) IBOutlet SLTabbarView *onlyImage;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageLeft;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageRight;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageTop;
@property (nonatomic, weak) IBOutlet SLTabbarView *imageBottom;
@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArray = @[@"test1", @"test2", @"test3", @"test4", @"test5"];
    NSArray *imageArray = @[@"tabBar_cart_normal", @"tabBar_category_normal", @"tabBar_find_normal", @"tabBar_home_normal", @"tabBar_myJD_normal"];
    NSArray *selectImageArray = @[@"tabBar_cart_press", @"tabBar_category_press", @"tabBar_find_press", @"tabBar_home_press", @"tabBar_myJD_press"];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0xff0000) forState:UIControlStateSelected];
        UIImage *normalImage = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage =[UIImage imageNamed:selectImageArray[i]];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:selectImage forState:UIControlStateSelected];
        [arrayM addObject:tabbarBt];
    }
    
    [self.onlyText initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeOnlyTitle;
    }];
    
    [self.onlyImage initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeOnlyImage;
    }];

    [self.imageTop initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageTop;
    }];

    [self.imageBottom initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageBottom;
    }];
    
    [self.imageLeft initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageLeft;
    }];

    [self.imageRight initButtons:arrayM.copy configTabbarButton:^(SLTabbarButton * _Nonnull button) {
        button.tabbarButtonType = SLButtonTypeImageRight;
    }];
}

@end
