//
//  SLTabBarController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLTabBarController.h"
#import <CSLUILibrary/SLNavigationController.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLTabbarButton.h>
#import <CSLUILibrary/SLTabbarView.h>
#import <CSLUILibrary/UIView+SLBase.h>

@interface SLTabBarController ()
{
    BOOL isLayout;
}
@property(nonatomic, strong) SLTabbarView *mTabBar;
@property(nonatomic, copy) NSArray *titleArray;
@property(nonatomic, copy) NSArray *normalImageArray;
@property(nonatomic, copy) NSArray *selectImageArray;
@end

@implementation SLTabBarController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.tabBar.barTintColor = SLUIHexColor(0xffffff);
    self.tabBar.translucent = NO;
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.clipsToBounds = YES;
}

- (void)initViewControllers:(NSArray<UIViewController *> *)viewControllers titles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectImages:(NSArray<UIImage *> *)selectImages navFlags:(NSArray<NSNumber *> *)navFlags layoutTabbar:(void(^)(SLTabbarView *tabbar))layoutTabbarBlock configTabbarButton:(nonnull void (^)(SLTabbarButton * button, NSInteger index))configTabbarButtonBlock{
    NSAssert(viewControllers.count == titles.count, @"vc length is not equals to title length");
    NSAssert(viewControllers.count == normalImages.count, @"vc length is not equals to normalImage length");
    NSAssert(viewControllers.count == selectImages.count, @"vc length is not equals to selectImage length");
    NSAssert(viewControllers.count == navFlags.count, @"vc length is not equals to navFlags length");
    NSMutableArray *viewControllerArrayM = [NSMutableArray arrayWithCapacity:viewControllers.count];
    int i = 0;
    for (UIViewController *vc in viewControllers) {
        if ([navFlags[i] boolValue]) {
            [viewControllerArrayM addObject:[[SLNavigationController alloc]initWithRootViewController:vc]];
        } else {
            [viewControllerArrayM addObject:vc];
        }
        i ++;
    }
    self.viewControllers = viewControllerArrayM.copy;
    self.titleArray = titles.copy;
    self.normalImageArray = normalImages.copy;
    self.selectImageArray = selectImages.copy;
    [self createTabBar:layoutTabbarBlock configTabbarButton:configTabbarButtonBlock];
    isLayout = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!isLayout) {
        isLayout = YES;
        self.mTabBar.frame = CGRectMake(0, 0, self.tabBar.sl_width, self.tabBar.sl_height);
    }
}

- (void)createTabBar:(void(^)(SLTabbarView *tabbar))layoutTabbarBlock configTabbarButton:(void (^)(SLTabbarButton *button, NSInteger index))configTabbarButtonBlock{
    [self.mTabBar removeFromSuperview];
    float tabbarWidth  = self.tabBar.sl_width;
    float tabbarHeight = self.tabBar.sl_height;
    SLTabbarView *tabbarView = [[SLTabbarView alloc] initWithFrame:CGRectMake(0, 0, tabbarWidth, tabbarHeight)];
    tabbarView.backgroundColor = SLUIHexColor(0xffffff);
    [self.tabBar insertSubview:tabbarView atIndex:0];
    self.mTabBar = tabbarView;
    WeakSelf;
    self.mTabBar.clickSLTabbarIndex = ^(SLTabbarButton *button,NSInteger index) {
        StrongSelf;
        strongSelf.selectedIndex = index;
    };
    if (layoutTabbarBlock) {
        layoutTabbarBlock(tabbarView);
    }
    if (self.titleArray.count <= 0) return;
    float tabbarItemWidth = tabbarWidth/self.titleArray.count;
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.titleArray.count];
    for (int i = 0; i < self.titleArray.count; i++){
        SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
        [tabbarBt setFrame:CGRectMake(i*tabbarItemWidth, 0, tabbarItemWidth, tabbarHeight)];
        [tabbarBt setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
        [tabbarBt setTitleColor:SLUIHexColor(0x0000ff) forState:UIControlStateSelected];
        UIImage *normalImage = self.normalImageArray[i];
        [tabbarBt setImage:normalImage forState:UIControlStateNormal];
        [tabbarBt setImage:self.selectImageArray[i] forState:UIControlStateSelected];
        [arrayM addObject:tabbarBt];
    }
    [self.mTabBar initButtons:arrayM.copy configTabbarButton:configTabbarButtonBlock];
}

- (void)sl_setTbbarBackgroundColor:(UIColor *)color {
    self.tabBar.barTintColor = color;
}

@end
