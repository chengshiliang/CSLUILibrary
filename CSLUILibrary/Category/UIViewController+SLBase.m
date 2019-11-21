//
//  UIViewController+SLBase.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "UIViewController+SLBase.h"
#import <CSLUILibrary/UIImage+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLCommonLibrary/NSObject+Base.h>
#import <CSLCommonLibrary/UIViewController+DelegateProxy.h>
#import <CSLUILibrary/SLViewController.h>
#import <objc/runtime.h>

static void *kViewControllerTranslucentKey = "kViewControllerTranslucentKey";

@implementation UIViewController (SLBase)
+ (UIViewController *)sl_getRootViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)sl_getCurrentViewController:(UIViewController *)currentViewController{
    if ([currentViewController presentedViewController]) {
        UIViewController *nextRootVC = [currentViewController presentedViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *nextRootVC = [(UITabBarController *)currentViewController selectedViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    } else if ([currentViewController isKindOfClass:[UINavigationController class]]){
        UIViewController *nextRootVC = [(UINavigationController *)currentViewController visibleViewController];
        currentViewController = [self sl_getCurrentViewController:nextRootVC];
    }
    return currentViewController;
}
+ (UIViewController *)sl_getCurrentViewController {
    return [self sl_getCurrentViewController:[self sl_getRootViewController]];
}

+ (UIViewController *)sl_getPresentingViewController {
    UIViewController *controller = [self sl_getCurrentViewController];
    if ([controller presentedViewController]) {
        while(controller.presentingViewController != nil){
            controller = controller.presentingViewController;
        }
        return controller;
    }
    return nil;
}

- (void)sl_setTranslucent:(BOOL)translucent {
    if ([self presentedViewController]) return;
    self.navigationController.navigationBar.translucent = translucent;
}

- (void)sl_scrollToTranslucent {
    if ([self presentedViewController]) return;
    [self sl_scrollToTranslucentPreDeal];
    [self sl_setTranslucent:YES];
    [self sl_scrollToTranslucentWithAlpha:1];
}

- (void)sl_scrollToNoTranslucent {
    if ([self presentedViewController]) return;
    [self sl_scrollToTranslucentPreDeal];
    [self sl_setTranslucent:NO];
    [self sl_scrollToTranslucentWithAlpha:0];
}

- (void)sl_scrollToTranslucentPreDeal {
    objc_setAssociatedObject(self, &kViewControllerTranslucentKey, @(self.navigationController.navigationBar.isTranslucent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    WeakSelf;
    [self swizzDisappearMethod:self callback:^(NSObject *__unsafe_unretained  _Nonnull disappearObj) {
        StrongSelf;
        NSNumber *isTranslucent = objc_getAssociatedObject(strongSelf, &kViewControllerTranslucentKey);
        [strongSelf sl_setTranslucent:[isTranslucent boolValue]];
    }];
}

- (void)sl_scrollToTranslucentWithAlpha:(CGFloat)alpha {
    if ([self presentedViewController]) return;
    UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
    UIImage *alphaImage = [UIImage sl_imageWithColor:alphaColor];
    [self.navigationController.navigationBar setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
}

- (void)sl_addPresentTrasition:(UIViewController *)presentController {
    WeakSelf;
    [self.interactiveTransition presentedController:presentController];
    [self addPresentedController:presentController];
    [self presentingControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull presentingController, UIViewController * _Nonnull sourceController) {
        return [[SLPresentTransitionAnimation alloc]init];
    }];
    [self dismissedControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull dismissedController) {
        return [[SLDissmissTransitionAnimation alloc]init];
    }];
    [self interactionDismissedControllerBlock:^id<UIViewControllerInteractiveTransitioning> _Nonnull(id<UIViewControllerAnimatedTransitioning>  _Nonnull animator) {
        StrongSelf;
        return strongSelf.interactiveTransition.isInteractive?strongSelf.interactiveTransition:nil;
    }];
}

- (SLPercentDrivenInteractiveTransition *)interactiveTransition {
    SLPercentDrivenInteractiveTransition *interactiveTransition = objc_getAssociatedObject(self, _cmd);
    if (!interactiveTransition) {
        NSLog(@"new interactiveTransition");
        interactiveTransition = [[SLPercentDrivenInteractiveTransition alloc]init];
        objc_setAssociatedObject(self, _cmd, interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return interactiveTransition;
}
@end
