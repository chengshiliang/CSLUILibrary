//
//  SLSearchContentController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLViewController.h"
#import <CSLUILibrary/SLSearchBar.h>

NS_ASSUME_NONNULL_BEGIN

@class SLSearchContentController;

@protocol SLSearchContentControllerDelegate <NSObject>

- (void)didPresentSearchController:(SLSearchContentController *)searchController;
- (void)didDismissSearchController:(SLSearchContentController *)searchController;
- (void)updateSearchResultsForSearchController:(SLSearchContentController *)searchController;
@end

@interface SLSearchContentController : SLViewController

//搜索框
@property(nonatomic, strong)SLSearchBar *searchBar;
@property(nonatomic, strong)UIViewController *searchResultsController;
@property(nonatomic, strong)id<SLSearchContentControllerDelegate>delegate;

//方法
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin image:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
