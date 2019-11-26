//
//  SLNoRuleCollectionViewLayout.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/26.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLPupModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLNoRuleCollectionViewLayout : UICollectionViewLayout
@property(nonatomic,copy) NSArray<SLPupModel *> *data;
@property(assign,nonatomic) int columns;//列数 默认3列
@property(assign,nonatomic) float xlarge;//横向放大最小倍数 默认1.5倍,最小值也为1.5倍。如果宽度超过原来所占宽度的横向放大最小倍数，则放大，并占据多个cell宽度，最大为collectionview的宽度。否则按比例缩放到自身的cell中。ps: 最后一列的时候不放大。一律按照缩放处理
@property(assign,nonatomic) float ylarge;//纵向放大最小倍数 默认1.5倍,最小值也为1.5倍。如果高度超过原来所占高度的横向放大最小倍数，则放大。否则按比例缩放到自身的cell中。
@property(assign,nonatomic) float columnMagrin;//列距离
@property(assign,nonatomic) float rowMagrin;//行距离
@property(assign,nonatomic) CGSize collectViewContentSize;
@end

NS_ASSUME_NONNULL_END
