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
#import <CSLCommonLibrary/UIControl+Events.h>

@interface SLTabBarController ()
{
    BOOL isLayout;
}
@property(nonatomic, strong) SLTabbarButton *selectBarButton;
@property(nonatomic, assign) NSInteger currentSelectIndex;
@property(nonatomic, strong) SLTabbarView *mTabBar;
@property(nonatomic, copy) void(^configTabbarBlock)(SLTabbarView *tabbar);
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
    self.currentSelectIndex = 100;
    self.tabBar.barTintColor = SLUIHexColor(0xffffff);
    self.tabBar.translucent = NO;
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.shadowImage = [UIImage new];
}

- (void)initViewControllers:(NSArray<UIViewController *> *)viewControllers titles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectImages:(NSArray<UIImage *> *)selectImages navFlags:(NSArray<NSNumber *> *)navFlags layoutTabbar:(void(^)(SLTabbarView *tabbar))layoutTabbarBlock{
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
    self.configTabbarBlock = [layoutTabbarBlock copy];
    isLayout = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!isLayout) {
        isLayout = YES;
        [self createTabBar:self.configTabbarBlock];
    }
}

- (void)createTabBar:(void(^)(SLTabbarView *tabbar))layoutTabbarBlock{
    [self.mTabBar removeFromSuperview];
    float tabbarWidth  = self.tabBar.frame.size.width;
    float tabbarHeight = self.tabBar.frame.size.height;
    SLTabbarView *tabbarView = [[SLTabbarView alloc] initWithFrame:CGRectMake(0, 0, tabbarWidth, tabbarHeight)];
    tabbarView.backgroundColor = SLUIHexColor(0xffffff);
    if (self.titleArray.count > 0) {
        float tabbarItemWidth = tabbarWidth/self.titleArray.count;
        for (int i = 0; i < self.titleArray.count; i++){
            SLTabbarButton *tabbarBt = [[SLTabbarButton alloc] init];
            [tabbarBt setFrame:CGRectMake(i*tabbarItemWidth, 0, tabbarItemWidth, tabbarHeight)];
            WeakSelf;
            [tabbarBt onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl *control) {
                StrongSelf;
                if ([control isKindOfClass:[SLTabbarButton class]]) {
                    SLTabbarButton *currentBt = (SLTabbarButton *)control;
                    if (strongSelf.selectBarButton == currentBt) {
                        return;
                    }
                    strongSelf.currentSelectIndex = currentBt.tag;
                    strongSelf.selectBarButton.selected = NO;
                    strongSelf.selectBarButton = currentBt;
                    strongSelf.selectBarButton.selected = YES;
                }
            }];
            tabbarBt.tag = 100+i;
            [tabbarBt setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [tabbarBt setTitleColor:SLUIHexColor(0x666666) forState:UIControlStateNormal];
            [tabbarBt setTitleColor:SLUIHexColor(0x0000ff) forState:UIControlStateSelected];
            UIImage *normalImage = self.normalImageArray[i];
            [tabbarBt setImage:normalImage forState:UIControlStateNormal];
            [tabbarBt setImage:self.selectImageArray[i] forState:UIControlStateSelected];
            [tabbarView addSubview:tabbarBt];
            if (tabbarBt.tag == self.currentSelectIndex) {
                self.selectBarButton = tabbarBt;
                self.selectBarButton.selected = YES;
            }
        }
    }
    if (layoutTabbarBlock) {
        layoutTabbarBlock(tabbarView);
    }
    [self.tabBar insertSubview:tabbarView atIndex:0];
    self.tabBar.clipsToBounds = YES;
    self.mTabBar = tabbarView;
}

- (void)sl_setTbbarBackgroundColor:(UIColor *)color {
    self.tabBar.barTintColor = color;
}

@end
