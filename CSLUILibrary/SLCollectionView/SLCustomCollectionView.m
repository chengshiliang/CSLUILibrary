//
//  SLCustomCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/27.
//

#import "SLCustomCollectionView.h"
#import <CSLUILibrary/SLPupModel.h>

@interface SLCustomCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isRegiste;
}
@property(strong,nonatomic)UICollectionViewFlowLayout *layout;
@end

@implementation SLCustomCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layout=[[UICollectionViewFlowLayout alloc]init];
    self.collectionView=[[SLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = CGRectMake(self.bounds.origin.x+self.insets.left, self.bounds.origin.y+self.insets.top, self.bounds.size.width-self.insets.left-self.insets.right, self.bounds.size.height-self.insets.top-self.insets.bottom);
}
static NSString *const customCollectionViewCellID = @"";
- (void)reloadData {
    if (self.columns <= 0) return;
    self.layout.minimumLineSpacing = self.columnMagrin;
    self.layout.minimumInteritemSpacing = self.rowMagrin;
    if (!isRegiste) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerCell:forView:)]) {
            [self.delegate registerCell:self.collectionView forView:self];
        } else {
            [self.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:customCollectionViewCellID];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerHeader:forView:)]) {
            [self.delegate registerHeader:self.collectionView forView:self];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerFooter:forView:)]) {
            [self.delegate registerFooter:self.collectionView forView:self];
        }
        isRegiste = YES;
    }
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
- (CGSize)collectionView:(SLCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLCustomCollectionModel *model = self.dataSource[indexPath.section];
    SLPupModel *pupModel = model.datas[indexPath.item];
    float itemWidth = (self.collectionView.bounds.size.width - (self.columns - 1)*self.columnMagrin)*1.0/self.columns;
    float itemHeight = pupModel.height*1.0*itemWidth/pupModel.width;// 行高
    return CGSizeMake(itemWidth, itemHeight);
}
-(NSInteger)collectionView:(SLCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SLCustomCollectionModel *model = self.dataSource[section];
    return model.datas.count;
}
- (CGSize)collectionView:(SLCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SLCustomCollectionModel *model = self.dataSource[section];
    return CGSizeMake(model.headerWidth, model.headerHeigth);
}
- (CGSize)collectionView:(SLCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    SLCustomCollectionModel *model = self.dataSource[section];
    return CGSizeMake(model.footerWidth, model.footerHeigth);
}
- (UICollectionReusableView *)collectionView:(SLCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sl_collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.delegate sl_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}
-(SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customCellForItemAtIndexPath:forView:)]) {
        return [self.delegate collectionView:collectionView customCellForItemAtIndexPath:indexPath forView:self];
    }
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:customCollectionViewCellID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:forView:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexPath forView:self];
    }
}

@end
