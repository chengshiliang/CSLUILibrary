//
//  UIViewController+SLBase.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SLBase)
+ (UIViewController *)sl_getRootViewController;
+ (UIViewController *)sl_getCurrentViewController:(UIViewController *)currentViewController;
+ (UIViewController *)sl_getCurrentViewController;
/*
 获取多次present出来最底层presenting的控制器
 */
+ (UIViewController *)sl_getPresentingViewController;

- (void)sl_setTranslucent:(BOOL)translucent;
/**
 页面滚动导航栏变透明
 */
- (void)sl_scrollToTranslucent;
- (void)sl_scrollToTranslucentWithAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
