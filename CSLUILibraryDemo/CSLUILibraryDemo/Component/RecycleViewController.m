//
//  RecycleViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RecycleViewController.h"

@interface RecycleViewModel : SLModel
@property (nonatomic, copy) NSString *title;
@end
@implementation RecycleViewModel
@end
@interface RecycleViewController ()<SLCollectionViewProtocol>
{
    NSMutableArray *_colorAry;
}
@property (nonatomic, strong) NSMutableArray *arrayM;
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
        pupModel.width = kScreenWidth;
        pupModel.height = kScreenWidth*100.0/375;
        RecycleViewModel *model = [RecycleViewModel new];
        model.title = [NSString stringWithFormat:@"第%d个", i];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    self.arrayM = arrM;
    self.scollView1.backgroundColor = [UIColor redColor];
    self.scollView1.loop = YES;
    self.scollView1.dataSource = arrM.copy;
    self.scollView1.layer.masksToBounds=YES;
    self.scollView1.delegate = self;
    self.scollView1.interval = 1.0;
    [self.scollView1 reloadData];
}

static NSString *const cellId = @"kRecycleViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    [collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [_colorAry objectAtIndex:indexPath.row%_colorAry.count];
    return cell;
}

@end
