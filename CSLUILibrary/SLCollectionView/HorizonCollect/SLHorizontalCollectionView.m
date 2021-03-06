//
//  SLHorizontalCollectionView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLHorizontalCollectionView.h"
#import <CSLUILibrary/SLHorizontalCollectionViewLayout.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLCollectManager.h>

@interface SLHorizontalCollectionView ()
@property(strong,nonatomic)SLHorizontalCollectionViewLayout *layout;
@end
@implementation SLHorizontalCollectionView
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
    self.layout=[[SLHorizontalCollectionViewLayout alloc]init];
    self.layout.columnMagrin = 0;
    self.collectionView=[[SLCollectBaseView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = CGRectMake(self.dataSource.insetForSection.left, self.dataSource.insetForSection.top, self.sl_width-self.dataSource.insetForSection.left-self.dataSource.insetForSection.right, self.sl_height-self.dataSource.insetForSection.top-self.dataSource.insetForSection.bottom);
}

- (void)reloadData {
    self.layout.data = self.dataSource.rows.copy;
    self.layout.columnMagrin = self.dataSource.minimumInteritemSpacing;
    [self setNeedsLayout];
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:[@[self.dataSource]mutableCopy] delegateHandler:nil];
    self.collectionView.manager.selectCollectView = [self.selectCollectView copy];
    self.collectionView.manager.displayCell = [self.displayCollectCell copy];
    [self.collectionView.manager reloadData];
}

@end
