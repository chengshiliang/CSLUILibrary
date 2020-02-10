//
//  SLDropDownView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/17.
//

#import "SLDropDownView.h"
#import <CSLUtils/SLUIConsts.h>
#import <CSLUtils/NSString+Util.h>
#import <CSLUtils/UIView+SLBase.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLUILibrary/SLTableView.h>
#import <CSLUILibrary/SLCollectBaseView.h>
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLCollectProxy.h>
#import <CSLUILibrary/SLTableManager.h>
#import <CSLUILibrary/SLTableModel.h>

@interface SLDropDownView ()
@property (nonatomic, copy) void(^completeBlock)(void);
@property (nonatomic, strong) SLView *backView;
@property (nonatomic, strong) SLView *containerView;
@end

@implementation SLDropDownView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backView = [[SLView alloc] init];
    self.backView.backgroundColor = SLUIHexColor(0x00ff00);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    WeakSelf;
    [tapGesture on:self click:^(UIGestureRecognizer * _Nonnull gesture) {
        StrongSelf;
        [strongSelf hide];
    }];
    tapGesture.cancelsTouchesInView = NO;
    [self.backView addGestureRecognizer:tapGesture];
    self.containerView = [[SLView alloc]init];
    self.containerView.backgroundColor = SLUIHexColor(0x999999);
    self.backgroundColor = SLUIHexColor(0xffffff);
}

- (void)hide {
    [UIView animateWithDuration:0.25f animations:^{
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
        [self.containerView removeFromSuperview];
    } completion:^(BOOL finished) {
        !self.completeBlock?:self.completeBlock();
    }];
}

- (void)showToView:(UIView *)pointView targetView:(UIView *)targetView completeBlock:(void(^)(void))completeBlock {
    self.completeBlock = [completeBlock copy];
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:[UIApplication sharedApplication].keyWindow];
    CGFloat pointViewTopY = CGRectGetMinY(pointViewRect);
    CGPoint toPoint = CGPointMake(0, pointViewTopY);
    [self showWithPoint:toPoint targetView:targetView];
}

- (void)showToPoint:(CGPoint)toPoint targetView:(UIView *)targetView completeBlock:(void(^)(void))completeBlock {
    self.completeBlock = [completeBlock copy];
    [self showWithPoint:CGPointMake(0, toPoint.y) targetView:targetView];
}

