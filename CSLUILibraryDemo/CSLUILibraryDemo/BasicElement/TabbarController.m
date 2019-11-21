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
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setTitle:titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        UIImage *normalImage = imageArray[i];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [arrayM addObject:tabbarBt];
    }
    self.onlyText.clickSLTabbarIndex = ^(NSInteger index) {
        NSLog(@"clickindex%ld", index);
    };
    self.onlyText.buttons = arrayM.copy;
    self.onlyText.configSLTabbarButton = ^(SLTabbarButton * _Nonnull barButton) {

    };
}

@end
