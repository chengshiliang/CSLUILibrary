//
//  SLHorizontalCollectionViewLayout.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLPupModel.h>

NS_ASSUME_NONNULL_BEGIN
@class SLHorizontalCollectionViewLayout;
@protocol SLHorizontalCollectionViewLayoutDelegate<NSObject>
-(CGSize)itemSizeWithLayout:(SLHorizontalCollectionViewLayout *)layout indexPath:(NSIndexPath *)indexPath;
@end

@interface SLHorizontalCollectionViewLayout : UICollectionViewLayout
@property(weak,nonatomic) id<SLHorizontalCollectionViewLayoutDelegate>delegate;
@property(copy,nonatomic) NSArray<SLPupModel *> *data; // item宽度
@property(assign,nonatomic) float columnMagrin;//列距离
@end

NS_ASSUME_NONNULL_END
