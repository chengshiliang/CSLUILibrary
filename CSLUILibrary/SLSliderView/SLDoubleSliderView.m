//
//  SLDoubleSliderView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLDoubleSliderView.h"
#import <CSLUtils/UIView+SLBase.h>
#import <CSLUtils/SLUIConsts.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>

@interface SLDoubleSliderModel : NSObject
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) float slideXY;
@property (nonatomic, strong) UIView *slideView;
@end

@implementation SLDoubleSliderModel

@end

@interface SLDoubleSliderView()
@property (nonatomic, strong) SLView *progressView;
@property (nonatomic, strong) NSMutableArray<SLDoubleSliderModel *> *slideModels;
@property (nonatomic, strong) UIImageView *normalImageView;
@property (nonatomic, strong) UIImageView *trackImageView;
@property (nonatomic, strong) UIView *trackView;
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
    self.clipsToBounds = YES;
    self.normalColor = SLUIHexColor(0xDDDEE2);
    self.trackerColor = SLUIHexColor(0x3297EF);
    self.progressCorner = YES;
    self.slideSize = CGSizeMake(30, 30);
    self.backgroundColor = [UIColor clearColor];
    self.progressWH = 10;
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
    self.maxValue = 1.0;
    self.minValue = 0;
    SLDoubleSliderModel *startModel = self.slideModels[0];
    SLDoubleSliderModel *endModel = self.slideModels[1];
    
    self.progressView = [[SLView alloc]init];
    [self addSubview:self.progressView];
    
    self.normalImageView = [[UIImageView alloc]init];
    [self addSubview:self.normalImageView];
    self.normalImageView.hidden = YES;
    
    self.trackView = [[UIView alloc]init];
    [self addSubview:self.trackView];
    self.trackView.hidden = YES;
    
    self.trackImageView = [[UIImageView alloc]init];
    [self addSubview:self.trackImageView];
    self.trackImageView.hidden = YES;
    
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        UIView *view = model.slideView;
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
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
                    slideXY = MIN(slideXY, strongSelf.maxValue*strongSelf.progressView.sl_height);
                    slideXY = MAX(slideXY, strongSelf.minValue*strongSelf.progressView.sl_height);
                    progress = slideXY * 1.0/ strongSelf.progressView.sl_height;
                } else {
                    slideXY += point.x;
                    slideXY = MIN(slideXY, strongSelf.maxValue*strongSelf.progressView.sl_width);
                    slideXY = MAX(slideXY, strongSelf.minValue*strongSelf.progressView.sl_width);
                    progress = slideXY * 1.0/ strongSelf.progressView.sl_width;
                }
                progress = MIN(1.0, MAX(0.0, progress));
                model.slideXY = slideXY;
                model.progress = progress;
                [strongSelf setStartProgress:startModel.progress endProgress:endModel.progress];
                [pan setTranslation:CGPointZero inView:strongSelf.progressView];
            }
        }];
        
        [view addGestureRecognizer:panGesture];
    }
}

- (NSArray<UIView *> *)slideViewArray {
    NSMutableArray *arraM = [NSMutableArray arrayWithCapacity:self.slideModels.count];
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        [arraM addObject:model.slideView];
    }
    return [arraM copy];
}

- (void)setMinValue:(CGFloat)minValue {
    _minValue = MIN(1, MAX(0, minValue));
    SLDoubleSliderModel *model = self.slideModels[0];
    [self setStartProgress:MAX(_minValue, model.progress) endProgress:_maxValue];
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = MIN(1, MAX(0, maxValue));
    SLDoubleSliderModel *model = self.slideModels[1];
    [self setStartProgress:_minValue endProgress:MIN(_maxValue, model.progress)];
}

- (void)setStartProgress:(CGFloat)startProgress endProgress:(CGFloat)endProgress {
    [self setNeedsLayout];
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        if (i == 0) {
            model.progress = MIN(self.maxValue, MAX(self.minValue, startProgress));
        } else {
            model.progress = MIN(self.maxValue, MAX(self.minValue, endProgress));
        }
    }
    if (self.progressChange) {
        if (startProgress > endProgress) {
            self.progressChange(endProgress, startProgress);
        } else {
            self.progressChange(startProgress, endProgress);
        }
    }
}

