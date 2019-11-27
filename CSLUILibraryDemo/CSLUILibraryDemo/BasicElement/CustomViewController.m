//
//  CustomViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/26.
//  Copyright © 2019 csl. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()
@property (nonatomic, weak) IBOutlet SLView *cornerRadiusAndShadowView;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.cornerRadiusAndShadowView addCornerRadius:10.0f
                                        shadowColor:[UIColor redColor]
                                       shadowOffset:CGSizeMake(5,-5)
                                      shadowOpacity:0.5
                                       shadowRadius:5.0];
}

@end
