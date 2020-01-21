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
    self.type = SLCollectRowTypeXib;
}
@end
@implementation MyPupCollectRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.registerName = @"MyPupCollectionViewCell";
        self.type = SLCollectRowTypeCode;
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
    self.type = SLCollectRowTypeXib;
}
@end
@implementation MyNoRuleCollectSectionModel
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
@implementation MyNoRuleCollectRowModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectRowTypeXib;
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
    self.type = SLCollectRowTypeXib;
}
@end
