//
//  SLNoRuleCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/26.
//

#import "SLNoRuleCollectionView.h"
#import <CSLUILibrary/SLNoRuleCollectionViewLayout.h>
#import <CSLUILibrary/SLUIConsts.h>

static NSString *const noRuleViewCellID = @"kSLNoRuleViewCellID";

@interface SLNoRuleCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL isRegiste;
}
@property(strong,nonatomic)SLNoRuleCollectionViewLayout *layout;
@property(strong,nonatomic)SLCollectionView *collectionView;
@end

@implementation SLNoRuleCollectionView

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
    self.layout=[[SLNoRuleCollectionViewLayout alloc]init];
    self.columns = 3;
    self.rowMagrin = 0;
    self.columnMagrin = 0;
    self.xlarge = 1.5;
    self.ylarge = 1.5;
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
    self.layout.xlarge = self.xlarge;
    self.layout.ylarge = self.ylarge;
    self.layout.rowMagrin = self.rowMagrin;
    self.layout.columnMagrin = self.columnMagrin;
    self.layout.data = self.dataSource.copy;
    if (!isRegiste) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(registerCell:forView:)]) {
            [self.delegate registerCell:self.collectionView forView:self];
        } else {
            [self.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:noRuleViewCellID];
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
    SLCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:noRuleViewCellID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(SLCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customDidSelectItemAtIndexPath:forView:)]) {
        [self.delegate collectionView:collectionView customDidSelectItemAtIndexPath:indexPath forView:self];
    }
}

@end