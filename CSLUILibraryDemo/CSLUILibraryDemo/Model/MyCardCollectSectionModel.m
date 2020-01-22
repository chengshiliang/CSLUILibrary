//
//  MyCardCollectSectionModel.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/20.
//  Copyright © 2020 csl. All rights reserved.
//

#import "MyCardCollectSectionModel.h"

@implementation MyCardCollectSectionModel
- (UIEdgeInsets)insetForSection {
    return UIEdgeInsetsMake(kScreenWidth * 0.3, kScreenWidth * 0.2, kScreenWidth * 0.3, kScreenWidth * 0.2);
}
@end
@implementation MyPupCollectSectionModel
- (UIEdgeInsets)insetForSection {
    return UIEdgeInsetsMake(40, 20, 40, 20);
}
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation StaticCollectionModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectTypeXib;
}
@end
@implementation MyPupCollectRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.registerName = @"MyPupCollectionViewCell";
        self.type = SLCollectTypeCode;
    }
    return self;
}
@end
@implementation MyStaticCollectSectionModel
- (UIEdgeInsets)insetForSection {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation MyStaticCollectRowModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectTypeXib;
}
@end
@implementation MyNoRuleCollectSectionModel
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation MyNoRuleCollectRowModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectTypeXib;
}
@end
@implementation MyRecycleSectionModel
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation MyRecycleRowModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectTypeXib;
}
@end
@implementation MyTableRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.reuseIdentifier = @"MyTableRowCell";
        self.rowHeight = 44.0;
        self.estimatedHeight = 44.0;
        self.type = SLTableTypeCode;
        self.registerName = @"UITableViewCell";
    }
    return self;
}
@end
@implementation MyTableSectionModel
- (instancetype)init {
    if (self == [super init]) {
        self.titleForHeader = @"";
        self.titleForFooter = @"";
        self.heightForHeader = 30.0;
        self.estimatedHeightForHeader = 30.0;
        self.heightForFooter = 0;
        self.estimatedHeightForFooter = 0;
        self.sectionIndexTitle = @"";
        self.viewForHeader = ^UIView * _Nullable(UITableView * _Nullable tableView, NSInteger section) {
            return nil;
        };
        self.viewForFooter = ^UIView * _Nullable(UITableView * _Nullable tableView, NSInteger section) {
            return nil;
        };
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleForHeader = title;
}
@end
@implementation MyCollectRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.reuseIdentifier = @"MyCollectRowCell";
        self.rowHeight = 40;
        self.rowWidth = 100;
        self.type = SLTableTypeCode;
        self.registerName = @"UICollectionViewCell";
    }
    return self;
}
@end
@implementation RuixingCoffeeSectionModel
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation RuixingCoffeeRowModel

@end
@implementation DropDownSectionModel
- (UIEdgeInsets)insetForSection {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)minimumLineSpacing {
    return 5;
}
- (CGFloat)minimumInteritemSpacing {
    return 5;
}
@end
@implementation DropDownRowModel

@end
@implementation DropDownTableSectionModel

@end
@implementation DropDownTableRowModel

@end
