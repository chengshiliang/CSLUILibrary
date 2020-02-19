//
//  SLViewController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLViewController.h"
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLCommonLibrary/NSObject+NavAnimation.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLUILibrary/SLContext.h>

@interface SLViewController ()
@property (nonatomic, strong) NSMutableDictionary   *eventMap;
@property (nonatomic, assign) BOOL                  mvpEnabled;
@end

@implementation SLViewController

- (void)configMVP:(NSString*)name {
    self.mvpEnabled = true;
    
    self.rootContext = [[SLContext alloc] init]; //strong
    self.context = self.rootContext; //weak
    
    Class presenterClass = NSClassFromString([NSString stringWithFormat:@"SL%@Presenter", name]);
    if (presenterClass != NULL) {
        self.context.presenter = [presenterClass new];
        self.context.presenter.context = self.context;
    }
    
    Class interactorClass = NSClassFromString([NSString stringWithFormat:@"SL%@Interactor", name]);
    if (interactorClass != NULL) {
        self.context.interactor = [interactorClass new];
        self.context.interactor.context = self.context;
    }
    
    Class viewClass = NSClassFromString([NSString stringWithFormat:@"SL%@View", name]);
    if (viewClass != NULL) {
        self.context.view = [viewClass new];
        self.context.view.context = self.context;
    }
    
    self.context.presenter.view = self.context.view;
    self.context.presenter.baseController = self;
    
    self.context.interactor.baseController = self;
    
    self.context.view.presenter = self.context.presenter;
    self.context.view.interactor = self.context.interactor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;// 设置self.view不占据nav块内容
    self.extendedLayoutIncludesOpaqueBars = NO;// 设置self.view不占据nav块内容
    UIImage *image = [UIImage imageNamed:@"SLIconBack"];
    [self sl_setBackImage:image];
    
    if (self.mvpEnabled) {
        self.context.view.frame = self.view.bounds;
        self.view = self.context.view;
    }
}

#pragma mark automaticallyAdjustsScrollViewInsets 为yes是，只会保证滚动视图的内容自动偏移，不会被UINavigationBar与UITabBar遮挡。对非滚动视图不会有任何调整

#pragma mark if (automaticallyAdjustsScrollViewInsets) { if (navigationBar.translucent) 非滚动视图会被导航栏遮挡,滚动视图不会被遮挡 else 非滚动视图和滚动视图都不会被遮挡 }
#pragma mark if (!automaticallyAdjustsScrollViewInsets) { if (navigationBar.translucent) 非滚动视图和滚动视图都会被遮挡 else 非滚动视图和滚动视图都不会被遮挡 }

#pragma mark edgesForExtendedLayout 边缘延伸属性，默认为UIRectEdgeAll。视图会延伸显示到导航栏的下面被覆盖；其值为UIRectEdgeNone意味着子控件本身会自动躲避导航栏和标签栏，以免被遮挡。 当你的view是UIScrollerView或其子（UITableView）时, automaticallyAdjustsScrollViewInsets设置为yes，控制器的view会在UIScrollerView或其子（UITableView）顶部添加inset，所以UIScrollerView或其子（UITableView）会出现在navigation bar的底部。但是滚动时又能覆盖整个屏幕：

- (void)sl_setTransluentNavBar {
    [self sl_setBackgroundImage:self.image];
}
- (void)sl_setBackgroundImage:(UIImage *)image {
    [self sl_setBackgroundImage:image barMetrics:UIBarMetricsDefault];
}
- (void)sl_setBackgroundImage:(UIImage *)image barMetrics:(UIBarMetrics)barMetrics {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:barMetrics];
}

- (void)sl_setBackImage:(UIImage *)image {
    if (Iphone11) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationController.navigationBar.backIndicatorImage = image;
        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = image;
    } else {
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
}

- (void)sl_setNavgationBarColor:(UIColor *)color {
    if(color==nil) return;
    self.navigationController.navigationBar.barTintColor=color;
}

- (void)sl_setAllNavgationBarColor:(UIColor *)color {
    if(color==nil) return;
    self.navigationController.navigationBar.barTintColor=color;
    [[UINavigationBar appearance]setBarTintColor:color];
}

- (UIImage *)image {
    UIGraphicsBeginImageContext(self.navigationController.navigationBar.bounds.size);
    [[[UIColor redColor]colorWithAlphaComponent:0.3] setFill];
    UIRectFill(CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
