//
//  UIView+SLBase.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "UIView+SLBase.h"

@implementation UIView (SLBase)
- (CGFloat)sl_height
{
    return self.frame.size.height;
}

- (void)setSl_height:(CGFloat)sl_height
{
    CGRect temp = self.frame;
    temp.size.height = sl_height;
    self.frame = temp;
}

- (CGFloat)sl_width
{
    return self.frame.size.width;
}

- (void)setSl_width:(CGFloat)sl_width
{
    CGRect temp = self.frame;
    temp.size.width = sl_width;
    self.frame = temp;
}


- (CGFloat)sl_y
{
    return self.frame.origin.y;
}

- (void)setSl_y:(CGFloat)sl_y
{
    CGRect temp = self.frame;
    temp.origin.y = sl_y;
    self.frame = temp;
}

- (CGFloat)sl_x
{
    return self.frame.origin.x;
}

- (void)setSl_x:(CGFloat)sl_x
{
    CGRect temp = self.frame;
    temp.origin.x = sl_x;
    self.frame = temp;
}
@end
