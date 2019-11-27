//
//  SLCollectionViewLayout.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SLPupModel;
@interface SLCollectionViewLayout : UICollectionViewLayout
@property(assign,nonatomic) int columns;//列数 默认3列
@property(copy,nonatomic) NSArray<SLPupModel *> *data;
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@end

NS_ASSUME_NONNULL_END
