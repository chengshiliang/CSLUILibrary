//
//  UINavigationBar+SLBase.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "UINavigationBar+SLBase.h"
#import <CSLUILibrary/UIScrollView+SLBase.h>
#import <CSLUILibrary/SLUtil.h>
#import <CSLUILibrary/UIView+SLBase.h>

@implementation UINavigationBar (SLBase)
/**
 改变导航栏透明度
 */
- (void)didChangeNavigationBarAlpha:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset.y%lf", scrollView.contentOffset.y);
    CGFloat alpha = 1.0;
    if (scrollView.sl_insetTop > 0) {
        if (scrollView.contentOffset.y > 0) {
            alpha = 0.0;
        } else {
            alpha = (-scrollView.contentOffset.y)/scrollView.sl_insetTop;
        }
    } else {
        CGFloat navHeight = 64.0f;
        if ([SLUtil bangsScreen]) {
            navHeight = 88.0f;
        }
        if (scrollView.contentOffset.y <= navHeight) {
            alpha = navHeight - scrollView.contentOffset.y/navHeight;
        } else {
            alpha = 0;
        }
    }
//    self setBackgroundImage: forBarMetrics:<#(UIBarMetrics)#>
}
@end
