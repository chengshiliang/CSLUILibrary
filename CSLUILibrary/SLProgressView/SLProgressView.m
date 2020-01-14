//
//  SLProgressView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLProgressView.h"
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLProgressView()
@property (nonatomic, strong) UIImageView *normalImageView;
@property (nonatomic, strong) UIImageView *trackImageView;
@property (nonatomic, strong) UIView *trackView;
@end

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
    self.backgroundColor = [UIColor clearColor];
    self.normalColor = SLUIHexColor(0xDDDEE2);
    self.trackerColor = SLUIHexColor(0x3297EF);
    self.corners = YES;
    
    self.normalImageView = [[UIImageView alloc]init];
    [self addSubview:self.normalImageView];
    self.normalImageView.hidden = YES;
    
    self.trackView = [[UIView alloc]init];
    [self addSubview:self.trackView];
    self.trackView.hidden = YES;
    
    self.trackImageView = [[UIImageView alloc]init];
    [self.trackView addSubview:self.trackImageView];
    self.trackImageView.hidden = YES;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    @synchronized (self) {
        progress = MIN(1.0, progress);
        progress = MAX(0.0, progress);
        if (animated && progress > 0) {
            while (self.progress != progress) {
                [UIView animateWithDuration:0.05 animations:^{
                    if (ABS(self.progress - progress) < 0.1) {
                        self.progress = progress;
                    }
                    if (self.progress > progress) {
                        self.progress -= 0.1;
                    } else if (self.progress < progress) {
                        self.progress += 0.1;
                    }
                    [self setNeedsLayout];
                }];
            }
        } else {
            self.progress = progress;
            [self setNeedsLayout];
        }
    }
}

- (void)layoutSubviews {
    CGRect rect = self.frame;
    if (self.corners) {
        self.radius = MIN(rect.size.width, rect.size.height) / 2.0;
    }
    self.normalImageView.hidden = YES;
    if (!self.normalImage && self.normalColor) {
        [self addCornerRadius:self.radius borderWidth:0 borderColor:nil backGroundColor:self.normalColor];
    } else if (self.normalImage) {
        [self addCornerRadius:self.radius borderWidth:0 borderColor:nil backGroundColor:nil];
        [self.normalImageView addCornerRadius:self.radius];
        self.normalImageView.hidden = NO;
        self.normalImageView.frame = self.bounds;
        self.normalImageView.image = [self.normalImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    }
    self.trackImageView.hidden = YES;
    self.trackView.hidden = self.progress <= 0;
    if (self.progress > 0) {
        CGRect trackRect;
        if (self.isVertical) {
            trackRect = CGRectMake(0, 0, rect.size.width, rect.size.height * self.progress);
        } else {
            trackRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
        }
        self.trackView.frame = trackRect;
        if (!self.trackerImage && self.trackerColor) {
            [self.trackView addCornerRadius:self.radius borderWidth:0 borderColor:nil backGroundColor:self.trackerColor];
        } else if (self.trackerImage) {
            [self.trackView addCornerRadius:self.radius borderWidth:0 borderColor:nil backGroundColor:nil];
            [self.trackImageView addCornerRadius:self.radius];
            self.trackImageView.hidden = NO;
            self.trackImageView.frame = trackRect;
            self.trackImageView.image = [self.trackerImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        }
    }
}
@end
