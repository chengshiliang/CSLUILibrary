//
//  SLTableModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableModel.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLTableView.h>
#import <CSLUILibrary/SLTableManager.h>

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
    WeakSelf;
    return ^UITableViewCell *(SLTableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        StrongSelf;
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
@end

@implementation SLTableModel
@end
