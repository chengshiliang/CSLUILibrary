//
//  SLIndicatorTabbarView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLTabbarView.h"

NS_ASSUME_NONNULL_BEGIN
@class SLView;
@interface SLIndicatorTabbarView : SLTabbarView
@property (strong, nonatomic) SLView *indicatorView;
@property (nonatomic, copy) void(^configViewBlock)(SLView *indicatorView);
@end

NS_ASSUME_NONNULL_END
