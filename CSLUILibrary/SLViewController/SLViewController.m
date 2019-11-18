//
//  SLViewController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLViewController.h"

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;// 设置self.view不占据nav块内容
    self.edgesForExtendedLayout = UIRectEdgeNone;// 设置self.view不占据nav块内容
}

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
    self.navigationController.navigationBar.backIndicatorImage = image;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = image;
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
    [[[UIColor whiteColor]colorWithAlphaComponent:0.0] setFill];
    UIRectFill(CGRectMake(0, 0, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
