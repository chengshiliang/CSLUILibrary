//
//  UIViewController+SLSliderMenuVC.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/25.
//

#import "UIViewController+SLSliderMenuVC.h"
#import <CSLUILibrary/SLSliderMenuViewController.h>

@implementation UIViewController (SLSliderMenuVC)
- (SLSliderMenuViewController *)slideMenu {
    UIViewController *sldeMenu = self.parentViewController;
    while (sldeMenu) {
        if ([sldeMenu isKindOfClass:[SLSliderMenuViewController class]]) {
            return (SLSliderMenuViewController *)sldeMenu;
        } else if (sldeMenu.parentViewController && sldeMenu.parentViewController != sldeMenu) {
            sldeMenu = sldeMenu.parentViewController;
        } else {
            sldeMenu = nil;
        }
    }
    return nil;
}
@end
