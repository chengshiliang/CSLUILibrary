//
//  SLCollectManager.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLCollectManager.h"
#import <CSLUILibrary/SLCollectBaseView.h>

@implementation SLCollectManager
- (id)initWithSections:(NSArray<id<SLCollectSectionProtocol>> *)sections delegateHandler:(SLCollectProxy *)handler{
    self = [super init];
    if (self) {
        //保存数据源
        _sections = sections.mutableCopy;
        //设置代理
        if (!handler) {
            _delegateHandler = [[SLCollectProxy alloc]init];
        } else {
            _delegateHandler = handler;
        }
        _delegateHandler.collectManager = self;
        self.cellClasses = [NSMutableDictionary dictionary];
        self.cellNibs = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)bindToCollectView:(SLCollectBaseView *)collectView{
    collectView.delegate = self.delegateHandler;
    collectView.dataSource = self.delegateHandler;
    self.collectView = collectView;
}

- (id<SLCollectRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(indexPath.section < self.sections.count, @"数组越界");
    id<SLCollectSectionProtocol> section = self.sections[indexPath.section];
    if (indexPath.row < section.rows.count) {
        return section.rows[indexPath.row];
    }
    return nil;
}

- (void)reloadData{
    NSAssert(self.collectView != nil, @"collectView is nil");
    if ([NSThread isMainThread]) {
        [self.collectView reloadData];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectView reloadData];
        });
    }
}

- (void)dealloc {
    [self.cellClasses removeAllObjects];
    [self.cellNibs removeAllObjects];
}
@end
