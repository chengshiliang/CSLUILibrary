//
//  SLPupView.h
//  CSLUILibrary
//  瀑布流
//  Created by SZDT00135 on 2019/11/6.
//

#import <CSLUILibrary/SLView.h>
#import <CSLUILibrary/SLCollectSectionProtocol.h>
#import <CSLUILibrary/SLCollectBaseView.h>

NS_ASSUME_NONNULL_BEGIN
@interface SLPupView : SLView
@property(strong,nonatomic)SLCollectBaseView *collectionView;
@property(assign,nonatomic) int columns;//列数 默认3列
@property (strong,nonatomic) id<SLCollectSectionProtocol> dataSource;
@property (nonatomic, copy) void(^selectCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayCollectCell)(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel);
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
