//
//  SLDoubleSliderView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLDoubleSliderView.h"
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <Masonry/Masonry.h>

@interface SLDoubleSliderModel : NSObject
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float slideXY;
@property (nonatomic, strong) UIView *slideView;
@end

@implementation SLDoubleSliderModel

@end

@interface SLDoubleSliderView()
{
    BOOL layout;
}
@property (nonatomic, strong) SLView *progressView;
@property (nonatomic, strong) NSMutableArray<SLDoubleSliderModel *> *slideModels;
@end

@implementation SLDoubleSliderView

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
    self.progressCorner = YES;
    self.slideModels = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        SLDoubleSliderModel *model = [[SLDoubleSliderModel alloc]init];
        if (i == 0) {
            model.progress = 0.0;
        } else {
            model.progress = 1.0;
        }
        model.slideXY = 0.0;
        model.slideView = [[UIView alloc]init];
        [self.slideModels addObject:model];
    }
    SLDoubleSliderModel *startModel = self.slideModels[0];
    SLDoubleSliderModel *endModel = self.slideModels[1];
    self.slideSize = CGSizeMake(30, 30);
    self.backgroundColor = [UIColor clearColor];
    self.progressWH = 10;
    self.progressView = [[SLView alloc]init];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(self.slideSize.width/2.0);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.progressWH);
        make.right.mas_equalTo(self).offset(-self.slideSize.width/2.0);
    }];
    
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        UIView *view = model.slideView;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(self).offset(0);
            } else {
                make.right.mas_equalTo(self).offset(0);
            }
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.slideSize.height);
            make.width.mas_equalTo(self.slideSize.width);
        }];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
        WeakSelf;
        [panGesture on:self click:^(UIGestureRecognizer *gesture) {
            if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
                StrongSelf;
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
                CGPoint point = [pan translationInView:strongSelf.progressView];
                CGFloat slideXY = model.slideXY;
                CGFloat progress = model.progress;
                if (strongSelf.isVertical) {
                    slideXY += point.y;
                    if (i == 0) {
                        progress = slideXY * 1.0/ strongSelf.progressView.sl_height;
                    } else {
                        progress = 1.0 + slideXY * 1.0/ strongSelf.progressView.sl_height;
                    }
                } else {
                    slideXY += point.x;
                    if (i == 0) {
                        progress = slideXY * 1.0/ strongSelf.progressView.sl_width;
                    } else {
                        progress = 1.0 + slideXY * 1.0/ strongSelf.progressView.sl_width;
                    }
                }
                progress = MIN(1.0, progress);
                progress = MAX(0.0, progress);
                model.slideXY = slideXY;
                model.progress = progress;
                [strongSelf setStartProgress:startModel.progress endProgress:endModel.progress animated:YES];
                [pan setTranslation:CGPointZero inView:strongSelf.progressView];
            }
        }];
        
        [view addGestureRecognizer:panGesture];
    }
    [self setStartProgress:startModel.progress endProgress:endModel.progress animated:NO];
}

- (NSArray<UIView *> *)slideViewArray {
    NSMutableArray *arraM = [NSMutableArray arrayWithCapacity:self.slideModels.count];
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        [arraM addObject:model.slideView];
    }
    return [arraM copy];
}

- (void)setSlideSize:(CGSize)slideSize {
    _slideSize = slideSize;
    for (UIView *slideView in self.slideViewArray) {
        [slideView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(slideSize.height);
            make.width.mas_equalTo(slideSize.width);
        }];
    }
    if (self.isVertical) {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(slideSize.height/2.0);
            make.bottom.mas_equalTo(self).offset(-slideSize.height/2.0);
        }];
    } else {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(slideSize.width/2.0);
            make.right.mas_equalTo(self).offset(-slideSize.width/2.0);
        }];
    }
}

- (void)setProgressWH:(CGFloat)progressWH {
    _progressWH = progressWH;
    if (self.isVertical) {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(progressWH);
        }];
    } else {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(progressWH);
        }];
    }
}

