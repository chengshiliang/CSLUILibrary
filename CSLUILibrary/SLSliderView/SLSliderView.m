//
//  SLSliderView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLSliderView.h"
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <Masonry/Masonry.h>

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
    [self setProgress:0 animated:YES];
    self.slideSize = CGSizeMake(30, 30);
    self.backgroundColor = [UIColor clearColor];
    self.progressWH = 10;
    self.progressView = [[SLProgressView alloc]init];
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(self.slideSize.width/2.0);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.progressWH);
        make.right.mas_equalTo(self).offset(-self.slideSize.width/2.0);
    }];
    
    self.slideView = [[UIView alloc]init];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]init];
    WeakSelf;
    [panGesture on:self click:^(UIGestureRecognizer *gesture) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            StrongSelf;
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gesture;
            CGPoint point = [pan translationInView:strongSelf.progressView];
            if (strongSelf.isVertical) {
                strongSelf.slideXY += point.y;
                strongSelf.slideXY = MIN(strongSelf.slideXY, strongSelf.progressView.sl_height);
                strongSelf.slideXY = MAX(strongSelf.slideXY, 0);
            } else {
                strongSelf.slideXY += point.x;
                strongSelf.slideXY = MIN(strongSelf.slideXY, strongSelf.progressView.sl_width);
                strongSelf.slideXY = MAX(strongSelf.slideXY, 0);
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

- (void)setSlideView:(UIView *)slideView {
    _slideView = slideView;
    [self addSubview:self.slideView];
    [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(0);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(self.slideSize.height);
        make.width.mas_equalTo(self.slideSize.width);
    }];
}

- (void)setSlideSize:(CGSize)slideSize {
    _slideSize = slideSize;
    [self.slideView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(slideSize.height);
        make.width.mas_equalTo(slideSize.width);
    }];
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

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.progressView setProgress:progress animated:animated];
    if (self.isVertical) {
        [self.slideView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(progress*self.progressView.sl_height);
        }];
    } else {
        [self.slideView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(progress*self.progressView.sl_width);
        }];
    }
    if (self.progressChange) self.progressChange(progress);
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    self.progressView.vertical = vertical;
    if (vertical) {
        [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self.progressWH);
            make.top.mas_equalTo(self).offset(self.slideSize.height/2.0);
            make.bottom.mas_equalTo(self).offset(-self.slideSize.height/2.0);
        }];
        [self.slideView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(0);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(self.slideSize.height);
            make.width.mas_equalTo(self.slideSize.width);
        }];
    } else {
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(self.slideSize.width/2.0);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.progressWH);
            make.right.mas_equalTo(self).offset(-self.slideSize.width/2.0);
        }];
        [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(0);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(self.slideSize.height);
            make.width.mas_equalTo(self.slideSize.width);
        }];
    }
}

- (void)drawRect:(CGRect)rect {
    [self.slideView addCornerRadius:MIN(self.slideSize.width/2.0, self.slideSize.height/2.0) borderWidth:3.0 borderColor:SLUIHexColor(0x3297EF) backGroundColor:SLUIHexColor(0xFFFFFF)];
}
@end
