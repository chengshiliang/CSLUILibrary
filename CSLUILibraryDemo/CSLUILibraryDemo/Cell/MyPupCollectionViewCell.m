//
//  MyPupCollectionViewCell.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/20.
//  Copyright © 2020 csl. All rights reserved.
//

#import "MyPupCollectionViewCell.h"
#import "MyCardCollectSectionModel.h"

@implementation MyPupCollectionViewCell
- (void)renderWithRowModel:(id<SLCollectRowProtocol>)row {
    if ([row isKindOfClass:[MyPupCollectRowModel class]]) {
        MyPupCollectRowModel *model = (MyPupCollectRowModel *)row;
        self.backgroundColor = model.color;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
