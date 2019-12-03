//
//  SLTableModel.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SLRowTableModel <NSObject>
@end

@interface SLRowTableModel : SLModel
@property (nonatomic, assign) float tableRowHeight;
@property (nonatomic, strong) id<Optional> tableRowData;
@end

@protocol SLTableModel <NSObject>
@end

@interface SLTableModel : SLModel
@property (nonatomic, assign) float tableHeaderHeight;
@property (nonatomic, assign) float tableFooterHeight;
@property (nonatomic, copy) NSArray<SLRowTableModel *> *rowDataSource;
@property (nonatomic, strong) id<Optional> tableHeaderData;
@property (nonatomic, strong) id<Optional> tableFooterData;
@end

NS_ASSUME_NONNULL_END
