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

- (void)addCornerRadius:(CGFloat)cornerRadius
            shadowColor:(UIColor *)shadowColor
           shadowOffset:(CGSize)shadowOffset
          shadowOpacity:(CGFloat)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius {
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectOffset(self.bounds, shadowOffset.width, shadowOffset.height) cornerRadius:shadowRadius];
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowPath = bezierPath2.CGPath;
}

- (void)addCornerRadius:(CGFloat)cornerRadius
            borderWidth:(CGFloat)borderWidth
            borderColor:(UIColor *)borderColor
        backGroundColor:(UIColor *)backColor {
    if (!backColor) {
        backColor = [UIColor clearColor];
    }
    if (!borderColor) {
        borderColor = [UIColor clearColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, backColor.CGColor);
    if (borderWidth > 0) {
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    } else {
        CGContextSetLineWidth(context, 0.0);
        CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    }
    UIBezierPath *bezierPath;
    CGRect rect = CGRectMake(self.bounds.origin.x+borderWidth*1.0/2, self.bounds.origin.y+borderWidth*1.0/2, self.bounds.size.width+borderWidth, self.bounds.size.height+borderWidth);
    if (cornerRadius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFillStroke);

    self.layer.contents = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
}

- (void)addCorner:(BOOL)corner {
    [self addCornerRadius:MIN(self.frame.size.width/2.0, self.frame.size.height/2.0)];
}

- (void)addCornerRadius:(CGFloat)cornerRadius {
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    UIBezierPath *bezierPath;
    if (cornerRadius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    shaperLayer.path = bezierPath.CGPath;
    self.layer.mask = shaperLayer;
}

+ (UIView *)copyView:(UIView *)view {
    if (!view) return nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}
@end
