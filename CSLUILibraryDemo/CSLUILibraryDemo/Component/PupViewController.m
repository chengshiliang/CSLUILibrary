//
//  PupViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/6.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PupViewController.h"
#import <CSLUILibrary/SLPupView.h>
#import <CSLUILibrary/SLPupModel.h>
#import "CustomPupModel.h"

@interface PupViewController()<SLPupViewDelegate>
@property (weak, nonatomic) IBOutlet SLPupView *pupView;
@property (nonatomic, copy) NSArray *dataSource;
@end
@implementation PupViewController
- (void)viewDidLoad {
    NSLog(@"HERE");
    [super viewDidLoad];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 30; i ++) {
        SLPupModel *model = [SLPupModel new];
        model.width = 300;
        model.height = 500*(i+1);
        NSError *error;
        SLModel *country = [[SLModel alloc] initWithDictionary: @{@"imageUrl": [NSString stringWithFormat:@"cir%d", i%4]} error:&error];
        model.data = country;
        [arrM addObject:model];
    }
    self.dataSource = arrM.copy;
    self.pupView.dataSource = self.dataSource;
    self.pupView.delegate = self;
    [self.pupView reloadData];
}

- (void)registerCell:(SLCollectionView *)collectionView {
    [collectionView registerClass:[SLCollectionViewCell class] forCellWithReuseIdentifier:@"xxxxx"];
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xxxxx" forIndexPath:indexPath];
    SLPupModel *model = self.dataSource[indexPath.row];
    cell.model = model.data;
    return cell;
}
@end
