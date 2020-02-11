//
//  SLDoubleSliderView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/17.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLDoubleSliderView : SLView
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *trackerColor;
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *trackerImage;
@property (nonatomic, assign) CGFloat progressRadius;// 进度条倒角
@property (nonatomic, assign) BOOL progressCorner;// 进度条是否倒圆角
@property (nonatomic, assign) CGFloat progressWH;
@property (nonatomic, assign) CGSize slideSize;// 决定滑动指示器的大小
@property (nonatomic, copy) NSArray<UIView *> *slideViewArray;// 两侧滑块视图
@property (nonatomic, copy) void(^progressChange)(CGFloat startProgress,CGFloat endProgress);
@property (nonatomic, assign, getter=isVertical) BOOL vertical;// 是否为纵向显示
@property (nonatomic, assign) CGFloat minValue;// 最小值，默认为0
@property (nonatomic, assign) CGFloat maxValue;// 最大值，默认为1
- (void)setStartProgress:(CGFloat)startProgress endProgress:(CGFloat)endProgress;
@end

NS_ASSUME_NONNULL_END
