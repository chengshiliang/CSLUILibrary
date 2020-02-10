//
//  SLCollectionViewLayout.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLCollectionViewLayout.h"

@interface SLCollectionViewLayout()
@property(strong, nonatomic)NSMutableArray *columnsY;
@property(strong, nonatomic)NSMutableArray *layoutAttributeArray;
@end

@implementation SLCollectionViewLayout
- (instancetype)init {
    if (self == [super init]) {
        self.columns = 3;
        self.columnsY=[NSMutableArray array];
        self.layoutAttributeArray = [NSMutableArray array];
    }
    return self;
}

//系统在开始计算每一个cell之前调用,做一些初始化工作
- (void)prepareLayout {
    if (self.columns == 0 || self.data.count == 0) return;
    [self.columnsY removeAllObjects];
    [self.layoutAttributeArray removeAllObjects];
    for(int i=0;i<self.columns;i++){
        [self.columnsY addObject:@(0.0)];
    }
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
    float minYCollumn = [self.columnsY[0] floatValue];
    int minYIndex = 0;
    if (self.columnsY.count > 1) {
        for (int i = 1; i < self.columnsY.count; i ++) {
            NSNumber * number = self.columnsY[i];
            if ([number floatValue] < minYCollumn) {
                minYCollumn = [number floatValue];
                minYIndex = i;
            }
        }
    }
    
    float cellY=[self.columnsY[minYIndex] floatValue];
    float cellX=(cellWidth+self.columnMagrin)*minYIndex;
    NSInteger index = indexPath.item;
    id<SLCollectRowProtocol>model = self.data[index];
    float cellH = model.rowHeight*1.0*cellWidth/model.rowWidth;// 行高
    self.columnsY[minYIndex] = @(cellY+self.rowMagrin+cellH);
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,cellY, cellWidth, cellH);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize {
    if (self.columnsY.count == 0) return CGSizeZero;
    float maxYCollumn = [self.columnsY[0] floatValue];
    if (self.columnsY.count > 1) {
        for (int i = 1; i < self.columnsY.count; i ++) {
            NSNumber * number = self.columnsY[i];
            if ([number floatValue] > maxYCollumn) {
                maxYCollumn = [number floatValue];
            }
        }
    }
    maxYCollumn -= self.rowMagrin;
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, maxYCollumn);
    return contentSize;
}
@end
