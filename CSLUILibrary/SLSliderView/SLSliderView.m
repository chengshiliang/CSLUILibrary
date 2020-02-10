//
//  SLSliderView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLSliderView.h"
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>

@interface SLSliderView()
@property (nonatomic, strong) SLProgressView *progressView;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat slideXY;
@end

@implementation SLSliderView

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
    self.slideXY = 0.0;
    self.minValue = 0.0;
    self.maxValue = 1.0;
    self.slideSize = CGSizeMake(30, 30);
    self.backgroundColor = [UIColor clearColor];
    self.progressWH = 10;
    self.progressView = [[SLProgressView alloc]init];
    [self addSubview:self.progressView];
    
    self.slideView = [[UIView alloc]init];
    [self addSubview:self.slideView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    WeakSelf;
    [panGesture on:self click:^(UIGestureRecognizer *gesture) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            StrongSelf;
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
            CGPoint point = [pan translationInView:strongSelf.progressView];
            if (strongSelf.isVertical) {
                strongSelf.slideXY += point.y;
                strongSelf.slideXY = MIN(strongSelf.slideXY, strongSelf.maxValue*strongSelf.progressView.sl_height);
                strongSelf.slideXY = MAX(strongSelf.slideXY, strongSelf.minValue*strongSelf.progressView.sl_height);
            } else {
                strongSelf.slideXY += point.x;
                strongSelf.slideXY = MIN(strongSelf.slideXY, strongSelf.maxValue*strongSelf.progressView.sl_width);
                strongSelf.slideXY = MAX(strongSelf.slideXY, strongSelf.minValue*strongSelf.progressView.sl_width);
            }
            CGFloat progress;
            if (strongSelf.isVertical) {
                progress = strongSelf.slideXY * 1.0/strongSelf.progressView.sl_height;
            } else {
                progress = strongSelf.slideXY * 1.0/strongSelf.progressView.sl_width;
            }
            [strongSelf setProgress:progress animated:YES];
            [pan setTranslation:CGPointZero inView:strongSelf.progressView];
        }
    }];
    
    [self addGestureRecognizer:panGesture];
}

- (void)layoutSubviews {
    CGRect rect = self.frame;
    if (self.isVertical) {
        self.progressView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.progressWH/2.0, self.slideSize.height/2.0, self.progressWH, CGRectGetHeight(rect)-self.slideSize.height);
        self.slideView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.slideSize.width/2.0, self.progress*self.progressView.sl_height, self.slideSize.width, self.slideSize.height);
        self.slideXY = MIN(self.maxValue, MAX(self.minValue, self.progress))*self.progressView.sl_height;
    } else {
        self.progressView.frame = CGRectMake(self.slideSize.width/2.0 , CGRectGetMidY(self.bounds)-self.progressWH/2.0, CGRectGetWidth(rect)-self.slideSize.width, self.progressWH);
        self.slideView.frame = CGRectMake(self.progress*self.progressView.sl_width, CGRectGetMidY(self.bounds)-self.slideSize.height/2.0, self.slideSize.width, self.slideSize.height);
        self.slideXY = MIN(self.maxValue, MAX(self.minValue, self.progress))*self.progressView.sl_width;
    }
}

- (void)setMinValue:(CGFloat)minValue {
    _minValue = MIN(1, MAX(0, minValue));
    [self setProgress:MAX(_minValue, self.progress) animated:NO];
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = MIN(1, MAX(0, maxValue));
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    self.progressView.vertical = vertical;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = MIN(self.maxValue, MAX(self.minValue, progress));
    self.progress = progress;
    [self setNeedsLayout];
    [self.progressView setProgress:progress animated:animated];
    if (self.progressChange) self.progressChange(progress);
}

- (void)drawRect:(CGRect)rect {
    [self.slideView addCornerRadius:MIN(self.slideSize.width/2.0, self.slideSize.height/2.0) borderWidth:3.0 borderColor:SLUIHexColor(0x3297EF) backGroundColor:SLUIHexColor(0xFFFFFF)];
}
@end
