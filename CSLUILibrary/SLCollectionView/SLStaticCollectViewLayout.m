//
//  SLStaticCollectViewLayout.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLStaticCollectViewLayout.h"

@interface SLStaticCollectViewLayout()
@property(strong, nonatomic)NSMutableArray *layoutAttributeArray;
@end
@implementation SLStaticCollectViewLayout
- (instancetype)init {
    if (self == [super init]) {
        self.columns = 1;
        self.layoutAttributeArray = [NSMutableArray array];
    }
    return self;
}

//系统在开始计算每一个cell之前调用,做一些初始化工作
- (void)prepareLayout {
    if (self.columns == 0) return;
    [self.layoutAttributeArray removeAllObjects];
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
    float cellWidth = (self.collectionView.bounds.size.width-(self.columns-1)*self.columnMagrin)/self.columns;
    float rowCount = (self.count-1)/self.columns + 1;// 行数
    float cellHeight = (self.collectionView.bounds.size.height-(rowCount-1)*self.rowMagrin)/rowCount;// 行高
    NSInteger index = indexPath.row;
    float cellX=(cellWidth+self.columnMagrin)*(index%self.columns);
    float cellY=(cellHeight+self.rowMagrin)*(index/self.columns);
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,cellY, cellWidth, cellHeight);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}
@end
