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

- (void)sl_blurEffect {
    [self sl_blurEffect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)sl_blurEffectWithSyle:(EffectStyle)style {
    [self sl_blurEffect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:style];
}

- (void)sl_blurEffect:(CGRect)rect {
    [self sl_blurEffect:rect style:EffectStyleDefault];
}

- (void)sl_blurEffect:(CGRect)rect style:(EffectStyle)style {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:rect];
    switch (style) {
        case EffectStyleDefault:
            toolbar.barStyle = UIBarStyleDefault;
            break;
        case EffectStyleBlack:
            toolbar.barStyle = UIBarStyleBlack;
            break;
        case EffectStyleTranslucent:
            toolbar.barStyle = UIBarStyleBlack;
            toolbar.translucent = YES;
            break;
        default:
            break;
    }
    [self addSubview:toolbar];
}


@end
