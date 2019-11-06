//
//  SLPupModel.h
//  CSLUILibrary
// 瀑布流的数据模型
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLPupModel : SLModel
@property (nonatomic) float width;
@property (nonatomic) float height;// 瀑布流item的宽度和高度
@property (nonatomic) SLModel *data;
@end

NS_ASSUME_NONNULL_END
