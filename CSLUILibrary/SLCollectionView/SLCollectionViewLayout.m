//
//  SLCollectionViewLayout.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLCollectionViewLayout.h"

@interface SLCollectionViewLayout()
@property(strong, nonatomic)NSMutableArray *columnsY;
@property(assign, nonatomic)float cellWidth;//列宽
@end

@implementation SLCollectionViewLayout
- (instancetype)init {
    if (self == [super init]) {
        self.columns = 3;
        self.columnsY=[NSMutableArray array];
    }
    return self;
}

//系统在开始计算每一个cell之前调用,做一些初始化工作
- (void)prepareLayout {
    self.cellWidth = (self.collectionView.bounds.size.width-(self.columns-1)*self.columnMagrin)/self.columns;
}
//计算所有cell的frame
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    [self.columnsY removeAllObjects];
    for(int i=0;i<self.columns;i++){
        [self.columnsY addObject:@(0.0)];
    }
    if (self.columnsY.count == 0) return @[];
    NSMutableArray *arr = [NSMutableArray array];
    //得到cell个数
    NSInteger num=[self.collectionView numberOfItemsInSection:0];
    for(int i=0;i<num;i++){
        NSIndexPath *path=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr=[self layoutAttributesForItemAtIndexPath:path];
        [arr addObject:attr];
    }
    return arr.copy;
}
//计算某一个cell的frame
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.columnsY.count == 0) return nil;
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
    float cellX=(self.cellWidth+self.columnMagrin)*minYIndex;
    float cellH = 0;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(layout:heightWithWidth:indexPath:)]){
        cellH = [self.delegate layout:self heightWithWidth:self.cellWidth indexPath:indexPath];
    }
    self.columnsY[minYIndex] = @(cellY+self.rowMagrin+cellH);
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,cellY, self.cellWidth, cellH);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize
{
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
    return CGSizeMake(self.collectionView.bounds.size.width, maxYCollumn);
}
@end
