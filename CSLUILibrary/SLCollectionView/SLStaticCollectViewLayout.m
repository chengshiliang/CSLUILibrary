//
//  SLStaticCollectViewLayout.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLStaticCollectViewLayout.h"
#import <CSLUILibrary/SLPupModel.h>
#import <CSLUILibrary/SLUIConst.h>

@interface SLStaticCollectViewLayout()
{
    CGSize contentSize;
}
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
    if (self.columns == 0 || self.data.count == 0) return;
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
    if (!self.ajustFrame) return self.layoutAttributeArray.copy;
    if (contentSize.width > 0 && contentSize.height > 0 && contentSize.height != self.collectionView.bounds.size.height) {
        CGFloat scale = self.collectionView.bounds.size.height*1.0/contentSize.height;
        CGFloat lastY = 0;
        CGFloat yOffset = 0;
        for (UICollectionViewLayoutAttributes *attr in self.layoutAttributeArray) {
            CGRect preFrame = attr.frame;
            CGFloat y = preFrame.origin.y;
            CGFloat x = preFrame.origin.x;
            CGFloat height = preFrame.size.height;
            CGFloat width = preFrame.size.width;
            y *= scale;
            height *= scale;
            preFrame = CGRectMake(x, y, width, height);
            attr.frame = preFrame;
        }
    }
    return self.layoutAttributeArray.copy;
}
//计算某一个cell的frame
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    float cellWidth = (self.collectionView.bounds.size.width-(self.columns-1)*self.columnMagrin)/self.columns;
    float rowCount = (self.data.count-1)/self.columns + 1;// 行数
    NSInteger index = indexPath.item;
    SLPupModel *pupModel = self.data[index];
    float cellHeight = pupModel.height*1.0*cellWidth/pupModel.width;// 行高
    float cellX=(cellWidth+self.columnMagrin)*(index%self.columns);
    float cellY=(cellHeight+self.rowMagrin)*(index/self.columns);
    UICollectionViewLayoutAttributes *attr=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame=CGRectMake(cellX,cellY, cellWidth, cellHeight);
    return attr;
}
//得到所有布局好后的cell实际大小
-(CGSize)collectionViewContentSize {
    if (self.data.count == 0 || self.columns == 0) return self.collectionView.bounds.size;
    float width = self.collectionView.bounds.size.width;
    float cellWidth = (width-(self.columns-1)*self.columnMagrin)/self.columns;
    float rowCount = (self.data.count-1)/self.columns + 1;// 行数
    SLPupModel *model = self.data[0];
    float cellHeight = model.height*1.0*cellWidth/model.width;// 行高
    float height =  cellHeight * rowCount + (rowCount - 1)*self.rowMagrin;
    contentSize = CGSizeMake(width, height);
    if (self.ajustFrame) {
        return CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    } else {
        return contentSize;
    }
}
@end