- (void)showWithPoint:(CGPoint)toPoint targetView:(UIView *)targetView {
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    if (!targetView) return;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [targetView addSubview:self.backView];
    [targetView addSubview:self.containerView];
    [self.containerView addSubview:self];
    if (self.type == SLDropDownViewDisplayCollect && self.collectDatas && self.collectDatas.count > 0) {
        SLCollectBaseView *collectionView = [[SLCollectBaseView alloc]initWithFrame:CGRectMake(0, self.spaceVertical, targetView.sl_width, targetView.sl_height-toPoint.y-self.spaceVertical)];
        collectionView.manager = [[SLCollectManager alloc]initWithSections:self.collectDatas delegateHandler:[SLCollectFlowlayoutProxy new]];
        collectionView.manager.displayCell = [self.displayCollectCell copy];
        collectionView.manager.displayHeader = [self.displayCollectHeader copy];
        collectionView.manager.displayFooter = [self.displayCollectFooter copy];
        collectionView.manager.selectCollectView = [self.selectCollectView copy];
        [self addSubview:collectionView];
        [collectionView.manager reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView layoutIfNeeded];
            collectionView.scrollEnabled = collectionView.contentSize.height > collectionView.sl_height;
            self.frame = CGRectMake(0, 0, targetView.sl_width, MIN(targetView.sl_height-toPoint.y, collectionView.contentSize.height+self.spaceVertical));
            collectionView.sl_height = MIN(collectionView.contentSize.height, collectionView.sl_height);
        });
    } else if (self.type == SLDropDownViewDisplayTable && self.tableDatas && self.tableDatas.count == 1) {
        SLTableView *tableView = [[SLTableView alloc]initWithFrame:CGRectMake(0, self.spaceVertical, targetView.sl_width, targetView.sl_height-toPoint.y-self.spaceVertical) style:UITableViewStylePlain];
        tableView.manager = [[SLTableManager alloc]initWithSections:self.tableDatas.copy delegateHandler:nil];
        tableView.manager.displayCell = [self.displayTableCell copy];
        tableView.manager.selectTableView = [self.selectTableView copy];
        [self addSubview:tableView];
        [tableView.manager reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView layoutIfNeeded];
            tableView.scrollEnabled = tableView.contentSize.height > tableView.sl_height;
            self.frame = CGRectMake(0, 0, targetView.sl_width, MIN(tableView.contentSize.height+self.spaceVertical, targetView.sl_height-toPoint.y));
            tableView.sl_height = MIN(tableView.contentSize.height, tableView.sl_height);
        });
    } else if (self.type == SLDropDownViewDisplayTable && self.tableDatas && self.tableDatas.count > 1) {
        SLTableView *leftTableView = [[SLTableView alloc]initWithFrame:CGRectMake(0, self.spaceVertical, self.leftTableWidth, targetView.sl_height-toPoint.y-self.spaceVertical) style:UITableViewStylePlain];
        SLTableSectionModel *leftSecModel = [SLTableSectionModel new];
        NSMutableArray<id<SLTableRowProtocol>> *leftRows = [NSMutableArray array];
        for (id<SLTableSectionProtocol> secModel in self.tableDatas) {
            SLTableRowModel *leftRowModel = [SLTableRowModel new];
            if (![NSString emptyString:[secModel headerReuseIdentifier]]) {
                leftRowModel.reuseIdentifier = [secModel headerReuseIdentifier];
            } else if (![NSString emptyString:[secModel footerReuseIdentifier]]) {
                leftRowModel.reuseIdentifier = [secModel footerReuseIdentifier];
            } else {
                leftRowModel.reuseIdentifier = @"UITableRowCell";
            }
            if (secModel.heightForHeader > 0) {
                leftRowModel.rowHeight = secModel.heightForHeader;
                leftRowModel.estimatedHeight = secModel.heightForHeader;
            } else if (secModel.heightForFooter > 0) {
                leftRowModel.rowHeight = secModel.heightForFooter;
                leftRowModel.estimatedHeight = secModel.heightForFooter;
            }
            if (![NSString emptyString:[secModel headerRegisterName]]) {
                leftRowModel.registerName = [secModel headerRegisterName];
            } else if (![NSString emptyString:[secModel footerRegisterName]]) {
                leftRowModel.registerName = [secModel footerRegisterName];
            } else {
                leftRowModel.registerName = @"UITableViewCell";
            }
            if (secModel.headerType > 0) {
                leftRowModel.type = secModel.headerType;
            } else if (secModel.footerType > 0) {
                leftRowModel.type = secModel.headerType;
            }
            [leftRows addObject:leftRowModel];
        }
        leftSecModel.rows = leftRows;
        leftTableView.manager = [[SLTableManager alloc]initWithSections:@[leftSecModel] delegateHandler:nil];
        leftTableView.manager.displayCell = [self.displayLeftTableCell copy];
        [self addSubview:leftTableView];
        
        SLTableView *rightTableView = [[SLTableView alloc]initWithFrame:CGRectMake(self.leftTableWidth, self.spaceVertical, targetView.sl_width - self.leftTableWidth, targetView.sl_height-toPoint.y-self.spaceVertical) style:UITableViewStylePlain];
        rightTableView.manager.selectTableView = [self.selectTableView copy];
        rightTableView.manager = [[SLTableManager alloc]initWithSections:[@[self.tableDatas[self.leftSelectIndex]] mutableCopy] delegateHandler:nil];
        rightTableView.manager.displayCell = [self.displayTableCell copy];
        [self addSubview:rightTableView];
        self.frame = CGRectMake(0, 0, targetView.sl_width,  targetView.sl_height-toPoint.y);
        WeakSelf;
        __weak typeof (leftTableView) weakLeftTable = leftTableView;
        __weak typeof (rightTableView) weakRightTable = rightTableView;
        leftTableView.manager.selectTableView = ^(SLTableView * _Nonnull tableView, UITableViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id<SLTableRowProtocol>  _Nonnull rowModel) {
            StrongSelf;
            __strong typeof (leftTableView) strongLeftTable = weakLeftTable;
            __strong typeof (rightTableView) strongRightTable = weakRightTable;
            strongSelf.leftSelectIndex = indexPath.row;
            [strongLeftTable.manager reloadData];
            [strongSelf reloadRightTable:strongRightTable];
        };
        [leftTableView.manager reloadData];
        [self reloadRightTable:rightTableView];
    }
    self.backView.frame = targetView.bounds;
    self.containerView.frame = CGRectMake(0, toPoint.y, targetView.sl_width, targetView.sl_height-toPoint.y);
    
    self.backView.alpha = 0.f;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 1.f;
    }];
}

- (void)reloadRightTable:(SLTableView *)tableView {
    tableView.manager.sections = [@[self.tableDatas[self.leftSelectIndex]] mutableCopy];
    [tableView.manager reloadData];
}

@end
