//
//  BaseNavigationController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/4.
//  Copyright © 2019 csl. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sl_setBackImage:[UIImage imageNamed:@"icon_back"]];
    [self sl_setTransluentNavBar];
}
@end
