//
//  SLTabbarView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "SLView.h"
#import <CSLUILibrary/SLUIConst.h>

NS_ASSUME_NONNULL_BEGIN
@class SLTabbarButton;
@interface SLTabbarView : SLView
@property (nonatomic, copy) void(^clickSLTabbarIndex)(SLTabbarButton *button,NSInteger index);
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly) SLTabbarButton *selectButton;
@property (nonatomic, assign) NSInteger index;// 指定那个tabbar选中
@property (nonatomic, assign) SLViewDirection direction;
@property (nonatomic, assign) BOOL canRepeatClick;// 可重复点击, default no
- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void(^)(SLTabbarButton *button, NSInteger index))configTabbarButtonBlock;
@end

NS_ASSUME_NONNULL_END
