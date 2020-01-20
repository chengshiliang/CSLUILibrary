//
//  SLCollectionViewProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SLCollectionBaseView;
@class SLView;
NS_ASSUME_NONNULL_BEGIN

@protocol SLCollectionViewProtocol <NSObject>
@required
- (UICollectionViewCell *)collectionView:(SLCollectionBaseView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
@optional
- (void)registerCell:(SLCollectionBaseView *)collectionView forView:(SLView *)view;
- (void)registerHeader:(SLCollectionBaseView *)collectionView forView:(SLView *)view;
- (void)registerFooter:(SLCollectionBaseView *)collectionView forView:(SLView *)view;
- (void)collectionView:(SLCollectionBaseView *)collectionView customDidSelectItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view;
- (UICollectionReusableView *)sl_collectionView:(SLCollectionBaseView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
