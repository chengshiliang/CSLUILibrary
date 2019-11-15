//
//  SearchViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/8.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (IBAction)goSearch:(id)sender {
//    __weak typeof (self)weakSelf = self;
    SLSearchController *vc = [SLSearchController initWithParentVC:self
                                                  searchResultVC:nil
                                                     selectBlock:^(SLSearchController *searchController, id data) {
                                                         NSLog(@"SELECT DATA%@",data);
                                                     }
                                               searchResultBlock:^NSArray * _Nonnull(SLSearchController *searchController, NSString *searchText) {
                                                   return @[@[@(1)],@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
                                               }];
//    vc.searchIcon = [UIImage imageNamed:@"cir3"];
//    vc.leftMargin = 16.0f;
//    vc.rightMargin = 16.0f;
//    vc.searchBarMargin = 10.0f;
//    vc.searchBarTextColor = [UIColor blackColor];
//    vc.searchBarPlaceHolder = @"";
//    vc.searchBarRadius = 5.0f;
//    vc.contentLeftMargin = 16.0f;
//    vc.contentRightMargin = 16.0f;
//    vc.cancelButtonTextColor = [UIColor blackColor];
//    vc.cancelButtonBackgroundColor = [UIColor clearColor];
//    vc.cancelButtonText = @"不干了";
//    vc.searchBarTextFont = [UIFont systemFontOfSize:14.0f];
//    vc.searchBarBackgroundColor = [UIColor clearColor];
//    vc.cancelButtonTextFont = [UIFont systemFontOfSize:17.0f];
//    vc.view.backgroundColor = [UIColor whiteColor];
    [vc show];
}

@end
