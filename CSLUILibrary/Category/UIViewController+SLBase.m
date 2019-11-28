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

@implementation UIViewController (SLBase)
@dynamic interactiveTransition;
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

- (void)sl_setNavbarHidden:(BOOL)hidden {
    if ([self presentedViewController]) return;
    self.navigationController.navigationBarHidden = hidden;
}

- (void)sl_hiddenNavbar {
    if ([self presentedViewController]) return;
    [self sl_hiddenNavbarPreDeal];
    [self sl_setNavbarHidden:YES];
}

- (void)sl_showNavbar {
    if ([self presentedViewController]) return;
    [self sl_hiddenNavbarPreDeal];
    [self sl_setNavbarHidden:NO];
}

- (void)sl_hiddenNavbarPreDeal {
    [self swizzMethod:self action:WillDisappear callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        if (![obj isKindOfClass:[UIViewController class]]) return;
        UIViewController *currentVc = obj;
        [currentVc sl_setNavbarHidden:NO];
    }];
}

- (void)sl_setTranslucent:(BOOL)translucent {
    if ([self presentedViewController]) return;
    self.navigationController.navigationBar.translucent = translucent;
}

- (void)sl_scrollToTranslucent {
    if ([self presentedViewController]) return;
    [self sl_scrollToTranslucentPreDeal];
    [self sl_setTranslucent:YES];
}

- (void)sl_scrollToTranslucentPreDeal {
    [self swizzMethod:self action:WillDisappear callback:^(NSObject *__unsafe_unretained  _Nonnull obj) {
        if (![obj isKindOfClass:[UIViewController class]]) return;
        UIViewController *currentVc = obj;
        [currentVc sl_setTranslucent:NO];
        [currentVc.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }];
}

- (void)sl_scrollToTranslucentWithAlpha:(CGFloat)alpha {
    if ([self presentedViewController]) return;
    if (alpha >= 1) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        return;
    }
    UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
    UIImage *alphaImage = [UIImage sl_imageWithColor:alphaColor];
    [self.navigationController.navigationBar setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
}

- (void)sl_addPresentTrasition:(UIViewController *)presentController {
    WeakSelf;
    [self.interactiveTransition presentedController:presentController];
    [self addPresentedController:presentController];
    [self presentingControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull presentingController, UIViewController * _Nonnull sourceController) {
        return (id<UIViewControllerAnimatedTransitioning>)[[SLPresentTransitionAnimation alloc]init];
    }];
    [self dismissedControllerBlock:^id<UIViewControllerAnimatedTransitioning> _Nonnull(UIViewController * _Nonnull dismissedController) {
        return (id<UIViewControllerAnimatedTransitioning>)[[SLDissmissTransitionAnimation alloc]init];
    }];
    [self interactionDismissedControllerBlock:^id<UIViewControllerInteractiveTransitioning> _Nonnull(id<UIViewControllerAnimatedTransitioning>  _Nonnull animator) {
        StrongSelf;
        return strongSelf.interactiveTransition.isInteractive?strongSelf.interactiveTransition:nil;
    }];
}

- (SLPercentDrivenInteractiveTransition *)interactiveTransition {
    SLPercentDrivenInteractiveTransition *interactiveTransition = objc_getAssociatedObject(self, _cmd);
    if (!interactiveTransition) {
        interactiveTransition = [[SLPercentDrivenInteractiveTransition alloc]init];
        objc_setAssociatedObject(self, _cmd, interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return interactiveTransition;
}
@end
