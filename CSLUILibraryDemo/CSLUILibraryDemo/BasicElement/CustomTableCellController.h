//
//  CustomTableCellController.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/3.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SLViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface CustomTableRowModel : SLTableRowModel
@property (nonatomic, strong) SLTableCellModel *tableRowData;
@end
@interface CustomTableCellModel : SLTableCellModel

@end
@interface CustomTableView : SLTableView

@end
@interface CustomTableCellController : SLViewController

@end

NS_ASSUME_NONNULL_END
