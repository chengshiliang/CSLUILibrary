//
//  SLTableModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableModel.h"

@implementation SLTableRowModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowHeight = 44.0;
        self.reuseIdentifier = NSStringFromClass([self class]);
        self.type = SLTableRowTypeCode;
        self.registerName = NSStringFromClass([UITableViewCell class]);
    }
    return self;
}

- (CellForRow)cellForRowBlock{
    __weak typeof(self) weakSelf = self;
    return ^UITableViewCell *(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strongSelf.reuseIdentifier];
        if (cell) {
        }else{
            switch (strongSelf.type) {
                case SLTableRowTypeCode:{
                    [tableView registerClass:NSClassFromString(strongSelf.registerName) forCellReuseIdentifier:strongSelf.reuseIdentifier];
                }
                    break;
                case SLTableRowTypeXib:{
                    UINib *nib = [UINib nibWithNibName:strongSelf.registerName bundle:nil];
                    [tableView registerNib:nib forCellReuseIdentifier:strongSelf.reuseIdentifier];
                }
                    break;
                default:
                    break;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:strongSelf.reuseIdentifier];
        }
        return cell;
    };
}
@end

@implementation SLTableSectionModel

- (CGFloat)heightForHeader{
    return 0.0001;
}

- (CGFloat)estimatedHeightForHeader{
    return 0.0001;
}

//Footer
- (CGFloat)heightForFooter{
    return 0.0001;
}

- (CGFloat)estimatedHeightForFooter{
    return 0.0001;
}

@end

@implementation SLTableModel
- (float)tableHeaderHeight {
    if (_tableHeaderHeight == 0) {
        return 0.0001;
    }
    return _tableHeaderHeight;
}
- (float)tableFooterHeight {
    if (_tableFooterHeight == 0) {
        return 0.0001;
    }
    return _tableFooterHeight;
}
@end
