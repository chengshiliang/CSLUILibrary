//
//  SLTabBarController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>
@class SLTabbarButton;
NS_ASSUME_NONNULL_BEGIN

@interface SLTabBarController : UITabBarController
- (void)initViewControllers:(NSArray<UIViewController *> *)viewControllers titles:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)normalImages selectImages:(NSArray<UIImage *> *)selectImages layoutTabbar:(void(^ _Nullable)(SLTabbarButton *tabbar))layoutTabbarBlock;

- (void)sl_setTbbarBackgroundColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
