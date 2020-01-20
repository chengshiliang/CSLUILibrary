//
//  SLCardCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLView.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>
#import <CSLUILibrary/SLUIConst.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectBaseView;
@interface SLCardCollectionView : SLView
@property (strong,nonatomic) id<SLCollectSectionProtocol> dataSource;
@property (nonatomic,assign) SLViewDirection direction; //滚动方向
@property (nonatomic,  copy) void(^scrollEndBlock)(NSInteger index); // 滚动结束，当前显示中间的cell序号
- (void)reloadData;// collectionview刷新
@end

NS_ASSUME_NONNULL_END