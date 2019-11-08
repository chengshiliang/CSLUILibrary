//
//  SLSearchContentController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLSearchContentController.h"
#import <CSLUILibrary/SLUtil.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/UIView+SLBase.h>
#import "UIControl+Events.h"
@interface SLSearchContentController()
{
    BOOL isPresented;
    UIImage *_image;
};
@end
@implementation SLSearchContentController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin image:(nonnull UIImage *)image{
    self = [super init];
    if (searchResultsController) {
        _image = image;
        self.searchResultsController = searchResultsController;
        CGFloat y = 64.f;
        if ([SLUtil bangsScreen]) {
            y = 88.f;
        }
        self.view.frame = CGRectMake(leftMargin, y, kScreenWidth-leftMargin-rightMargin, kScreenHeight-y);
        
        //我需要把resultController添加到self上来
        [self addChildViewController:searchResultsController];
        searchResultsController.view.frame = self.view.bounds;
        [self.view addSubview:searchResultsController.view];
    }
    return self;
}

- (void)textChanged {  //监听searchBar里面文字的改变
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentSearchController:)] && self.searchBar.text.length >= 1 && !isPresented) {
        [self.delegate didPresentSearchController:self];
        isPresented = YES;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissSearchController:)] && self.searchBar.text.length == 0) {
        [self.delegate didDismissSearchController:self];
        isPresented = NO;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(updateSearchResultsForSearchController:)]) {
        [self.delegate updateSearchResultsForSearchController:self];
    }
}


#pragma mark - getter method
- (SLSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[SLSearchBar alloc] initWithImage:_image ? _image : [UIImage imageNamed:@"SLSearchBarIcon"]];
        WeakSelf;
        [_searchBar onEventChange:self event:UIControlEventEditingChanged change:^(UIControl *control) {
            if ([control isKindOfClass:[SLSearchBar class]]) {
                StrongSelf;
                [strongSelf textChanged];
            }
        }];
    }
    return _searchBar;
}
@end
