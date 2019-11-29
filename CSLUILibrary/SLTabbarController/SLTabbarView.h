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
@property (nonatomic, copy) void(^clickSLTabbarIndex)(NSInteger index);
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign) SLViewDirection direction;
- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void(^)(SLTabbarButton *button))configTabbarButtonBlock;
@end

NS_ASSUME_NONNULL_END
