//
//  SLHorizontalCollectionView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLView.h"
#import <CSLUILibrary/SLCollectSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectBaseView;
@interface SLHorizontalCollectionView : SLView
@property (strong,nonatomic) id<SLCollectSectionProtocol> dataSource;
@property (nonatomic, copy) void(^selectCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
