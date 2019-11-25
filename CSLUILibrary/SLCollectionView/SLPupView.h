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
@property(copy,nonatomic)NSArray<SLPupModel *> *dataSource;
@property(weak,nonatomic)id<SLCollectionViewProtocol>delegate;
@property(nonatomic,assign,readonly) CGSize pupContentSize;
- (void)reloadData;// 瀑布流刷新
@end

NS_ASSUME_NONNULL_END
