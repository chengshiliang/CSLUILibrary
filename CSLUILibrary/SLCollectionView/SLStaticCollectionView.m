//
//  SLStaticCollectionView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLStaticCollectionView.h"
#import <CSLUILibrary/SLStaticCollectViewLayout.h>
#import <CSLUILibrary/SLUIConsts.h>

static NSString *const pupViewCellID = @"kSLStaticViewCellID";

@interface SLStaticCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isRegiste;
}
@property(strong,nonatomic)SLStaticCollectViewLayout *layout;
@property(strong,nonatomic)SLCollectionView *collectionView;
@end
@implementation SLStaticCollectionView
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
    self.layout=[[SLStaticCollectViewLayout alloc]init];
    self.layout.columns = 1;
    self.layout.rowMagrin = 0;
    self.layout.columnMagrin = 0;
    self.layout.count = 1;
    self.collectionView=[[SLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
}

- (void)reloadData {
    self.layout.columns = self.columns;
    self.layout.rowMagrin = self.rowMagrin;
    self.layout.columnMagrin = self.columnMagrin;
    self.layout.count = self.dataSource.count;
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
