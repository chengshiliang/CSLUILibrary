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
    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= scrollView.sl_insetTop){
        CGFloat alpha = (scrollView.sl_insetTop - scrollView.contentOffset.y);
        self.alpha = (alpha / 100.f);
    }
}
@end
