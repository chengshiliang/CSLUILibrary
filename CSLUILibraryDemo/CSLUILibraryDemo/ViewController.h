//
//  ViewController.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTableView;
@protocol MyTableViewDelegate <NSObject>
- (void)didSelect:(MyTableView *)tableView indexPath:(NSIndexPath *)indexpath;
@end
@interface MyTableView : SLTableView
@property (nonatomic, strong) id<MyTableViewDelegate> tableDelegate;
@end
@interface MyTableModel: SLModel
@property (nonatomic, copy) NSString *key;
@end
@interface ViewController : SLViewController


@end

