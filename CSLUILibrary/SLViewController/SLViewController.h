//
//  SLViewController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import <UIKit/UIKit.h>

@class SLContext;
NS_ASSUME_NONNULL_BEGIN

@interface SLViewController : UIViewController
@property (nonatomic, strong) SLContext    *rootContext;
- (void)configMVP:(NSString*)name;
- (void)sl_setTransluentNavBar;// 设置顶部导航栏背景色为半透明颜色，但导航栏本身并不透明，如果想要导航栏透明，请调用# UIViewController (SLBase) sl_scrollToTranslucent

- (void)sl_setBackgroundImage:(UIImage *)image;// 自定义顶部导航栏图片
- (void)sl_setBackgroundImage:(UIImage *)image barMetrics:(UIBarMetrics)barMetrics;
- (void)sl_setBackImage:(UIImage *)image;// 自定义返回按钮图片
- (void)sl_setNavgationBarColor:(UIColor *)color;// 自定义顶部导航栏背景色
- (void)sl_setAllNavgationBarColor:(UIColor *)color;// 自定义全局顶部导航栏背景色
@end

NS_ASSUME_NONNULL_END
