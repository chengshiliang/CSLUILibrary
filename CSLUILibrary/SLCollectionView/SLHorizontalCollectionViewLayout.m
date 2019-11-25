//
//  SLHorizontalCollectionViewLayout.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLHorizontalCollectionViewLayout.h"

@interface SLHorizontalCollectionViewLayout()
{
    CGFloat currentX;
}
@property(strong, nonatomic)NSMutableArray *layoutAttributeArray;
@end

@implementation SLHorizontalCollectionViewLayout
- (instancetype)init {
    if (self == [super init]) {
        self.layoutAttributeArray = [NSMutableArray array];
    }
    return self;
}

//系统在开始计算每一个cell之前调用,做一些初始化工作
- (void)prepareLayout {
    if (self.data.count == 0) return;
    [self.layoutAttributeArray removeAllObjects];
    currentX = 0.f;
    NSInteger num=[self.collectionView numberOfItemsInSection:0];
    for(int i=0;i<num;i++){
        NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:path];
        [self.layoutAttributeArray addObject:attr];
    }
}
//计算所有cell的frame
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutAttributeArray.copy;
}
//计算某一个cell的frame
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    SLPupModel *model = self.data[indexPath.row];
    float cellX=currentX;
    float cellWidth = model.width * 1.0 * self.collectionView.bounds.size.height / model.height;
    if (indexPath.row == self.data.count - 1) {
        currentX += cellWidth;
    } else {
        currentX += cellWidth+self.columnMagrin;
    }
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,0, cellWidth, self.collectionView.bounds.size.height);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize {
    return CGSizeMake(currentX, self.collectionView.bounds.size.height);
}
@end
