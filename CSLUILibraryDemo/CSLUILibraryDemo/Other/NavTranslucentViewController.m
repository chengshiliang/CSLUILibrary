//
//  NavTranslucentViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/21.
//  Copyright © 2019 csl. All rights reserved.
//

#import "NavTranslucentViewController.h"

@interface NavTranslucentViewController ()
@property (weak, nonatomic) IBOutlet SLScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SLImageView *imageView;
@end

@implementation NavTranslucentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView sl_setImage:[UIImage imageNamed:@"cir0"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sl_scrollToNoTranslucent];
    [self scrollViewDidScroll:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat alpha = 1.0;
    if (scrollView.contentOffset.y > -scrollView.sl_insetTop) {
        CGFloat offset = scrollView.contentOffset.y+scrollView.sl_insetTop;
        CGFloat temp = offset * 1 / scrollView.sl_insetTop;
        alpha = MIN(1, temp);
        NSLog(@"%lf=---%lf", alpha, temp);
//        alpha = 1-alpha;
    }
    
    [self sl_scrollToTranslucentWithAlpha:alpha];
}

@end
