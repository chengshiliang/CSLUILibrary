//
//  SLTabbarView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN
@class SLTabbarButton;
typedef NS_ENUM(NSInteger, SLTabbarViewDirection) {
    Horizontal,// 横向
    Vertical,// 纵向
};
@interface SLTabbarView : SLView
@property (nonatomic, copy) void(^clickSLTabbarIndex)(SLTabbarButton *button,NSInteger index);
@property (nonatomic, copy, readonly) NSArray<SLTabbarButton *> *buttons;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) SLTabbarButton *selectButton;
@property (nonatomic, assign) NSInteger index;// 指定那个tabbar选中
@property (nonatomic, assign) SLTabbarViewDirection direction;
@property (nonatomic, assign) BOOL canRepeatClick;// 可重复点击, default no
@property (nonatomic, assign) BOOL needLineView;// 是否显示线条
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineMargin;
- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void(^)(SLTabbarButton *button, NSInteger index))configTabbarButtonBlock;
@end

NS_ASSUME_NONNULL_END
