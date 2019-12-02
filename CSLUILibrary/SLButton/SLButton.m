//
//  SLButton.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLButton.h"

@implementation SLButton

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
    CGRect rect = CGRectMake(self.bounds.origin.x+borderWidth*1.0/2, self.bounds.origin.y+borderWidth*1.0/2, self.bounds.size.width-borderWidth, self.bounds.size.height-borderWidth);
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

@end
