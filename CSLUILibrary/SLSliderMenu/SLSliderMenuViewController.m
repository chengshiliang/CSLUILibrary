//
//  SLSliderMenuViewController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/25.
//

#import "SLSliderMenuViewController.h"
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLCommonLibrary/SLUIConsts.h>

//遮罩层最高透明度
static CGFloat MaxCoverAlpha = 0.3;
//快速滑动最小触发速度
static CGFloat MinActionSpeed = 500;

@interface SLSliderMenuViewController (){
    //记录起始位置
    CGPoint _originalPoint;
}
//遮罩view
@property (nonatomic, strong) UIView *coverView;
//拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation SLSliderMenuViewController

-(instancetype)initWithRootViewController:(UIViewController*)rootViewController{
    if (self = [super init]) {
        self.rootViewController = rootViewController;
        [self addChildViewController:self.rootViewController];
        [self.view addSubview:self.rootViewController.view];
        [self.rootViewController didMoveToParentViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.pan = [[UIPanGestureRecognizer alloc] init];
    WeakSelf;
    [self.pan on:self click:^(UIGestureRecognizer * _Nonnull gesture) {
        StrongSelf;
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [strongSelf pan:(UIPanGestureRecognizer *)gesture];
        }
    }];
    [self.pan gestureRecognizerShouldReceiveTouchBlock:^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer, UITouch * _Nonnull touch) {
        StrongSelf;
        //设置Navigation子视图不可拖拽
        if ([strongSelf.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)strongSelf.rootViewController;
            if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
                return NO;
            }
        }
        //如果Tabbar的当前视图是UINavigationController，设置UINavigationController子视图不可拖拽
        if ([strongSelf.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarController = (UITabBarController*)strongSelf.rootViewController;
            UINavigationController *navigationController = tabbarController.selectedViewController;
            if ([navigationController isKindOfClass:[UINavigationController class]]) {
                if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled) {
                    return NO;
                }
            }
        }
        //设置拖拽响应范围
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            //拖拽响应范围是距离边界是空白位置宽度
            CGFloat actionWidth = [strongSelf emptyWidth];
            CGPoint point = [touch locationInView:gestureRecognizer.view];
            if (point.x <= actionWidth || point.x > strongSelf.view.bounds.size.width - actionWidth) {
                return YES;
            } else {
                return NO;
            }
        }
        return YES;
    }];
    [self.view addGestureRecognizer:self.pan];
    
    
    self.coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0;
    self.coverView.hidden = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap on:self click:^(UIGestureRecognizer * _Nonnull gesture) {
        StrongSelf;
        [strongSelf showRootViewControllerAnimated:true];
    }];
    [self.rootViewController.view addSubview:self.coverView];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self updateLeftMenuFrame];
    
    [self updateRightMenuFrame];
}

#pragma mark -
#pragma mark Setter&&Getter

-(void)setLeftViewController:(UIViewController *)leftViewController{
    self.leftViewController = leftViewController;
    //提前设置ViewController的viewframe，为了懒加载view造成的frame问题，所以通过setter设置了新的view
    self.leftViewController.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self menuWidth], self.view.bounds.size.height)];
    //自定义View需要主动调用viewDidLoad
    [self.leftViewController viewDidLoad];
    [self addChildViewController:self.leftViewController];
    [self.view insertSubview:self.leftViewController.view atIndex:0];
    [self.leftViewController didMoveToParentViewController:self];
}

-(void)setRightViewController:(UIViewController *)rightViewController{
    self.rightViewController = rightViewController;
    //提前设置ViewController的viewframe，为了懒加载view造成的frame问题，所以通过setter设置了新的view
    self.rightViewController.view = [[UIView alloc] initWithFrame:CGRectMake([self emptyWidth], 0, [self menuWidth], self.view.bounds.size.height)];
    //自定义View需要主动调用viewDidLoad
    [self.rightViewController viewDidLoad];
    [self addChildViewController:self.rightViewController];
    [self.view insertSubview:self.rightViewController.view atIndex:0];
    [self.rightViewController didMoveToParentViewController:self];
}

