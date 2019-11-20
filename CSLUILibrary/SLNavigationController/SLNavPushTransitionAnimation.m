//
//  SLNavPushTransitionAnimation.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/19.
//

#import "SLNavPushTransitionAnimation.h"
#import <CSLCommonLibrary/NSObject+NavAnimation.h>
#import <CSLUILibrary/SLUIConsts.h>

@implementation SLNavPushTransitionAnimation
- (instancetype)init {
    if (self == [super init]) {
        NSTimeInterval transitionDuration = 0.3f;
        [self transitionDurationBlock:^NSTimeInterval(id<UIViewControllerContextTransitioning>  _Nullable transitionContext) {
            return transitionDuration;
        }];
        [self animateTransitionBlock:^(id<UIViewControllerContextTransitioning>  _Nonnull transitionContext) {
            UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
            UIView* toView = nil;
            UIView* fromView = nil;
            
            if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
                fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
                toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            } else {
                fromView = fromVC.view;
                toView = toVC.view;
            }
            UIView *containerView = [transitionContext containerView];
            [containerView addSubview:toView];
            
            toView.frame = CGRectMake(toView.frame.size.width, 0, kScreenWidth, kScreenHeight);
            [UIView animateWithDuration:transitionDuration animations:^{
                toView.frame = CGRectMake(0, 0, toView.frame.size.width, toView.frame.size.height);
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
