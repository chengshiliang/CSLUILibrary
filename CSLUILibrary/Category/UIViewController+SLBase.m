//
//  UIViewController+SLBase.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "UIViewController+SLBase.h"


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
@end
