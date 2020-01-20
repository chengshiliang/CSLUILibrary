//
//  SLDropDownView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/17.
//

#import "SLDropDownView.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import <CSLCommonLibrary/UIGestureRecognizer+Action.h>
#import <CSLUILibrary/SLTableView.h>
#import <CSLUILibrary/SLCollectBaseView.h>
#import <CSLUILibrary/SLCollectManager.h>

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
    self.columns = 1;
    self.backView = [[SLView alloc] init];
    self.backView.backgroundColor = SLUIHexColor(0x00ff00);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    WeakSelf;
    [tapGesture on:self click:^(UIGestureRecognizer * _Nonnull gesture) {
        StrongSelf;
        [strongSelf hide];
    }];
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
    CGPoint toPoint = CGPointMake(0, pointViewTopY - self.spaceVertical);
    [self showWithPoint:toPoint targetView:targetView];
}

- (void)showToPoint:(CGPoint)toPoint targetView:(UIView *)targetView completeBlock:(void(^)(void))completeBlock {
    self.completeBlock = [completeBlock copy];
    [self showWithPoint:CGPointMake(0, toPoint.y + self.spaceVertical) targetView:targetView];
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
        SLCollectBaseView *collectionView = [[SLCollectBaseView alloc]initWithFrame:CGRectMake(0, 0, targetView.sl_width, targetView.sl_height-toPoint.y)];
        collectionView.manager = [[SLCollectManager alloc]initWithSections:self.collectDatas delegateHandler:nil];
        collectionView.manager.displayCell = self.displayCollectCell;
        [self addSubview:collectionView];
        [collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [collectionView setNeedsLayout];
            [collectionView layoutIfNeeded];
            collectionView.scrollEnabled = collectionView.contentSize.height > collectionView.sl_height;
            self.frame = CGRectMake(0, 0, targetView.sl_width,  targetView.sl_height-toPoint.y);
            collectionView.sl_height = MIN(collectionView.contentSize.height, collectionView.sl_height);
        });
    } else if (self.type == SLDropDownViewDisplayTable && self.tableDatas && self.tableDatas.count > 0) {
        SLTableView *tableView = [[SLTableView alloc]initWithFrame:CGRectMake(0, 0, targetView.sl_width, targetView.sl_height-toPoint.y) style:UITableViewStylePlain];
        tableView.manager = [[SLTableManager alloc]initWithSections:self.tableDatas.copy delegateHandler:nil];
        tableView.manager.displayCell = self.displayTableCell;
        [self addSubview:tableView];
        [tableView.manager reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView setNeedsLayout];
            [tableView layoutIfNeeded];
            tableView.scrollEnabled = tableView.contentSize.height > tableView.sl_height;
            self.frame = CGRectMake(0, 0, targetView.sl_width, MIN(tableView.contentSize.height, targetView.sl_height-toPoint.y));
            tableView.sl_height = MIN(tableView.contentSize.height, tableView.sl_height);
        });
    }
    self.backView.frame = targetView.bounds;
    self.containerView.frame = CGRectMake(0, toPoint.y, targetView.sl_width, targetView.sl_height-toPoint.y);
    
    self.backView.alpha = 0.f;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.alpha = 1.f;
    }];
}

@end
