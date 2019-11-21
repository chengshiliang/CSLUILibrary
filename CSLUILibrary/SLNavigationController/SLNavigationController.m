//
//  SLNavigationController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLNavigationController.h"
#import <CSLCommonLibrary/UINavigationController+DelegateProxy.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLUILibrary/SLNavTransitionAnimation.h>
#import <CSLUILibrary/SLNavPushTransitionAnimation.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLNavigationController ()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentAnimation;
@end

@implementation SLNavigationController

+ (void)initialize {
    if (Iphone11) {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-kScreenWidth, 0)
        forBarMetrics:UIBarMetricsDefault];
    } else {
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
        forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark navigationBar.translucent 设置导航栏是否半透明。透明时，非滚动视图会被navigationbar遮挡，不透明时，不会遮挡任何视图

#pragma mark if (automaticallyAdjustsScrollViewInsets) { if (navigationBar.translucent) 非滚动视图会被导航栏遮挡,滚动视图不会被遮挡 else 非滚动视图和滚动视图都不会被遮挡 }
#pragma mark if (!automaticallyAdjustsScrollViewInsets) { if (navigationBar.translucent) 非滚动视图和滚动视图都会被遮挡 else 非滚动视图和滚动视图都不会被遮挡 }


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;//默认设置导航栏不透明
    self.navigationBar.barTintColor = SLUIHexColor(0xffffff);
    if ([self presentedViewController]) return;
    WeakSelf;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [panGesture on:self click:^(UIGestureRecognizer *gesture) {
        StrongSelf;
        CGPoint movePoint = [panGesture translationInView:strongSelf.view];
        float precent = movePoint.x/kScreenWidth;
        if (panGesture.state == UIGestureRecognizerStateBegan) {
            strongSelf.percentAnimation = [[UIPercentDrivenInteractiveTransition alloc] init];
            [strongSelf popViewControllerAnimated:YES];
        }else if (panGesture.state == UIGestureRecognizerStateChanged){
            [strongSelf.percentAnimation updateInteractiveTransition:precent];
        }else {
            if (strongSelf.percentAnimation.percentComplete > 0.3) {
                [strongSelf.percentAnimation finishInteractiveTransition];
            }else {
                [strongSelf.percentAnimation cancelInteractiveTransition];
            }
            strongSelf.percentAnimation = nil;
        }
    }];
    [self interactionControllerForAnimation:^id<UIViewControllerInteractiveTransitioning>(UINavigationController * navigationController, id<UIViewControllerAnimatedTransitioning> animationController) {
        if ([animationController isKindOfClass:[SLNavTransitionAnimation class]]) {
            StrongSelf;
            return strongSelf.percentAnimation;
        }
        return nil;
    }];
    
    [self animationControllerForOperation:^id<UIViewControllerInteractiveTransitioning>(UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController * fromVC, UIViewController * toVC) {
        if (operation == UINavigationControllerOperationPop) {
            return (id<UIViewControllerInteractiveTransitioning>)[[SLNavTransitionAnimation alloc] init];
        } else if (operation == UINavigationControllerOperationPush) {
            return (id<UIViewControllerInteractiveTransitioning>)[[SLNavPushTransitionAnimation alloc] init];
        }
        return nil;
    }];
    
    [self.view addGestureRecognizer:panGesture];
    /**
      系统返回手势
     */
    //        NSArray *targets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
    //        id target = [[targets lastObject] valueForKey:@"target"];
    //        SEL actionSel = NSSelectorFromString(@"handleNavigationTransition:");
    //
    //        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:actionSel];
    //        [self.view addGestureRecognizer:panGesture];// 添加系统的PopGestureRecognizer手势到当前view中
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.navigationBar.clipsToBounds = YES; 也可以处理黑线问题
    //self.navigationBarHidden 和 self.navigationBar.hidden 是不一样的。一个处理controller的显示隐藏。一个处理navibar的显示和隐藏
    for (UIView *view in self.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            for (UIView *subView in view.subviews) {
                if ([subView isKindOfClass:[UIImageView class]] && subView.frame.size.height <= 1) {// 这里遍历出导航条的黑线
                    subView.hidden = YES;
                    break;
                }
            }
            break;
        }
    }
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    self.hidesBottomBarWhenPushed = NO;
    return [super popToRootViewControllerAnimated:animated];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (self.viewControllers.count == 2) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return [super popViewControllerAnimated:animated];
}

@end