-(void)setSlideEnabled:(BOOL)slideEnabled{
    self.pan.enabled = slideEnabled;
}

-(BOOL)slideEnabled{
    return self.pan.isEnabled;
}

#pragma mark -
#pragma mark 拖拽方法
-(void)pan:(UIPanGestureRecognizer*_Nonnull)pan{
    switch (pan.state) {
            //记录起始位置 方便拖拽移动
        case UIGestureRecognizerStateBegan:
            self->_originalPoint = self.rootViewController.view.center;
            break;
        case UIGestureRecognizerStateChanged:
            [self panChanged:pan];
            break;
        case UIGestureRecognizerStateEnded:
            //滑动结束后自动归位
            [self panEnd:pan];
            break;
        default:
            break;
    }
}


//拖拽方法
-(void)panChanged:(UIPanGestureRecognizer*)pan{
    //拖拽的距离
    CGPoint translation = [pan translationInView:self.view];
    //移动主控制器
    self.rootViewController.view.center = CGPointMake(self->_originalPoint.x + translation.x, self->_originalPoint.y);
    //判断是否设置了左右菜单
    if (!self.rightViewController && CGRectGetMinX(self.rootViewController.view.frame) <= 0 ) {
        self.rootViewController.view.frame = self.view.bounds;
    }
    if (!self.leftViewController && CGRectGetMinX(self.rootViewController.view.frame) >= 0) {
        self.rootViewController.view.frame = self.view.bounds;
    }
    //滑动到边缘位置后不可以继续滑动
    if (CGRectGetMinX(self.rootViewController.view.frame) > self.menuWidth) {
        self.rootViewController.view.center = CGPointMake(self.rootViewController.view.bounds.size.width/2 + self.menuWidth, self.rootViewController.view.center.y);
    }
    if (CGRectGetMaxX(self.rootViewController.view.frame) < self.emptyWidth) {
        self.rootViewController.view.center = CGPointMake(self.rootViewController.view.bounds.size.width/2 - self.menuWidth, self.rootViewController.view.center.y);
    }
    //判断显示左菜单还是右菜单
    if (CGRectGetMinX(self.rootViewController.view.frame) > 0) {
        //显示左菜单
        [self.view sendSubviewToBack:self.rightViewController.view];
        //更新左菜单位置
        [self updateLeftMenuFrame];
        //更新遮罩层的透明度
        self.coverView.hidden = false;
        [self.rootViewController.view bringSubviewToFront:self.coverView];
        self.coverView.alpha = CGRectGetMinX(self.rootViewController.view.frame)/self.menuWidth * MaxCoverAlpha;
    }else if (CGRectGetMinX(self.rootViewController.view.frame) < 0){
        //显示右菜单
        [self.view sendSubviewToBack:self.leftViewController.view];
        //更新右侧菜单的位置
        [self updateRightMenuFrame];
        //更新遮罩层的透明度
        self.coverView.hidden = false;
        [self.rootViewController.view bringSubviewToFront:self.coverView];
        self.coverView.alpha = (CGRectGetMaxX(self.view.frame) - CGRectGetMaxX(self.rootViewController.view.frame))/self.menuWidth * MaxCoverAlpha;
    }
}

//拖拽结束
- (void)panEnd:(UIPanGestureRecognizer*)pan {
    
    //处理快速滑动
    CGFloat speedX = [pan velocityInView:pan.view].x;
    if (ABS(speedX) > MinActionSpeed) {
        [self dealWithFastSliding:speedX];
        return;
    }
    //正常速度
    if (CGRectGetMinX(self.rootViewController.view.frame) > self.menuWidth/2) {
        [self showLeftViewControllerAnimated:true];
    }else if (CGRectGetMaxX(self.rootViewController.view.frame) < self.menuWidth/2 + self.emptyWidth){
        [self showRightViewControllerAnimated:true];
    }else{
        [self showRootViewControllerAnimated:true];
    }
}

