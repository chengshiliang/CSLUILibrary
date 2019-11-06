//
//  SLPupView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLPupView.h"
#import <CSLUILibrary/SLCollectionViewLayout.h>
#import <CSLUILibrary/SLUIConsts.h>

static const NSString *const pupViewCellID = @"kPupViewCellID";

@interface SLPupView ()<UICollectionViewDataSource,UICollectionViewDelegate,SLCollectionViewLayoutDelegate>
@property(strong,nonatomic)SLCollectionView *collectionView;
@end
@implementation SLPupView

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
    SLCollectionViewLayout *layout=[[SLCollectionViewLayout alloc]init];
    layout.delegate = self;
    self.collectionView=[[SLCollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self addSubview:self.collectionView];
}

- (void)reloadData {
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerCell:)]) {
        [self.delegate registerCell:self.collectionView];
    } else {
        [self.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:pupViewCellID];
    }
    [self.collectionView reloadData];
}

- (CGFloat)layout:(SLCollectionViewLayout *)layout heightWithWidth:(float)width indexPath:(NSIndexPath *)indexPath {
    SLPupModel *model=self.dataSource[indexPath.row];
    return width*(model.height*1.0)/model.width;
}

-(NSInteger)collectionView:(SLCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customCellForItemAtIndexPath:)]) {
        return [self.delegate collectionView:collectionView customCellForItemAtIndexPath:indexPath];
    }
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:pupViewCellID forIndexPath:indexPath];
    SLPupModel *model=self.dataSource[indexPath.row];
    cell.model=model.data;
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexPath];
    }
}

@end