//
//  SLHorizontalCollectionView.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLView.h"
#import <CSLUILibrary/SLPupModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLHorizontalCollectionView : SLView
@property(nonatomic,assign) BOOL bounces;
@property(assign,nonatomic) int columns;//列数
@property(assign,nonatomic) float columnMagrin;//列距离
@property(nonatomic,assign) UIEdgeInsets insets;// collectionView的内边距
@property(copy,nonatomic)NSArray<SLPupModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
- (void)reloadData;// 横向滚动collectionview刷新
@end

NS_ASSUME_NONNULL_END
