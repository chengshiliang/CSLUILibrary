//
//  SLPopoverView.m
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//
//

#import "SLPopoverView.h"
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLTabbarView.h>
#import <CSLUILibrary/UIView+SLBase.h>

@implementation SLPopoverAction
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SLPopoverAction *action))handler{
    return [self actionWithImage:nil title:title handler:handler];
}
+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(SLPopoverAction *action))handler {
    SLPopoverAction *action = [[self alloc] init];
    action.image = image;
    action.title = title;
    action.handler = handler;
    return action;
}
@end

float PopoverViewDegreesToRadians(float angle)
{
    return angle*M_PI/180.0;
}

@interface SLPopoverView ()

@property (nonatomic, strong) SLView *backView;
@property (nonatomic, strong) SLTabbarView *containerView;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
@property (nonatomic, copy) NSArray<SLPopoverAction *> *actions;
@property (nonatomic, assign) BOOL isUpward;

@end

@implementation SLPopoverView

- (instancetype)init {
    if ((self = [super init])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backView = [[SLView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    WeakSelf;
    [tapGesture on:self click:^(UIGestureRecognizer * _Nonnull gesture) {
        StrongSelf;
        [strongSelf hide];
    }];
    [self.backView addGestureRecognizer:tapGesture];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    self.containerView = [[SLTabbarView alloc]init];
    self.containerView.direction = Vertical;
    self.containerView.needLineView = YES;
    [self addSubview:self.containerView];
}

- (CGFloat)arrowWH {
    if (_arrowWH < 1) {
        return 16;
    }
    return _arrowWH;
}

- (CGFloat)spaceVertical {
    if (_spaceVertical < 0.05) {
        return 10;
    }
    return _spaceVertical;
}

- (CGFloat)spaceHorizontal {
    if (_spaceHorizontal < 0.05) {
        return 10;
    }
    return _spaceHorizontal;
}

- (UIEdgeInsets)contentInset {
    if ([NSStringFromUIEdgeInsets(_contentInset) isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)]) {
        return UIEdgeInsetsMake(10, 8, 10, 8);
    }
    return _contentInset;
}

- (CGFloat)itemHeight {
    if (_itemHeight < 0.1) {
        return 40;
    }
    return _itemHeight;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = SLUIHexColor(0x666666);
    }
    return _titleColor;
}
- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = SLUINormalFont(14.0);
    }
    return _titleFont;
}

- (CGSize)imageSize {
    if ([NSStringFromCGSize(_imageSize) isEqualToString:NSStringFromCGSize(CGSizeZero)]) {
        return CGSizeMake(30, 30);
    }
    return _imageSize;
}

- (UIColor *)strokeColor {
    if (!_strokeColor) {
        _strokeColor = SLUIHexColor(0x999999);
    }
    return _strokeColor;
}

- (CGFloat)cornerRadius {
    if (_cornerRadius < 0.1) {
        return 10;
    }
    return _cornerRadius;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = CGRectMake(self.contentInset.left, self.isUpward ? self.arrowWH+self.contentInset.top : self.contentInset.top, CGRectGetWidth(self.bounds)-self.contentInset.left-self.contentInset.right, CGRectGetHeight(self.bounds) - self.arrowWH-self.contentInset.top-self.contentInset.bottom);
}

- (void)setHideAfterTouch:(BOOL)hideAfterTouch {
    _hideAfterTouch = hideAfterTouch;
    self.backView.userInteractionEnabled = hideAfterTouch;
}

- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        self.containerView.alpha = 0.f;
        self.alpha = 0.f;
        self.backView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self.containerView removeFromSuperview];
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

- (void)showToView:(UIView *)pointView withActions:(NSArray<SLPopoverAction *> *)actions {
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat pointViewTopY = CGRectGetMinY(pointViewRect);
    CGFloat pointViewBottomY = kScreenHeight - CGRectGetMaxY(pointViewRect);
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    if (pointViewTopY > pointViewBottomY) {
        toPoint.y = pointViewTopY - self.spaceVertical;
    } else {
        toPoint.y = CGRectGetMaxY(pointViewRect) + self.spaceVertical;
    }
    self.isUpward = pointViewTopY <= pointViewBottomY;
    self.actions = [actions copy];
    [self showToPoint:toPoint];
}

- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<SLPopoverAction *> *)actions {
    self.actions = [actions copy];
    self.isUpward = toPoint.y <= kScreenHeight - toPoint.y;
    if (self.isUpward) {
        toPoint.y += self.spaceVertical;
    } else {
        toPoint.y -= self.spaceVertical;
    }
    [self showToPoint:toPoint];
}

