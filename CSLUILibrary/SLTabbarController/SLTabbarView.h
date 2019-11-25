//
//  SLTabbarView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/21.
//

#import "SLView.h"

NS_ASSUME_NONNULL_BEGIN
@class SLTabbarButton;
@interface SLTabbarView : SLView
@property (nonatomic, copy) void(^clickSLTabbarIndex)(NSInteger index);

- (void)initButtons:(NSArray<SLTabbarButton *> *)buttons configTabbarButton:(void(^)(SLTabbarButton *button))configTabbarButtonBlock;
@end

NS_ASSUME_NONNULL_END
