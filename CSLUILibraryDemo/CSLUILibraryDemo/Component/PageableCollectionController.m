//
//  PageableCollectionController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/13.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PageableCollectionController.h"

@interface  PageableModel: SLModel
@property (nonatomic, copy) NSString *title;
@end
@implementation PageableModel
@end
@interface PageableCollectionController ()
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, weak) IBOutlet SLPageableCollectionView *collectionView;
@end

@implementation PageableCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *arrM2 = [NSMutableArray array];
    for (int i = 0; i < 2; i ++) {
        NSMutableArray *arrM3 = [NSMutableArray array];
        for (int j = 0; j < 12; j ++) {
            SLPupModel *pupModel = [SLPupModel new];
            pupModel.width = 200;
            pupModel.height = 200;
            PageableModel *pageModel = [[PageableModel alloc]init];
            pageModel.title = [NSString stringWithFormat:@"%d---%d", i, j];
            pupModel.data = pageModel;
            [arrM3 addObject:pupModel];
        }
        [arrM2 addObject:arrM3.copy];
    }
    self.dataSource = arrM2.copy;
    self.collectionView.dataSource = arrM2.copy;
    self.collectionView.columns = 4;
    self.collectionView.columnMagrin = 5.0f;
    self.collectionView.rowMagrin = 5.0f;
    self.collectionView.insets = UIEdgeInsetsMake(20, 10, 20, 10);
    WeakSelf;
//    self.collectionView.cellConfig = ^SLCollectionViewCell * _Nonnull(NSInteger section, NSInteger row, SLCollectionViewCell * _Nonnull cell) {
//        StrongSelf;
//        SLLabel *label = [[SLLabel alloc]init];
//        NSArray *sectionArray = strongSelf.dataSource[section];
//        SLPupModel *pupModel = sectionArray[row];
//        PageableModel *model = (PageableModel *)pupModel.data;
//        if (![NSString emptyString:model.title]) {
//            CGSize size = [model.title sizeWithFont:label.font size:CGSizeMake(cell.sl_width, cell.sl_height)];
//            label.frame = CGRectMake(cell.sl_width/2.0-size.width/2.0, cell.sl_height/2.0-size.height/2.0, size.width, size.height);
//        } else {
//            label.frame = CGRectZero;
//        }
//        label.text = model.title;
//        [cell.contentView addSubview:label];
//        if (section == 0) {
//            cell.contentView.backgroundColor = [UIColor redColor];
//            label.backgroundColor = [UIColor blueColor];
//        } else {
//            cell.contentView.backgroundColor = [UIColor yellowColor];
//            label.backgroundColor = [UIColor blueColor];
//        }
//        return cell;
//    };
    [self.collectionView reload];
}

@end
