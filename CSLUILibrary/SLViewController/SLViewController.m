//
//  SLViewController.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLViewController.h"

@interface SLViewController ()

@end

@implementation SLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;// 设置self.view不占据nav块内容
    self.edgesForExtendedLayout = UIRectEdgeNone;// 设置self.view不占据nav块内容
}

@end
