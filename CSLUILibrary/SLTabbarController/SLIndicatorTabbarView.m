//
//  SLIndicatorTabbarView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLIndicatorTabbarView.h"
#import <CSLUILibrary/SLView.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLTabbarButton.h>

@interface SLIndicatorTabbarView()

@end

@implementation SLIndicatorTabbarView

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
    self.indicatorView = [[SLView alloc]init];
    self.indicatorView.backgroundColor = SLUIHexColor(0xff0000);
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    SLTabbarButton *button = self.allButtons[self.currentIndex];
    CGFloat offsetX = button.frame.origin.x;
    self.indicatorView.frame = CGRectMake(0, self.frame.size.height-2, button.frame.size.width, 2);
    if (self.configViewBlock) self.configViewBlock(self.indicatorView);
    self.indicatorView.transform = CGAffineTransformMakeTranslation(offsetX, 0);
}

@end
