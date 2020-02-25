//
//  SLSliderMenuViewController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/25.
//

#import "SLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLSliderMenuViewController : SLViewController
//主视图
@property (nonatomic, strong) UIViewController *rootViewController;
//左侧视图
@property (nonatomic, strong) UIViewController *leftViewController;
//右侧视图
@property (nonatomic, strong) UIViewController *rightViewController;
//菜单宽度
@property (nonatomic, assign) CGFloat menuWidth;
//留白宽度
@property (nonatomic, assign, readonly) CGFloat emptyWidth;
//是否允许滚动
@property (nonatomic ,assign) BOOL slideEnabled;
//创建方法
-(instancetype)initWithRootViewController:(UIViewController*)rootViewController;
//显示主视图
-(void)showRootViewControllerAnimated:(BOOL)animated;
//显示左侧菜单
-(void)showLeftViewControllerAnimated:(BOOL)animated;
//显示右侧菜单
-(void)showRightViewControllerAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
