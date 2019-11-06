//
//  SLPupView.h
//  CSLUILibrary
//  瀑布流
//  Created by SZDT00135 on 2019/11/6.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLPupModel.h>
#import <CSLUILibrary/SLCollectionView.h>
#import <CSLUILibrary/SLCollectionViewCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLPupViewDelegate <NSObject>
@required
- (void)registerCell:(SLCollectionView *)collectionView;
- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)collectionView:(SLCollectionView *)collectionView customDidSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface SLPupView : UIView
@property(assign,nonatomic) int columns;//列数 默认3列
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(copy,nonatomic)NSArray<SLPupModel *> *dataSource;
@property(weak,nonatomic)id<SLPupViewDelegate>delegate;
- (void)reloadData;// 瀑布流刷新
@end

NS_ASSUME_NONNULL_END
