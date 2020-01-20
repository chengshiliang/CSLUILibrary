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
@implementation StaticCollectionModel
- (void)setStr:(NSString *)str {
    _str = str;
    self.registerName = @"StaticCollectionViewCell";
    self.type = SLCollectRowTypeXib;
}
@end
