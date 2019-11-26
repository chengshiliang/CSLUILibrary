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
- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view;
- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
@optional
- (void)collectionView:(SLCollectionView *)collectionView customDidSelectItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
@end

NS_ASSUME_NONNULL_END
