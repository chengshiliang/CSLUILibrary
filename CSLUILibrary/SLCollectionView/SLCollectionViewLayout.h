//
//  SLCollectionViewLayout.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectionViewLayout;
@protocol SLCollectionViewLayoutDelegate<NSObject>
-(CGFloat)layout:(SLCollectionViewLayout *)layout heightWithWidth:(float)width indexPath:(NSIndexPath *)indexPath;
@end

@interface SLCollectionViewLayout : UICollectionViewLayout
@property(weak,nonatomic) id<SLCollectionViewLayoutDelegate>delegate;
@property(assign,nonatomic) int columns;//列数 默认3列
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(assign,nonatomic) CGSize collectViewContentSize;
@end

NS_ASSUME_NONNULL_END
