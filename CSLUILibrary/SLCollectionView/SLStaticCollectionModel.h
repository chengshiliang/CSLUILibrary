//
//  SLStaticCollectionModel.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/27.
//

#import "SLModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SLPupModel;
@interface SLStaticCollectionModel : SLModel
@property (nonatomic, assign) float headerWidth;
@property (nonatomic, assign) float headerHeigth;
@property (nonatomic, assign) float footerWidth;
@property (nonatomic, assign) float footerHeigth;
@property (nonatomic, strong) SLModel<Optional> *headerData;
@property (nonatomic, strong) SLModel<Optional> *footerData;
@property (nonatomic, copy) NSArray<SLPupModel *> *datas;
@end

NS_ASSUME_NONNULL_END
