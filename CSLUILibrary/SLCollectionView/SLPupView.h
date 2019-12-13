//
//  SLPupView.h
//  CSLUILibrary
//  瀑布流
//  Created by SZDT00135 on 2019/11/6.
//

#import <CSLUILibrary/SLView.h>
#import <CSLUILibrary/SLPupModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/SLCollectionViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPupView : SLView
@property(assign,nonatomic) int columns;//列数 默认3列
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(nonatomic,assign) UIEdgeInsets insets;// collectionView的内边距
@property(copy,nonatomic)NSArray<SLPupModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
@property(strong,nonatomic)SLCollectionView *collectionView;
@property(nonatomic,assign) BOOL isRegiste;// 如果在外面已经注册好，这里记得改为yes
- (void)reloadData;// 瀑布流刷新
@end

NS_ASSUME_NONNULL_END
