//
//  SLCollectionViewProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import <Foundation/Foundation.h>

@class SLCollectionView;
@class SLView;
NS_ASSUME_NONNULL_BEGIN

@protocol SLCollectionViewProtocol <NSObject>
@required
- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
@optional
- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view;
- (void)registerHeader:(SLCollectionView *)collectionView forView:(SLView *)view;
- (void)registerFooter:(SLCollectionView *)collectionView forView:(SLView *)view;
- (void)collectionView:(SLCollectionView *)collectionView customDidSelectItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
@end

NS_ASSUME_NONNULL_END
