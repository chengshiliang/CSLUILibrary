//
//  SLTableModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableModel.h"

@implementation SLRowTableModel
- (float)tableRowHeight {
    if (_tableRowHeight == 0.0) {
        return 44.0;
    }
    return _tableRowHeight;
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