//处理快速滑动
- (void)dealWithFastSliding:(CGFloat)speedX {
    //向左滑动
    BOOL swipeRight = speedX > 0;
    //向右滑动
    BOOL swipeLeft = speedX < 0;
    //rootViewController的左边缘位置
    CGFloat roootX = CGRectGetMinX(self.rootViewController.view.frame);
    if (swipeRight) {//向右滑动
        if (roootX > 0) {//显示左菜单
            [self showLeftViewControllerAnimated:true];
        }else if (roootX < 0){//显示主菜单
            [self showRootViewControllerAnimated:true];
        }
    }
    if (swipeLeft) {//向左滑动
        if (roootX < 0) {//显示右菜单
            [self showRightViewControllerAnimated:true];
        }else if (roootX > 0){//显示主菜单
            [self showRootViewControllerAnimated:true];
        }
    }
    return;
}

#pragma mark -
#pragma mark 显示/隐藏方法
//显示主视图
-(void)showRootViewControllerAnimated:(BOOL)animated{
    
    [UIView animateWithDuration:[self animationDurationAnimated:animated] animations:^{
        CGRect frame = self.rootViewController.view.frame;
        frame.origin.x = 0;
        self.rootViewController.view.frame = frame;
        [self updateLeftMenuFrame];
        [self updateRightMenuFrame];
        self.coverView.alpha = 0;
    }completion:^(BOOL finished) {
        self.coverView.hidden = true;
    }];
}

//显示左侧菜单
- (void)showLeftViewControllerAnimated:(BOOL)animated {
    if (!self.leftViewController) {return;}
    [self.view sendSubviewToBack:self.rightViewController.view];
    self.coverView.hidden = false;
    [self.rootViewController.view bringSubviewToFront:self.coverView];
    [UIView animateWithDuration:[self animationDurationAnimated:animated] animations:^{
        self.rootViewController.view.center = CGPointMake(self.rootViewController.view.bounds.size.width/2 + self.menuWidth, self.rootViewController.view.center.y);
        self.leftViewController.view.frame = CGRectMake(0, 0, [self menuWidth], self.view.bounds.size.height);
        self.coverView.alpha = MaxCoverAlpha;
    }];
}

//显示右侧菜单
- (void)showRightViewControllerAnimated:(BOOL)animated {
    if (!self.rightViewController) {return;}
    self.coverView.hidden = false;
    [self.rootViewController.view bringSubviewToFront:self.coverView];
    [self.view sendSubviewToBack:self.leftViewController.view];
    [UIView animateWithDuration:[self animationDurationAnimated:animated] animations:^{
        self.rootViewController.view.center = CGPointMake(self.rootViewController.view.bounds.size.width/2 - self.menuWidth, self.rootViewController.view.center.y);
        self.rightViewController.view.frame = CGRectMake([self emptyWidth], 0, [self menuWidth], self.view.bounds.size.height);
        self.coverView.alpha = MaxCoverAlpha;
    }];
}

#pragma mark -
#pragma mark 其它方法
//更新左侧菜单位置
- (void)updateLeftMenuFrame {
    self.leftViewController.view.center = CGPointMake(CGRectGetMinX(self.rootViewController.view.frame)/2, self.leftViewController.view.center.y);
}

//更新右侧菜单位置
- (void)updateRightMenuFrame {
    self.rightViewController.view.center = CGPointMake((self.view.bounds.size.width + CGRectGetMaxX(self.rootViewController.view.frame))/2, self.rightViewController.view.center.y);
}

//菜单宽度
- (CGFloat)menuWidth {
    if (_menuWidth <= 0) {
        return 0.6 * self.view.bounds.size.width;
    }
    return _menuWidth;
}

//空白宽度
- (CGFloat)emptyWidth {
    return self.view.bounds.size.width - self.menuWidth;
}

//动画时长
- (CGFloat)animationDurationAnimated:(BOOL)animated {
    return animated ? 0.25 : 0;
}

//取消自动旋转
- (BOOL)shouldAutorotate {
    return false;
}

@end
