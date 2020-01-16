//
//  SLSliderView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLView.h"
#import <CSLUILibrary/SLProgressView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLSliderView : SLView
@property (nonatomic, readonly, strong) SLProgressView *progressView;
@property (nonatomic, assign) CGFloat progressWH;
@property (nonatomic, assign) CGSize slideSize;// 决定滑动指示器的大小
@property (nonatomic, strong) UIView *slideView;// 滑动的自定义视图。
@property (nonatomic, copy) void(^progressChange)(CGFloat progress);
@property (nonatomic, assign, getter=isVertical) BOOL vertical;// 是否为纵向显示
@property (nonatomic, assign) CGFloat minValue;// 最小值，默认为0
@property (nonatomic, assign) CGFloat maxValue;// 最大值，默认为1
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
