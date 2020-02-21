//
//  SLCardCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import "SLCardCollectionView.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLCardCollectViewFlowLayout.h>
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectProxy.h>

static NSString *const cardViewCellID = @"kSLCardViewCellID";

@interface SLCardCollectionView()<UIScrollViewDelegate>
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
    self.collectionView=[[SLCollectBaseView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
}

- (void)reloadData {
    self.layout.data = self.dataSource.rows.copy;
    self.layout.sectionInset = self.dataSource.insetForSection;
    self.layout.minimumLineSpacing = self.dataSource.minimumLineSpacing;
    self.layout.minimumInteritemSpacing = self.dataSource.minimumInteritemSpacing;
    self.layout.scrollDirection = self.direction;
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:@[self.dataSource] delegateHandler:[SLCollectScrollProxy new]];
    self.collectionView.manager.displayCell = [self.displayCollectCell copy];
    WeakSelf;
    self.collectionView.manager.scrollViewDidEndDeceleratingCallback = ^(SLCollectBaseView * _Nonnull collectView) {
        StrongSelf;
        NSInteger index = 0;
        if (strongSelf.direction == UICollectionViewScrollDirectionVertical) {
            index = floor(collectView.contentOffset.y*1.0/(collectView.sl_height - strongSelf.layout.sectionInset.bottom-strongSelf.layout.sectionInset.top + strongSelf.layout.minimumLineSpacing));
        } else {
            index = floor(collectView.contentOffset.x*1.0/(collectView.sl_width - strongSelf.layout.sectionInset.right-strongSelf.layout.sectionInset.left + strongSelf.layout.minimumLineSpacing));
        }
        if (strongSelf.scrollEndBlock) strongSelf.scrollEndBlock(MAX(index, 0));
    };
    [self.collectionView.manager reloadData];
}

@end
