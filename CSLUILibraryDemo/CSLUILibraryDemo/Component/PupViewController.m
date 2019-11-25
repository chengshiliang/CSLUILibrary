//
//  PupViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/6.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PupViewController.h"

@interface PupViewController()<SLCollectionViewProtocol>
{
    NSMutableArray *_colorAry;
}
@property (weak, nonatomic) IBOutlet SLPupView *pupView;
@end
@implementation PupViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _colorAry = [NSMutableArray array];
    [_colorAry addObject:[UIColor whiteColor]];
    [_colorAry addObject:[UIColor blackColor]];
    [_colorAry addObject:[UIColor blueColor]];
    [_colorAry addObject:[UIColor redColor]];
    [_colorAry addObject:[UIColor yellowColor]];
    [_colorAry addObject:[UIColor orangeColor]];
    [_colorAry addObject:[UIColor purpleColor]];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        SLPupModel *model = [SLPupModel new];
        model.width = 300;
        model.height = 50*(i+1);
        [arrM addObject:model];
    }
    self.pupView.dataSource = arrM.copy;
    self.pupView.delegate = self;
    self.pupView.columns = 4;
    self.pupView.columnMagrin = 5.0f;
    self.pupView.rowMagrin = 5.0f;
    [self.pupView reloadData];
}

static NSString *const cellId = @"kPupViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    [collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [_colorAry objectAtIndex:indexPath.row%_colorAry.count];
    return cell;
}
@end