- (void)showToPoint:(CGPoint)toPoint {
    CGFloat minHorizontalEdgeLeft = self.spaceHorizontal + self.contentInset.left + self.arrowWH/2.0;
    if (toPoint.x < minHorizontalEdgeLeft) {
        toPoint.x = minHorizontalEdgeLeft;
    }
    CGFloat minHorizontalEdgeRight = self.spaceHorizontal + self.contentInset.right + self.arrowWH/2.0;
    if (kScreenWidth - toPoint.x < minHorizontalEdgeRight) {
        toPoint.x = kScreenWidth - minHorizontalEdgeRight;
    }
    
    CGFloat currentW = [self calculateMaxWidth];
    CGFloat currentH = self.actions.count * self.itemHeight;
    if (self.actions.count == 0) {
        currentW = 150.0;
        currentH = 20.0;
    }
    currentH += self.arrowWH;
//    CGFloat maxHeight = self.isUpward ? (kScreenHeight - toPoint.y - self.spaceVertical) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - self.spaceVertical);
//    currentH = MIN(currentH, maxHeight);
    
    CGFloat currentX = toPoint.x - currentW/2.0, currentY = toPoint.y;
    if (toPoint.x <= currentW/2 + self.spaceHorizontal) {
        currentX = self.spaceHorizontal;
    }
    if (kScreenWidth - toPoint.x <= currentW/2 + self.spaceHorizontal) {
        currentX = kScreenWidth - self.spaceHorizontal - currentW;
    }
    if (!self.isUpward) {
        currentY = toPoint.y - currentH;
    }
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.actions.count];
    for (SLPopoverAction *action in self.actions) {
        SLTabbarButton *button = [[SLTabbarButton alloc] init];
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        if (action.image) [button setImage:action.image forState:UIControlStateNormal];
        [arrayM addObject:button];
    }
    self.containerView.lineColor = self.strokeColor;
    WeakSelf;
    self.containerView.clickSLTabbarIndex = ^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        SLPopoverAction *action = strongSelf.actions[index];
        !action.handler ?: action.handler(action);
        [strongSelf hide];
    };
    
    [self.containerView initButtons:[NSArray arrayWithArray:arrayM] configTabbarButton:^(SLTabbarButton * _Nonnull button, NSInteger index) {
        StrongSelf;
        if (button.currentImage) button.tabbarButtonType = SLButtonTypeImageLeft;
        else button.tabbarButtonType = SLButtonTypeOnlyTitle;
        button.imageSize = strongSelf.imageSize;
        button.imageTitleSpace = strongSelf.imageTitleSpace;
        button.titleLabel.font = strongSelf.titleFont;
        button.titleLabel.textAlignment = NSTextAlignmentRight;
    }];
    
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), self.isUpward ? 0 : currentH);
    CGFloat maskTop = self.isUpward ? self.arrowWH : 0;
    CGFloat maskBottom = self.isUpward ? currentH : currentH - self.arrowWH;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0, self.cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(self.cornerRadius, self.cornerRadius + maskTop)
                        radius:self.cornerRadius
                    startAngle:PopoverViewDegreesToRadians(180)
                      endAngle:PopoverViewDegreesToRadians(270)
                     clockwise:YES];
    if (self.isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - self.arrowWH/2, self.arrowWH)];
        [maskPath addLineToPoint:arrowPoint];
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + self.arrowWH/2, self.arrowWH)];
    }
    [maskPath addLineToPoint:CGPointMake(currentW - self.cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - self.cornerRadius, maskTop + self.cornerRadius)
                        radius:self.cornerRadius
                    startAngle:PopoverViewDegreesToRadians(270)
                      endAngle:PopoverViewDegreesToRadians(0)
                     clockwise:YES];
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - self.cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - self.cornerRadius, maskBottom - self.cornerRadius)
                        radius:self.cornerRadius
                    startAngle:PopoverViewDegreesToRadians(0)
                      endAngle:PopoverViewDegreesToRadians(90)
                     clockwise:YES];
    if (!self.isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + self.arrowWH/2, currentH - self.arrowWH)];
        [maskPath addLineToPoint:arrowPoint];
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - self.arrowWH/2, currentH - self.arrowWH)];
    }
    [maskPath addLineToPoint:CGPointMake(self.cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(self.cornerRadius, maskBottom - self.cornerRadius)
                        radius:self.cornerRadius
                    startAngle:PopoverViewDegreesToRadians(90)
                      endAngle:PopoverViewDegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = 0.5;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = self.strokeColor.CGColor;
    [self.layer addSublayer:borderLayer];
    
    self.backView.alpha = 0.f;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, _isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self.backView.alpha = 1.f;
    }];
}

- (CGFloat)calculateMaxWidth {
    CGFloat maxWidth = 0.f;
    for (SLPopoverAction *action in self.actions) {
        CGFloat contentWidth = self.contentInset.left + self.contentInset.right;
        if (action.image) {
            contentWidth += self.imageSize.width + self.imageTitleSpace;
        }
        if (![NSString emptyString:action.title]) {
            contentWidth += [action.title sizeWithFont:self.titleFont size:CGSizeMake(kScreenWidth, self.itemHeight)].width;
        }
        maxWidth = MAX(maxWidth, contentWidth);
    }
    maxWidth = MIN(kScreenWidth-self.spaceHorizontal*2, maxWidth);
    return maxWidth;
}
@end
