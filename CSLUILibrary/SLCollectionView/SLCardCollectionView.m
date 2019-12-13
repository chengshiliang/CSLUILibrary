//
//  SLCardCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLCardCollectionView.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLCardCollectViewFlowLayout.h>

static NSString *const cardViewCellID = @"kSLCardViewCellID";

@interface SLCardCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(strong,nonatomic)SLCardCollectViewFlowLayout *layout;
@end
@implementation SLCardCollectionView
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
    self.layout=[[SLCardCollectViewFlowLayout alloc]init];
    self.collectionView=[[SLCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
}

- (void)reloadData {
    self.layout.data = self.dataSource.copy;
    self.layout.sectionInset = self.insets;
    self.layout.minimumLineSpacing = self.itemMargin;
    if (self.direction == Horizontal) {
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    } else {
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    if (!self.isRegiste) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerCell:forView:)]) {
            [self.delegate registerCell:self.collectionView forView:self];
        } else {
            [self.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cardViewCellID];
        }
        self.isRegiste = YES;
    }
    [self.collectionView reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = 0;
    if (self.direction == Vertical) {
        index = floor(scrollView.contentOffset.y*1.0/(scrollView.frame.size.height - self.insets.bottom-self.insets.top + self.itemMargin));
    } else {
        index = floor(scrollView.contentOffset.x*1.0/(scrollView.frame.size.width - self.insets.left-self.insets.left + self.itemMargin));
    }
    if (self.scrollEndBlock) self.scrollEndBlock(MAX(index, 0));
}

-(NSInteger)collectionView:(SLCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;;
}
-(SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customCellForItemAtIndexPath:forView:)]) {
        return [self.delegate collectionView:collectionView customCellForItemAtIndexPath:indexPath forView:self];
    }
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cardViewCellID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:forView:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexPath forView:self];
    }
}
@end
