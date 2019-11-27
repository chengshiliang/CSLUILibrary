//
//  NoRuleCollectionViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/26.
//  Copyright © 2019 csl. All rights reserved.
//

#import "NoRuleCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import "StaticCollectionViewController.h"

@interface NoRuleCollectionViewController ()<SLCollectionViewProtocol>
{
    NSArray *dataSource3;
}
@property (nonatomic, weak) IBOutlet SLNoRuleCollectionView *noRuleCollectionView;
@end

@implementation NoRuleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noRuleCollectionView.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        CGFloat width = 0;
        CGFloat height = 0;
        switch (i) {
            case 0:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.5;
            }
                break;
            case 1:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.25;
            }
                break;
            case 2:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 3:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 4:
            {
                width = kScreenWidth*0.75;
                height = kScreenWidth*0.25;
            }
                break;
            case 5:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            default:
                break;
        }
        pupModel.width = width;
        pupModel.height = height;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    dataSource3 = arrM.copy;
    self.noRuleCollectionView.dataSource = arrM.copy;
    self.noRuleCollectionView.delegate = self;
    self.noRuleCollectionView.columns = 4;
    self.noRuleCollectionView.columnMagrin = 5.0f;
    self.noRuleCollectionView.rowMagrin = 5.0f;
    [self.noRuleCollectionView reloadData];
}

static NSString *const cellId3 = @"kNoRuleCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
       [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId3];
   }
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId3 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource3[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        if (indexPath.row%3==0) {
            cell.backgroundColor = [UIColor redColor];
        } else if (indexPath.row%3==1) {
            cell.backgroundColor = [UIColor greenColor];
        } else if (indexPath.row%3==2) {
            cell.backgroundColor = [UIColor blueColor];
        }
        return cell;
   }
    return nil;
}

@end
