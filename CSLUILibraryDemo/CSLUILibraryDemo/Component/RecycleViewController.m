//
//  RecycleViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RecycleViewController.h"

@implementation RecycleViewModel
@end
@interface RecycleViewController ()<SLCollectionViewProtocol>
{
    NSMutableArray *_colorAry;
}
@property (weak, nonatomic) IBOutlet SLRecycleCollectionView *scollView1;
@property (weak, nonatomic) IBOutlet SLRecycleCollectionView *scollView2;
@end

@implementation RecycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _colorAry = [NSMutableArray array];
    [_colorAry addObject:[UIColor blackColor]];
    [_colorAry addObject:[UIColor blueColor]];
    [_colorAry addObject:[UIColor redColor]];
    [_colorAry addObject:[UIColor yellowColor]];
    [_colorAry addObject:[UIColor orangeColor]];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.width = kScreenWidth-20;
        RecycleViewModel *model = [RecycleViewModel new];
        model.title = [NSString stringWithFormat:@"第%d个", i];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    self.scollView1.loop = YES;
    self.scollView1.dataSource = arrM.copy;
    self.scollView1.delegate = self;
    self.scollView1.minimumLineSpacing = 0;
    self.scollView1.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.scollView1.interval = 1.0;
    [self.scollView1.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId1];
//    [self.scollView1 reloadData];
    [arrM removeAllObjects];
    for (int i = 0; i < 5; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        pupModel.height = kScreenWidth*100.0/375;
        RecycleViewModel *model = [RecycleViewModel new];
        model.title = [NSString stringWithFormat:@"第%d个", i];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    self.scollView2.loop = YES;
    self.scollView2.dataSource = arrM.copy;
    self.scollView2.delegate = self;
    self.scollView2.manual = NO;
    self.scollView2.interval = 3.0;// 在step的情况下等于speed
    self.scollView2.minimumLineSpacing = 0;
    self.scollView2.scrollStyle = SLRecycleCollectionViewStyleStep;
    self.scollView2.hidePageControl = YES;
    self.scollView2.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.scollView2.collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId2];
    [self.scollView2 reloadData];
}

static NSString *const cellId1 = @"kRecycleViewCellID1";
static NSString *const cellId2 = @"kRecycleViewCellID2";

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isEqual:self.scollView1]) {
        SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId1 forIndexPath:indexPath];
        cell.backgroundColor = [_colorAry objectAtIndex:indexPath.row%_colorAry.count];
        return cell;
    }
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId2 forIndexPath:indexPath];
    cell.backgroundColor = [_colorAry objectAtIndex:indexPath.row%_colorAry.count];
    return cell;
}

@end
