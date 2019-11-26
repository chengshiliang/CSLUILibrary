//
//  SLPupView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLPupView.h"
#import <CSLUILibrary/SLCollectionViewLayout.h>
#import <CSLUILibrary/SLUIConsts.h>

static NSString *const pupViewCellID = @"kSLPupViewCellID";

@interface SLPupView ()<UICollectionViewDataSource,UICollectionViewDelegate,SLCollectionViewLayoutDelegate>
{
    BOOL isRegiste;
}
@property(strong,nonatomic)SLCollectionViewLayout *layout;
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
    self.layout=[[SLCollectionViewLayout alloc]init];
    self.layout.delegate = self;
    self.columns = 3;
    self.rowMagrin = 0;
    self.columnMagrin = 0;
    self.collectionView=[[SLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
}

- (CGSize)pupContentSize {
    return self.layout.collectViewContentSize;
}

- (void)reloadData {
    self.layout.columns = self.columns;
    self.layout.rowMagrin = self.rowMagrin;
    self.layout.columnMagrin = self.columnMagrin;
    if (!isRegiste) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerCell:forView:)]) {
            [self.delegate registerCell:self.collectionView forView:self];
        } else {
            [self.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:pupViewCellID];
        }
        isRegiste = YES;
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customCellForItemAtIndexPath:forView:)]) {
        return [self.delegate collectionView:collectionView customCellForItemAtIndexPath:indexPath forView:self];
    }
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:pupViewCellID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:forView:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexPath forView:self];
    }
}

@end
