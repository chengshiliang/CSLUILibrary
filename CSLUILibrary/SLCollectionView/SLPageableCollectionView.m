//
//  SLPageableCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/13.
//

#import "SLPageableCollectionView.h"
#import <CSLUILibrary/SLCollectionViewCell.h>
#import <CSLUILibrary/UIView+SLBase.h>

@interface SLPageableCollectionView()<SLCollectionViewProtocol>
{
    BOOL needRefresh;
    NSInteger currentId;
}
@property (nonatomic, strong) SLRecycleCollectionView *recycleView;
@end

@implementation SLPageableCollectionView

static NSString *const PageableRecycleCellID = @"PageableRecycleCellID";
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
    self.recycleView.delegate = self;
    self.recycleView.hidePageControl = NO;
    self.recycleView.scrollStyle = SLRecycleCollectionViewStylePage;
    self.recycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.recycleView.startingPosition = 0;
    self.recycleView.manual = YES;
    [self.recycleView.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:PageableRecycleCellID];
    [self addSubview:self.recycleView];
}
- (void)layoutSubviews {
    self.recycleView.frame = self.bounds;
    self.recycleView.bottomSpace = self.insets.bottom + self.bottomSpace;
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
    NSMutableArray<SLPupModel *> *array = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (int i = 0; i < self.dataSource.count; i ++) {
        SLPupModel *pupModel = [[SLPupModel alloc]init];
        pupModel.width = self.recycleView.sl_width;
        pupModel.height = self.recycleView.sl_height;
        [array addObject:pupModel];
    }
    self.recycleView.dataSource = [array copy];
    [self.recycleView reloadData];
}

static NSString *const cellId0 = @"kPageableCollectionStaticCellID1";
static NSString *const cellId1 = @"kPageableCollectionStaticCellID2";

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isEqual:self.recycleView]) {
        SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PageableRecycleCellID forIndexPath:indexPath];
        SLStaticCollectionView *staticCollectionView = [[SLStaticCollectionView alloc]initWithFrame:CGRectMake(self.insets.left, self.insets.top, self.recycleView.sl_width-self.insets.left-self.insets.right, self.recycleView.sl_height-self.insets.top-self.insets.bottom)];
        NSArray<SLPupModel *> *modelArray = self.dataSource[indexPath.item];
        staticCollectionView.dataSource = modelArray;
        staticCollectionView.delegate = self;
        staticCollectionView.columns = self.columns;
        staticCollectionView.columnMagrin = self.columnMagrin;
        staticCollectionView.rowMagrin = self.rowMagrin;
        staticCollectionView.ajustFrame = YES;
        staticCollectionView.isRegiste = YES;
        currentId = indexPath.item;
        NSString *cellId = [NSString stringWithFormat:@"cellId%ld", (long)currentId];
        [staticCollectionView.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [cell.contentView addSubview:staticCollectionView];
        [staticCollectionView reloadData];
        return cell;
    } else if ([view isKindOfClass:[SLStaticCollectionView class]]) {
        NSString *cellId = [NSString stringWithFormat:@"cellId%ld", (long)currentId];
        SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        if (self.cellConfig) return self.cellConfig(currentId, indexPath.item, cell);
        return cell;
    }
    return nil;
}



@end
