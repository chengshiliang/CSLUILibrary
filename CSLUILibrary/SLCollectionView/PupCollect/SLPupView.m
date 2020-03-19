//
//  SLPupView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/6.
//

#import "SLPupView.h"
#import <CSLUILibrary/SLCollectionViewLayout.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLCollectManager.h>

@interface SLPupView ()
@property(strong,nonatomic)SLCollectionViewLayout *layout;
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
    self.columns = 3;
    self.collectionView=[[SLCollectBaseView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    self.collectionView.frame = CGRectMake(self.dataSource.insetForSection.left, self.dataSource.insetForSection.top, self.sl_width-self.dataSource.insetForSection.left-self.dataSource.insetForSection.right, self.sl_height-self.dataSource.insetForSection.top-self.dataSource.insetForSection.bottom);
}

- (void)reloadData {
    self.layout.columns = self.columns;
    self.layout.rowMagrin = self.dataSource.minimumLineSpacing;
    self.layout.columnMagrin = self.dataSource.minimumInteritemSpacing;
    self.layout.data = self.dataSource.rows;
    [self setNeedsLayout];
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:[@[self.dataSource]mutableCopy] delegateHandler:nil];
    self.collectionView.manager.selectCollectView = [self.selectCollectView copy];
    self.collectionView.manager.displayCell = [self.displayCollectCell copy];
    [self.collectionView.manager reloadData];
}

@end
