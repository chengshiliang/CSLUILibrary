//
//  SLTableModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableModel.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLTableView.h>
#import <CSLUILibrary/SLTableManager.h>

@implementation SLTableRowModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowHeight = 44.0;
        self.reuseIdentifier = NSStringFromClass([self class]);
        self.type = SLTableTypeCode;
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
                case SLTableTypeCode:{
                    [tableView registerClass:NSClassFromString(strongSelf.registerName) forCellReuseIdentifier:strongSelf.reuseIdentifier];
                }
                    break;
                case SLTableTypeXib:{
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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerType = SLTableTypeCode;
        self.footerType = SLTableTypeCode;
        self.headerRegisterName = NSStringFromClass([UITableViewHeaderFooterView class]);
        self.footerRegisterName = NSStringFromClass([UITableViewHeaderFooterView class]);
    }
    return self;
}
- (HeaderFooter)viewForHeader{
    WeakSelf;
    return ^UIView * _Nullable(UITableView *_Nullable tableView, NSInteger section) {
        StrongSelf;
        if ([NSString emptyString:strongSelf.headerReuseIdentifier]) return nil;
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:strongSelf.headerReuseIdentifier];
        if (view) {
        }else{
            switch (strongSelf.headerType) {
                case SLTableTypeCode:{
                    [tableView registerClass:NSClassFromString(strongSelf.headerRegisterName) forHeaderFooterViewReuseIdentifier:strongSelf.headerReuseIdentifier];
                }
                    break;
                case SLTableTypeXib:{
                    UINib *nib = [UINib nibWithNibName:strongSelf.headerRegisterName bundle:nil];
                    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:strongSelf.headerReuseIdentifier];
                }
                    break;
                default:
                    break;
            }
            view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:strongSelf.headerReuseIdentifier];
        }
        return view;
    };
}
- (HeaderFooter)viewForFooter{
    WeakSelf;
    return ^UIView * _Nullable(UITableView *_Nullable tableView, NSInteger section) {
        StrongSelf;
        if ([NSString emptyString:strongSelf.footerReuseIdentifier]) return nil;
        UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:strongSelf.footerReuseIdentifier];
        if (view) {
        }else{
            switch (strongSelf.footerType) {
                case SLTableTypeCode:{
                    [tableView registerClass:NSClassFromString(strongSelf.footerRegisterName) forHeaderFooterViewReuseIdentifier:strongSelf.footerReuseIdentifier];
                }
                    break;
                case SLTableTypeXib:{
                    UINib *nib = [UINib nibWithNibName:strongSelf.footerRegisterName bundle:nil];
                    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:strongSelf.footerReuseIdentifier];
                }
                    break;
                default:
                    break;
            }
            view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:strongSelf.footerReuseIdentifier];
        }
        return view;
    };
}
@end

@implementation SLTableModel
@end
