//
//  SLNoRuleCollectionViewLayout.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/26.
//

#import "SLNoRuleCollectionViewLayout.h"
#import <CSLUILibrary/SLUIConst.h>

static CGFloat minXLarge = 1.5;
static CGFloat minYLarge = 1.5;

@interface SLNoRuleCollectionViewLayout()
@property(strong, nonatomic)NSMutableArray *columnsY;
@property(strong, nonatomic)NSMutableArray *layoutAttributeArray;
@end

@implementation SLNoRuleCollectionViewLayout
- (instancetype)init {
    if (self == [super init]) {
        self.xlarge = minXLarge;
        self.ylarge = minYLarge;
        self.columns = 3;
        self.columnsY=[NSMutableArray array];
        self.layoutAttributeArray = [NSMutableArray array];
    }
    return self;
}

//系统在开始计算每一个cell之前调用,做一些初始化工作
- (void)prepareLayout {
    if (self.columns == 0) return;
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
    
    self.xlarge = MAX(minXLarge, self.xlarge);
    self.ylarge = MAX(minYLarge, self.ylarge);
    
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    SLPupModel *model = self.data[indexPath.item];
    
    NSInteger xlarger = 1;
    float cellH = 0;
    NSInteger num = floor(model.width*1.0/cellWidth - self.xlarge);
    if (num >= 0 && num < self.columnsY.count) {
        while (num >= 0) {
            if (minYIndex < self.columnsY.count-num-1) {
                BOOL isOk = true;
                for (int i = 1; i <= num+1; i++) {
                    if (cellY != [self.columnsY[minYIndex+i] floatValue]) {//当前列和后面的列都对其
                        isOk = false;
                        break;
                    }
                }
                if (isOk) {
                    xlarger = num + 2;// 则可放大到num+2倍
                    break;
                }
            }
            num --;
        }
        cellH = (cellWidth*xlarger+(xlarger-1)*self.columnMagrin)*(model.height*1.0)/model.width+(xlarger-1)*self.rowMagrin;
        if (xlarger == 1) {
            [self nolargeItem:attr index:minYIndex x:cellX y:cellY w:cellWidth h:cellH];
        } else {
            for (int i = minYIndex; i < xlarger+minYIndex; i++) {
                self.columnsY[i] = @(cellY+self.rowMagrin+cellH);
            }
            attr.frame=CGRectMake(cellX,cellY, cellWidth*xlarger+(xlarger-1)*self.columnMagrin, cellH);
        }
    } else {
        cellH = cellWidth*(model.height*1.0)/model.width;
        [self nolargeItem:attr index:minYIndex x:cellX y:cellY w:cellWidth h:cellH];
    }
    return attr;
}

- (void)nolargeItem:(UICollectionViewLayoutAttributes *)attr  index:(NSInteger)minYIndex x:(CGFloat)cellX y:(CGFloat)cellY w:(CGFloat)cellWidth h:(CGFloat)cellH{

    if (minYIndex < self.columnsY.count - 1 && ABS(cellY+cellH-[self.columnsY[minYIndex+1] floatValue]+self.rowMagrin) < cellH * (self.ylarge-1)) {
        attr.frame = CGRectMake(cellX, cellY, cellWidth, [self.columnsY[minYIndex+1] floatValue]-self.rowMagrin-cellY);
    } else if (minYIndex > 0 && ABS(cellY+cellH-[self.columnsY[minYIndex-1] floatValue]+self.rowMagrin) < cellH * (self.ylarge-1)) {
        attr.frame = CGRectMake(cellX, cellY, cellWidth, [self.columnsY[minYIndex-1] floatValue]-self.rowMagrin-cellY);
    } else {
        attr.frame = CGRectMake(cellX, cellY, cellWidth, cellH);
    }
    self.columnsY[minYIndex] = @(CGRectGetMaxY(attr.frame)+self.rowMagrin);
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
    maxYCollumn-=self.rowMagrin;
    CGSize contentSize = CGSizeMake(self.collectionView.bounds.size.width, maxYCollumn);
    if (contentSize.width > 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:SLNoRuleCollectionViewContentSizeChange object:[NSValue valueWithCGSize:contentSize]];
        if (self.contentSizeChange && contentSize.width > 0) self.contentSizeChange([NSValue valueWithCGSize:contentSize]);
    }
    return contentSize;
}
@end
