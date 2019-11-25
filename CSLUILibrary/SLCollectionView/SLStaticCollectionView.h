//
//  SLStaticCollectionView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLView.h"
#import <CSLUILibrary/SLModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *宽高由外部给定。内部根据columns、dataSource.count计算cell的frame
 */
@interface SLStaticCollectionView : SLView
@property(assign,nonatomic) int columns;//列数 默认1列
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(copy,nonatomic)NSArray<SLModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
- (void)reloadData;// 静态collectionview刷新
@end

NS_ASSUME_NONNULL_END
