//
//  UIAlertView+DelegateProxy.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/10/28.
//

#import "UIAlertView+DelegateProxy.h"
#import <objc/runtime.h>
#import "CSLDelegateProxy.h"

static void *kAlertViewShouldEnableFirstOtherButtonKey = "kAlertViewShouldEnableFirstOtherButtonKey";

@implementation UIAlertView (DelegateProxy)
- (void)buttonClicked:(void(^)(UIAlertView *alertView, int clickIndex))clickBlock{
    [self.delegateProxy addSelector:@selector(alertView:clickedButtonAtIndex:) callback:^(NSArray *params) {
        if (clickBlock && params.count == 2) {
            clickBlock(params[0],[params[1]intValue]);
        }
    }];
}
- (void)cancel:(void(^)(UIAlertView *alertView))cancelBlock{
    [self.delegateProxy addSelector:@selector(alertViewCancel:) callback:^(NSArray *params) {
        if (cancelBlock && params.count == 1) {
            cancelBlock(params[0]);
        }
    }];
}
- (void)willPresent:(void(^)(UIAlertView *alertView))willPresentBlock{
    [self.delegateProxy addSelector:@selector(willPresentAlertView:) callback:^(NSArray *params) {
        if (willPresentBlock && params.count == 1) {
            willPresentBlock(params[0]);
        }
    }];
}
- (void)didPresent:(void(^)(UIAlertView *alertView))didPresentBlock{
    [self.delegateProxy addSelector:@selector(didPresentAlertView:) callback:^(NSArray *params) {
        if (didPresentBlock && params.count == 1) {
            didPresentBlock(params[0]);
        }
    }];
}
- (void)willDismiss:(void(^)(UIAlertView *alertView, int clickIndex))willDismissBlock{
    [self.delegateProxy addSelector:@selector(alertView:willDismissWithButtonIndex:) callback:^(NSArray *params) {
        if (willDismissBlock && params.count == 2) {
            willDismissBlock(params[0],[params[1]intValue]);
        }
    }];
    
}
- (void)didDismiss:(void(^)(UIAlertView *alertView, int clickIndex))didDismissBlock{
    [self.delegateProxy addSelector:@selector(alertView:didDismissWithButtonIndex:) callback:^(NSArray *params) {
        if (didDismissBlock && params.count == 2) {
            didDismissBlock(params[0],[params[1]intValue]);
        }
    }];
}

- (void)shouldEnableFirstOtherButton:(BOOL (^)(UIAlertView* alerView))shouldEnableFirstOtherButtonBlock {
    objc_setAssociatedObject(self, kAlertViewShouldEnableFirstOtherButtonKey, shouldEnableFirstOtherButtonBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    BOOL (^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, kAlertViewShouldEnableFirstOtherButtonKey);
    if (shouldEnableFirstOtherButtonBlock) {
        return shouldEnableFirstOtherButtonBlock(alertView);
    }
    return YES;
}

- (CSLDelegateProxy *)delegateProxy {
    CSLDelegateProxy *delegateProxy = objc_getAssociatedObject(self, _cmd);
    if (!delegateProxy) {
        delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(UIAlertViewDelegate)];
        delegateProxy.delegate = self;
        self.delegate = (id<UIAlertViewDelegate>)delegateProxy;
        objc_setAssociatedObject(self, _cmd, delegateProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegateProxy;
}

- (void)dealloc {
    NSLog(@"alert view dealloc");
}
@end