- (void)setStartProgress:(CGFloat)startProgress endProgress:(CGFloat)endProgress animated:(BOOL)animated {
    if (self.isVertical) {
        for (int i = 0; i < self.slideViewArray.count; i ++) {
            UIView *slideView = self.slideViewArray[i];
            [slideView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(self).offset(startProgress*self.progressView.sl_height);
                } else {
                    make.bottom.mas_equalTo(self).offset(-(1-endProgress)*self.progressView.sl_height);
                }
            }];
        }
    } else {
        for (int i = 0; i < self.slideViewArray.count; i ++) {
            UIView *slideView = self.slideViewArray[i];
            [slideView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.mas_equalTo(self).offset(startProgress*self.progressView.sl_width);
                } else {
                    make.right.mas_equalTo(self).offset(-(1-endProgress)*self.progressView.sl_width);
                }
            }];
        }
    }
    [self setNeedsDisplay];
    if (self.progressChange) {
        if (startProgress > endProgress) {
            self.progressChange(endProgress, startProgress);
        } else {
            self.progressChange(startProgress, endProgress);
        }
    }
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    if (vertical) {
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self.progressWH);
            make.top.mas_equalTo(self).offset(self.slideSize.height/2.0);
            make.bottom.mas_equalTo(self).offset(-self.slideSize.height/2.0);
        }];
        for (int i = 0; i < self.slideViewArray.count; i ++) {
            UIView *slideView = self.slideViewArray[i];
            [slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(self).offset(0);
                } else {
                    make.bottom.mas_equalTo(self).offset(0);
                }
                make.centerX.mas_equalTo(self);
                make.height.mas_equalTo(self.slideSize.height);
                make.width.mas_equalTo(self.slideSize.width);
            }];
        }
    } else {
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.progressWH);
            make.left.mas_equalTo(self).offset(self.slideSize.width/2.0);
            make.right.mas_equalTo(self).offset(-self.slideSize.width/2.0);
        }];
        for (int i = 0; i < self.slideViewArray.count; i ++) {
            UIView *slideView = self.slideViewArray[i];
            [slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.mas_equalTo(self).offset(0);
                } else {
                    make.right.mas_equalTo(self).offset(0);
                }
                make.centerY.mas_equalTo(self);
                make.height.mas_equalTo(self.slideSize.height);
                make.width.mas_equalTo(self.slideSize.width);
            }];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    if (!layout) {
        layout = YES;
        for (UIView *slideView in self.slideViewArray) {
            [slideView addCornerRadius:MIN(self.slideSize.width/2.0, self.slideSize.height/2.0) borderWidth:3.0 borderColor:SLUIHexColor(0x3297EF) backGroundColor:SLUIHexColor(0xFFFFFF)];
        }
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.normalImage) {
        CGContextSetFillColorWithColor(context, [[UIColor colorWithPatternImage:self.normalImage] CGColor]);
    } else if (self.normalColor) {
        CGContextSetFillColorWithColor(context, self.normalColor.CGColor);
    }
    UIBezierPath *bezierPath;
    if (self.progressCorner) {
        self.progressRadius = MIN(self.progressView.sl_width, self.progressView.sl_height) / 2.0;
    }
    if (self.progressRadius > 0) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.progressView.frame cornerRadius:self.progressRadius];
    } else {
        bezierPath = [UIBezierPath bezierPathWithRect:self.progressView.frame];
    }
    
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGFloat startProgress = 1.0;
    CGFloat endProgress = 0;
    for (SLDoubleSliderModel *model in self.slideModels) {
        if (startProgress > [model progress]) {
            startProgress = [model progress];
        }
        if (endProgress < [model progress]) {
            endProgress = [model progress];
        }
    }
    if (endProgress > 0) {
        CGRect trackRect;
        if (self.isVertical) {
            trackRect = CGRectMake(self.progressView.sl_x, self.progressView.sl_height * startProgress + self.progressView.sl_y, self.progressView.sl_width, self.progressView.sl_height * (endProgress-startProgress));
        } else {
            trackRect = CGRectMake(self.progressView.sl_width * startProgress+self.progressView.sl_x, self.progressView.sl_y, self.progressView.sl_width * (endProgress-startProgress), self.progressView.sl_height);
        }
        if (self.progressRadius > 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:trackRect cornerRadius:self.progressRadius];
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
