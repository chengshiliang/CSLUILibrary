//
//  ProgressViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/17.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ProgressViewController.h"

@interface ProgressViewController ()
@property (nonatomic, weak) IBOutlet SLProgressView *progressView;
@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.normalImage = [UIImage imageNamed:@"cir0.png"];
    self.progressView.trackerImage = [UIImage imageNamed:@"3.jpg"];
    [self.progressView setProgress:0 animated:YES];
    
    WeakSelf;
    [SLTimer sl_timerWithTimeInterval:1.0 target:self userInfo:nil repeats:YES mode:NSRunLoopCommonModes callback:^(NSArray * _Nonnull array) {
        StrongSelf;
        [strongSelf.progressView setProgress:strongSelf.progressView.currentProgress + 0.05 animated:YES];
    }];
}

@end