- (void)layoutSubviews {
    CGRect rect = self.frame;
    if (self.vertical) {
        self.progressView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.progressWH/2.0, self.slideSize.height/2.0, self.progressWH, CGRectGetHeight(rect)-self.slideSize.height);
    } else {
        self.progressView.frame = CGRectMake(self.slideSize.width/2.0, CGRectGetMidY(self.bounds)-self.progressWH/2.0, CGRectGetWidth(rect)-self.slideSize.width, self.progressWH);
    }
    
    if (self.progressCorner) {
        self.progressRadius = MIN(rect.size.width, rect.size.height) / 2.0;
    }
    self.normalImageView.hidden = YES;
    if (!self.normalImage && self.normalColor) {
        [self.progressView addCornerRadius:self.progressRadius borderWidth:0 borderColor:nil backGroundColor:self.normalColor];
    } else if (self.normalImage) {
        [self.progressView addCornerRadius:self.progressRadius borderWidth:0 borderColor:nil backGroundColor:nil];
        [self.normalImageView addCornerRadius:self.progressRadius];
        self.normalImageView.hidden = NO;
        if (self.vertical) {
            self.normalImageView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.progressWH/2.0, self.slideSize.height/2.0, self.progressWH, CGRectGetHeight(rect)-self.slideSize.height);
        } else {
            self.normalImageView.frame = CGRectMake(self.slideSize.width/2.0, CGRectGetMidY(self.bounds)-self.progressWH/2.0, CGRectGetWidth(rect)-self.slideSize.width, self.progressWH);
        }
        self.normalImageView.image = [self.normalImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    }
    self.trackImageView.hidden = YES;
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
    if (self.vertical) {
        for (int i = 0; i < self.slideModels.count; i ++) {
            SLDoubleSliderModel *model = self.slideModels[i];
            model.slideXY = model.progress * self.progressView.sl_height;
            UIView *slideView = model.slideView;
            slideView.frame = CGRectMake(CGRectGetMidX(self.bounds)-self.slideSize.width/2.0, model.progress*self.progressView.sl_height, self.slideSize.width, self.slideSize.height);
        }
    } else {
        for (int i = 0; i < self.slideModels.count; i ++) {
            SLDoubleSliderModel *model = self.slideModels[i];
            model.slideXY = model.progress * self.progressView.sl_width;
            UIView *slideView = model.slideView;
            slideView.frame = CGRectMake(model.progress*self.progressView.sl_width, CGRectGetMidY(self.bounds)-self.slideSize.height/2.0, self.slideSize.width, self.slideSize.height);
        }
    }
    self.trackView.hidden = endProgress < 0;
    if (startProgress >= 0) {
        CGRect trackRect;
        if (self.isVertical) {
            trackRect = CGRectMake(self.progressView.sl_x, self.progressView.sl_height * startProgress + self.progressView.sl_y, self.progressView.sl_width, self.progressView.sl_height * (endProgress-startProgress));
        } else {
            trackRect = CGRectMake(self.progressView.sl_width * startProgress+self.progressView.sl_x, self.progressView.sl_y, self.progressView.sl_width * (endProgress-startProgress), self.progressView.sl_height);
        }
        self.trackView.frame = trackRect;
        if (!self.trackerImage && self.trackerColor) {
            [self.trackView addCornerRadius:self.progressRadius borderWidth:0 borderColor:nil backGroundColor:self.trackerColor];
        } else if (self.trackerImage) {
            [self.trackView addCornerRadius:self.progressRadius borderWidth:0 borderColor:nil backGroundColor:nil];
            [self.trackImageView addCornerRadius:self.progressRadius];
            self.trackImageView.hidden = NO;
            self.trackImageView.frame = trackRect;
            self.trackImageView.image = [self.trackerImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < self.slideModels.count; i ++) {
        SLDoubleSliderModel *model = self.slideModels[i];
        UIView *slideView = model.slideView;
        [slideView addCornerRadius:MIN(self.slideSize.width/2.0, self.slideSize.height/2.0) borderWidth:3.0 borderColor:SLUIHexColor(0x3297EF) backGroundColor:SLUIHexColor(0xFFFFFF)];
    }
}

@end
