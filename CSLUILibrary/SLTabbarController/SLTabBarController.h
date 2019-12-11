//
//  SLTabBarController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>
@class SLTabbarView;
@class SLTabbarButton;
NS_ASSUME_NONNULL_BEGIN

@interface SLTabBarController : UITabBarController
/*
 navFlags：是否使用内部的导航控制器，如果想要自定义，应该设置为false
 */
- (void)initViewControllers:(NSArray<UIViewController *> *)viewControllers titles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectImages:(NSArray<UIImage *> *)selectImages navFlags:(NSArray<NSNumber *> *)navFlags layoutTabbar:(void(^ _Nullable)(SLTabbarView *tabbar))layoutTabbarBlock configTabbarButton:(void (^)(SLTabbarButton * button, NSInteger index))configTabbarButtonBlock;

- (void)sl_setTbbarBackgroundColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
