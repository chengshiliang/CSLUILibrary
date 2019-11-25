//
//  SLStaticCollectViewLayout.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLStaticCollectViewLayout : UICollectionViewLayout
@property(assign,nonatomic) int columns;//列数 默认1列
@property(assign,nonatomic) int count; // 总数
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@end

NS_ASSUME_NONNULL_END
