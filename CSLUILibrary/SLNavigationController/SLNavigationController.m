//
//  SLNavigationController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLNavigationController.h"
#import "UINavigationController+DelegateProxy.h"
#import "UIGestureRecognizer+Action.h"
#import <CSLUILibrary/SLNavTransitionAnimation.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLNavigationController ()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentAnimation;
@end

@implementation SLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;//默认设置导航栏不透明
    self.navigationBar.barTintColor = SLUIHexColor(0xe0e0e0);
    if ([self presentedViewController]) return;
    WeakSelf;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    [panGesture on:self click:^(UIGestureRecognizer *gesture) {
        StrongSelf;
        CGPoint movePoint = [panGesture translationInView:strongSelf.view];
        float precent = movePoint.x/[UIScreen mainScreen].bounds.size.width;
        if (panGesture.state == UIGestureRecognizerStateBegan) {
            strongSelf.percentAnimation = [[UIPercentDrivenInteractiveTransition alloc] init];
            [strongSelf popViewControllerAnimated:YES];
        }else if (panGesture.state == UIGestureRecognizerStateChanged){
            [strongSelf.percentAnimation updateInteractiveTransition:precent];
        }else {
            if (strongSelf.percentAnimation.percentComplete > 0.5) {
                [strongSelf.percentAnimation finishInteractiveTransition];
            }else {
                [strongSelf.percentAnimation cancelInteractiveTransition];
            }
            strongSelf.percentAnimation = nil;
        }
    }];
    //self.navigationBar.clipsToBounds = YES; 也可以处理黑线问题
    //self.navigationBarHidden 和 self.navigationBar.hidden 是不一样的。一个处理controller的显示隐藏。一个处理navibar的显示和隐藏
    [self interactionControllerForAnimation:^id<UIViewControllerInteractiveTransitioning>(UINavigationController * navigationController, id<UIViewControllerAnimatedTransitioning> animationController) {
        if ([animationController isKindOfClass:[SLNavTransitionAnimation class]]) {
            StrongSelf;
            return strongSelf.percentAnimation;
        }
        return nil;
    }];
    
    [self animationControllerForOperation:^id<UIViewControllerInteractiveTransitioning>(UINavigationController *navigationController, UINavigationControllerOperation operation, UIViewController * fromVC, UIViewController * toVC) {
        if (operation == UINavigationControllerOperationPop) {
            return (id<UIViewControllerInteractiveTransitioning>)[[SLNavTransitionAnimation alloc] init];;
        }
        return nil;
    }];
    
    [self.view addGestureRecognizer:panGesture];
    
    //        NSArray *targets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
    //        id target = [[targets lastObject] valueForKey:@"target"];
    //        SEL actionSel = NSSelectorFromString(@"handleNavigationTransition:");
    //
    //        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:actionSel];
    //        [self.view addGestureRecognizer:panGesture];// 添加系统的PopGestureRecognizer手势到当前view中
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
