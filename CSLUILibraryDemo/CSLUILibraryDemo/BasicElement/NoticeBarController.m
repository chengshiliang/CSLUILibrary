//
//  NoticeBarController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/16.
//  Copyright © 2019 csl. All rights reserved.
//

#import "NoticeBarController.h"

@interface NoticeBarController ()
@property (nonatomic, weak) IBOutlet SLNoticeBar *noticeBar;
@end

@implementation NoticeBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.noticeBar.content = @"开始轮播 dsfoijsfdkqwejiofc ndjcnwocnvefiodnviowedcmoksdnvojqewncov fdncjodnvcowenfcioenfiowencioefnefefqewjfhuweidsncklwdnc 结束轮播";
    self.noticeBar.leftImage = [UIImage imageNamed:@"3.jpg"];
    SLView *view = [[SLView alloc]initWithFrame:CGRectMake(0, 0, 40, self.noticeBar.sl_height)];
    self.noticeBar.rightView = view;
    [self.noticeBar show];
}

@end
