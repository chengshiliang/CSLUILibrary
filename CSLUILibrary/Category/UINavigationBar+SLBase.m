//
//  UINavigationBar+SLBase.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/18.
//

#import "UINavigationBar+SLBase.h"
#import <CSLUILibrary/UIScrollView+SLBase.h>

@implementation UINavigationBar (SLBase)
/**
 改变导航栏透明度
 */
- (void)didChangeNavigationBarAlpha:(UIScrollView *)scrollView{
    NSLog(@"scrollView.contentOffset.y%lf", scrollView.sl_insetTop);
    if(scrollView.contentOffset.y > 0){
        if (scrollView.contentOffset.y <= scrollView.sl_insetTop) {
            CGFloat alpha = (scrollView.sl_insetTop - scrollView.contentOffset.y);
            NSLog(@"alpha%lf", alpha/100.0f);
            self.alpha = MAX(0.1, (alpha / 100.f));
        } else {
            self.alpha = 0.0;
        }
    }
}
@end
