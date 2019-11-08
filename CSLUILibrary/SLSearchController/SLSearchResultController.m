//
//  SLSearchResultController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLSearchResultController.h"
static NSString *SLSearchResultTableCellId = @"SLSearchResultTableCellId";
@implementation SLSearchResultController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SLSearchResultTableCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SLSearchResultTableCellId];
    }
    cell.textLabel.text = [self.filterDataArr[indexPath.row] description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBlock) self.selectBlock(indexPath);
}

#pragma mark - setter方法
- (void)setFilterDataArr:(NSArray *)filterDataArr {
    _filterDataArr = filterDataArr;
    [self.tableView reloadData];
    
}
@end
