//
//  SLSearchController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLSearchController.h"
#import <CSLUILibrary/SLButton.h>
#import <CSLCommonLibrary/SLUtil.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLCommonLibrary/UIView+SLBase.h>
#import <CSLCommonLibrary/NSString+Util.h>
#import <CSLUILibrary/SLSearchContentController.h>
#import <CSLUILibrary/SLSearchResultController.h>
#import <CSLCommonLibrary/UIControl+Events.h>
#import <CSLCommonLibrary/CSLDelegateProxy.h>

@interface SLSearchController()
@property (nonatomic, copy) void(^selectBlock)(SLSearchController *vc,id data);
@property (nonatomic, copy) NSArray *(^searchResultBlock)(SLSearchController *vc, NSString *str);
@property (nonatomic, strong) SLButton *cancelButton;
@property (nonatomic, strong) UIViewController *resultVC;
@property (nonatomic, strong)SLSearchContentController *searchController;
@property (nonatomic, weak)UIViewController *parentVC;
@end

@implementation SLSearchController
+ (instancetype)initWithParentVC:(UIViewController *)parentvc
                  searchResultVC:(UIViewController *_Nullable)resultVC
                     selectBlock:(void(^)(SLSearchController *vc,id data))selectBlock
               searchResultBlock:(NSArray *(^ _Nullable)(SLSearchController *vc, NSString *str))searchResultBlock {
   return [[self alloc]initWithParentVC:parentvc
                   searchResultVC:resultVC
                      selectBlock:selectBlock
                searchResultBlock:searchResultBlock];
}
- (instancetype)init {
    return [self initWithParentVC:nil searchResultVC:nil selectBlock:nil searchResultBlock:nil];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithParentVC:nil searchResultVC:nil selectBlock:nil searchResultBlock:nil];
}
- (instancetype)initWithParentVC:(UIViewController *)parentvc
                  searchResultVC:(UIViewController *_Nullable)resultVC
                     selectBlock:(void(^)(SLSearchController *vc,id data))selectBlock
               searchResultBlock:(NSArray *(^)(SLSearchController *vc, NSString *str))searchResultBlock {
    if (self == [super init]) {
        if (!parentvc) return nil;
        self.leftMargin = 16.0f;
        self.rightMargin = 16.0f;
        self.searchBarMargin = 10.0f;
        self.searchBarTextColor = SLUIHexColor(0x000000);
        self.searchBarPlaceHolder = @"请输入想搜索的内容";
        self.searchBarRadius = 5.0f;
        self.contentLeftMargin = 16.0f;
        self.contentRightMargin = 16.0f;
        self.cancelButtonTextColor = SLUIHexColor(0x000000);
        self.cancelButtonText = @"取消";
        self.searchBarTextFont = SLUINormalFont(17.0f);
        self.cancelButtonTextFont = SLUINormalFont(14.0f);
        self.searchBarBorderWidth = 1.0f;
        self.searchBarBorderColor = SLUIHexColor(0xe0e0e0);
        self.parentVC = parentvc;
        if (resultVC) {
            self.resultVC = resultVC;
        } else {
            WeakSelf;
            SLSearchResultController *resultController = [[SLSearchResultController alloc] init];
            resultController.selectBlock = ^(NSIndexPath * _Nonnull indexPath) {
                StrongSelf;
                if (selectBlock) selectBlock(strongSelf,indexPath);
                [strongSelf dismiss];
            };
            self.resultVC = resultController;
        }
        self.searchResultBlock = searchResultBlock;
    }
    return self;
}

- (void)dismiss {
    [self.searchController.view removeFromSuperview];
    [self.searchController removeFromParentViewController];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    if (self.parentVC && ![self.parentVC presentedViewController]) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}

