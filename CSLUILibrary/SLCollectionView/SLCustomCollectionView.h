//
//  SLCustomCollectionView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/27.
//

#import "SLView.h"
#import <CSLUILibrary/SLCustomCollectionModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLCustomCollectionView : SLView
@property(strong,nonatomic)SLCollectionView *collectionView;
@property(assign,nonatomic) int columns;//列数 默认1列
@property(nonatomic,assign) UIEdgeInsets insets;// collectionView的内边距
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(copy,nonatomic)NSArray<SLCustomCollectionModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
- (void)reloadData;// 静态collectionview刷新
@end

NS_ASSUME_NONNULL_END
