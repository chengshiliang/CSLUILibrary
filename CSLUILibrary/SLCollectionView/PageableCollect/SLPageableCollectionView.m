//
//  SLPageableCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/13.
//

#import "SLPageableCollectionView.h"
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLRecycleCollectionView.h>
#import <CSLUILibrary/SLStaticCollectionView.h>

@implementation SLPageableCollectSectionModel
- (instancetype)init {
    if (self == [super init]) {
        
    }
    return self;
}
@end

@implementation SLPageableCollectRowModel
- (instancetype)init {
    if (self == [super init]) {
        self.registerName = @"SLPageableCollectionCell";
        self.type = SLCollectRowTypeCode;
    }
    return self;
}
@end

@implementation SLPageableCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.staticCollectView = [[SLStaticCollectionView alloc]init];
        [self.contentView addSubview:self.staticCollectView];
    }
    return self;
}
@end

@interface SLPageableCollectionView()
{
    BOOL needRefresh;
}
@property (nonatomic, strong) SLRecycleCollectionView *recycleView;
@property (nonatomic, assign) NSInteger currentId;
@end

@implementation SLPageableCollectionView

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
    self.recycleView = [[SLRecycleCollectionView alloc]init];
    self.recycleView.loop = NO;
    self.recycleView.hidePageControl = NO;
    self.recycleView.scrollStyle = SLRecycleCollectionViewStylePage;
    self.recycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.recycleView.startingPosition = 0;
    self.recycleView.manual = YES;
    [self addSubview:self.recycleView];
}
- (void)layoutSubviews {
    self.recycleView.frame = self.bounds;
    self.recycleView.bottomSpace = self.dataSource.insetForSection.bottom + self.bottomSpace;
    if (needRefresh) {
        [self reload];
    }
}

- (void)reload {
    if (self.recycleView.sl_width <= 0 || self.recycleView.sl_height <= 0) {
        needRefresh = true;
        return;
    }
    needRefresh = false;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.dataSource.rows.count];
    for (int i = 0; i < self.dataSource.rows.count; i ++) {
        id<SLCollectRowProtocol> model = self.dataSource.rows[i];
        model.rowWidth = self.recycleView.sl_width;
        model.rowHeight = self.recycleView.sl_height;
        [array addObject:model];
    }
    self.dataSource.rows = [array copy];
    self.recycleView.dataSource = self.dataSource;
    if (self.currentIndicatorImage) {
        self.recycleView.currentIndicatorImage = self.currentIndicatorImage;
    }
    if (self.indicatorImage) {
        self.recycleView.indicatorImage = self.indicatorImage;
    }
    if (self.currentIndicatorColor) {
        self.recycleView.currentIndicatorColor = self.currentIndicatorColor;
    }
    if (self.indicatorColor) {
        self.recycleView.currentIndicatorImage = self.indicatorColor;
    }
    if (self.pageControlSize.width > 0 && self.pageControlSize.height > 0) {
        self.recycleView.pageControlSize = self.pageControlSize;
    }
    self.recycleView.currentIndicatorColor = self.currentIndicatorColor;
    self.recycleView.scrollToIndexBlock = [self.scrollToIndexBlock copy];
    WeakSelf;
    self.recycleView.displayCollectCell = ^(SLCollectBaseView * _Nonnull collectView, UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLCollectRowProtocol>  _Nonnull rowModel) {
        StrongSelf;
        if ([cell isKindOfClass:[SLPageableCollectionCell class]] && [rowModel isKindOfClass:[SLPageableCollectRowModel class]]) {
            SLPageableCollectionCell *pageableCell = (SLPageableCollectionCell *)cell;
            SLPageableCollectRowModel *model = (SLPageableCollectRowModel *)rowModel;
            pageableCell.staticCollectView.frame = CGRectMake(strongSelf.dataSource.insetForSection.left, strongSelf.dataSource.insetForSection.top, CGRectGetWidth(strongSelf.bounds)-strongSelf.dataSource.insetForSection.left-strongSelf.dataSource.insetForSection.right, CGRectGetHeight(strongSelf.bounds)-strongSelf.dataSource.insetForSection.top-strongSelf.dataSource.insetForSection.bottom);
            pageableCell.staticCollectView.dataSource = model.rowModel;
            pageableCell.staticCollectView.columns = strongSelf.columns;
            pageableCell.staticCollectView.selectCollectView = [strongSelf.selectSubCollectView copy];
            strongSelf.currentId = indexPath.item;
            [pageableCell.staticCollectView reloadData];
        }
    };
    [self.recycleView reloadData];
}

@end
