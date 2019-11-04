//
//  SLNavTransitionAnimation.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLNavTransitionAnimation.h"
#import "NSObject+NavAnimation.h"
#import "CAAnimation+DelegateProxy.h"
#import <CSLUILibrary/SLUIConsts.h>
@interface SLNavTransitionAnimation()
@end

@implementation SLNavTransitionAnimation
- (instancetype)init {
    if (self == [super init]) {
        NSTimeInterval transitionDuration = 1.0f;
        [self transitionDurationBlock:^NSTimeInterval(id<UIViewControllerContextTransitioning>  _Nullable transitionContext) {
            return transitionDuration;
        }];
        [self animateTransitionBlock:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView *fromView = fromVC.view;
            UIView *toView = toVC.view;
            UIView *containerView = [transitionContext containerView];
            [containerView insertSubview:toView belowSubview:fromView];
            
            [UIView animateWithDuration:transitionDuration animations:^{
                fromView.frame =  CGRectMake(fromView.frame.size.width, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            } completion:^(BOOL finished) {
                // 务必 compelte Context
                [transitionContext completeTransition:YES];
            }];
            
//            CATransition *transition = [CATransition animation];
//            transition.type = @"cube";
//            transition.subtype = @"fromLeft";
//            transition.duration = transitionDuration;
//            transition.fillMode = kCAFillModeForwards;
//            transition.removedOnCompletion = NO;
//            [transition animationDidStopBlock:^(CAAnimation * _Nonnull animm, BOOL finished) {
//                [transitionContext completeTransition:YES];
//            }];
//            [containerView.layer addAnimation:transition forKey:nil];
//            [containerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        }];
        
        [self animationEndedBlock:^(BOOL transitionCompleted) {}];
    }
    return self;
}
@end
