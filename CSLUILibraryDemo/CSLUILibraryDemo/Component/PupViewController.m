//
//  PupViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/6.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PupViewController.h"

@interface PupViewController()<SLPupViewDelegate>
{
    NSMutableArray *_colorAry;
}
@property (weak, nonatomic) IBOutlet SLPupView *pupView;
@property (nonatomic, copy) NSArray *dataSource;
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
        NSError *error;
        SLModel *country = [[SLModel alloc] initWithDictionary: @{@"imageUrl": [NSString stringWithFormat:@"cir%d", i%4]} error:&error];
        model.data = country;
        [arrM addObject:model];
    }
    self.dataSource = arrM.copy;
    self.pupView.dataSource = self.dataSource;
    self.pupView.delegate = self;
    self.pupView.columns = 4;
    self.pupView.columnMagrin = 5.0f;
    self.pupView.rowMagrin = 5.0f;
    [self.pupView reloadData];
}

- (void)registerCell:(SLCollectionView *)collectionView {
    [collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:@"xxxxx"];
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xxxxx" forIndexPath:indexPath];
    cell.backgroundColor = [_colorAry objectAtIndex:indexPath.row%_colorAry.count];
    return cell;
}
@end
