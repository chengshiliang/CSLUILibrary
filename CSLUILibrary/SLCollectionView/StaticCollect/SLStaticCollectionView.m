//
//  SLStaticCollectionView.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import "SLStaticCollectionView.h"
#import <CSLUILibrary/SLStaticCollectViewLayout.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectBaseView.h>

@interface SLStaticCollectionView()
@property(strong,nonatomic)SLStaticCollectViewLayout *layout;
@property(nonatomic,strong)SLCollectBaseView *collectionView;
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
    self.columns = 1;
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
    self.layout.data = self.dataSource.rows.copy;
    [self setNeedsLayout];
    self.collectionView.manager = [[SLCollectManager alloc]initWithSections:@[self.dataSource] delegateHandler:nil];
    self.collectionView.manager.selectCollectView = [self.selectCollectView copy];
    self.collectionView.manager.displayCell = [self.displayCollectCell copy];
    [self.collectionView reloadData];
}

@end