- (void)show {
    if (![self.parentVC presentedViewController]) {
        self.parentVC.navigationController.navigationBarHidden = YES;
    }
    [self.parentVC addChildViewController:self];
    [self.parentVC.view addSubview:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat y = 20.f;
    if ([SLUtil bangsScreen]) {
        y = 44.f;
    }
    CGFloat cancelButtonW = MIN(60, [self.cancelButtonText widthWithFont:self.cancelButtonTextFont height:30.0f]);
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.sl_width, 44.f)];
    [self.view addSubview:navView];
    self.cancelButton = [SLButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    self.cancelButton.titleLabel.font = self.cancelButtonTextFont;
    self.cancelButton.layer.cornerRadius = self.cancelButtonRadius;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.borderWidth = self.cancelButtonBorderWidth;
    self.cancelButton.layer.borderColor = self.cancelButtonBorderColor.CGColor;
    [self.cancelButton setTitle:self.cancelButtonText forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelButtonTextColor forState:UIControlStateNormal];
    self.cancelButton.frame = CGRectMake(kScreenWidth-self.rightMargin-cancelButtonW, 7.f, cancelButtonW, 30.f);
    WeakSelf;
    [self.cancelButton onTouch:self event:UIControlEventTouchUpInside change:^(UIControl * control) {
        StrongSelf;
        if ([control isKindOfClass:[SLButton class]]) {
            [strongSelf dismiss];
        }
    }];
    [navView addSubview:self.cancelButton];
    self.cancelButton.hidden = YES;
    self.searchController.searchBar.frame = CGRectMake(self.leftMargin+30, 8.f, kScreenWidth-self.rightMargin-cancelButtonW-self.searchBarMargin-self.leftMargin, 28.f);
    [navView addSubview:self.searchController.searchBar];
    self.searchController.searchBar.textColor = self.searchBarTextColor;
    self.searchController.searchBar.font = self.searchBarTextFont;
    self.searchController.searchBar.placeholder = self.searchBarPlaceHolder;
    self.searchController.searchBar.text = self.searchBarDefaultValue;
    self.searchController.searchBar.backgroundColor = self.searchBarBackgroundColor;
    self.searchController.searchBar.layer.cornerRadius = self.searchBarRadius;
    self.searchController.searchBar.layer.masksToBounds = YES;
    self.searchController.searchBar.layer.borderWidth = self.searchBarBorderWidth;
    self.searchController.searchBar.layer.borderColor = self.searchBarBorderColor.CGColor;
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.2f animations:^{
        self.searchController.searchBar.sl_x = self.leftMargin;
    } completion:^(BOOL finished) {
        self.cancelButton.hidden = NO;
    }];
}

- (SLSearchContentController *)searchController {
    if (!_searchController) {
        _searchController = [[SLSearchContentController alloc] initWithSearchResultsController:self.resultVC leftMargin:self.contentLeftMargin rightMargin:self.contentRightMargin image:self.searchIcon];
        CSLDelegateProxy *delegateProxy = [[CSLDelegateProxy alloc]initWithDelegateProxy:@protocol(SLSearchContentControllerDelegate)];
        WeakSelf;
        [delegateProxy addSelector:@selector(didPresentSearchController:) callback:^(NSArray *params) {
            if (params && params.count == 1) {
                StrongSelf;
                [strongSelf addChildViewController:strongSelf.searchController];
                [strongSelf.view addSubview:strongSelf.searchController.view];
            }
        }];
        [delegateProxy addSelector:@selector(didDismissSearchController:) callback:^(NSArray *params) {
            if (params && params.count == 1) {
                StrongSelf;
                [strongSelf.searchController.view removeFromSuperview];
                [strongSelf.searchController removeFromParentViewController];
            }
        }];
        [delegateProxy addSelector:@selector(updateSearchResultsForSearchController:) callback:^(NSArray *params) {
            if (params && params.count == 1) {
                StrongSelf;
                NSString *searchText = strongSelf.searchController.searchBar.text;
                if (strongSelf.searchResultBlock) {
                    NSArray *filterDataArr = strongSelf.searchResultBlock(strongSelf, searchText);
                    if ([strongSelf.searchController.searchResultsController isKindOfClass:[SLSearchResultController class]]) {
                        SLSearchResultController *resultController = (SLSearchResultController *)strongSelf.searchController.searchResultsController;
                        resultController.filterDataArr = filterDataArr;
                    }
                }
            }
        }];
        _searchController.delegate = (id<SLSearchContentControllerDelegate>)delegateProxy;
    }
    return _searchController;
}
@end
