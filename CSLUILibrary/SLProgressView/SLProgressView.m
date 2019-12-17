//
//  SLProgressView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLProgressView.h"
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>

@implementation SLProgressView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.normalColor = SLUIHexColor(0xDDDEE2);
    self.trackerColor = SLUIHexColor(0x3297EF);
    self.corners = YES;
    [self setProgress:0.5 animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = MIN(1.0, progress);
    progress = MAX(0.0, progress);
    if (animated && progress > 0) {
        [UIView animateWithDuration:0.05 animations:^{
            if (ABS(self.progress - progress) < 0.1) {
                self.progress = progress;
            }
            if (self.progress > progress) {
                self.progress -= 0.1;
            } else if (self.progress < progress) {
                self.progress += 0.1;
            }
            [self setNeedsDisplay];
        }];
    } else {
        self.progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.normalImage) {
        CGContextSetFillColorWithColor(context, [[UIColor colorWithPatternImage:self.normalImage] CGColor]);
    } else if (self.normalColor) {
        CGContextSetFillColorWithColor(context, self.normalColor.CGColor);
    }
    UIBezierPath *bezierPath;
    if (self.corners) {
        self.radius = MIN(rect.size.width, rect.size.height) / 2.0;
    }
    if (self.radius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.radius];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
    }
    
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    if (self.progress > 0) {
        CGRect trackRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
        if (self.radius > 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:trackRect cornerRadius:self.radius];
        } else {
            bezierPath = [UIBezierPath bezierPathWithRect:trackRect];
        }
        if (self.trackerImage) {
            CGContextSetFillColorWithColor(context, [[UIColor colorWithPatternImage:self.trackerImage] CGColor]);
        } else if (self.trackerColor) {
            CGContextSetFillColorWithColor(context, self.trackerColor.CGColor);
        }
        CGContextAddPath(context, bezierPath.CGPath);
        CGContextDrawPath(context, kCGPathFill);
    }
}
@end
