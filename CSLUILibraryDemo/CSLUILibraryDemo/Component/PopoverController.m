//
//  PopoverController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/18.
//  Copyright © 2019 csl. All rights reserved.
//

#import "PopoverController.h"

@interface PopoverController ()

@end

@implementation PopoverController
- (IBAction)click:(UIButton *)sender {
    SLPopoverView *popoverView = [[SLPopoverView alloc]init];
    NSMutableArray *actions = [NSMutableArray array];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"3.jpg"] title:@"title1" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:nil title:@"title2" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir1.png"] title:@"title3" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:nil title:@"title4" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir3.png"] title:@"title5" handler:^(SLPopoverAction *action) {
        
    }]];
    popoverView.imageTitleSpace = 20;
    [popoverView showToView:sender withActions:[actions copy]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SLPopoverView *popoverView = [[SLPopoverView alloc]init];
    NSMutableArray *actions = [NSMutableArray array];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"3.jpg"] title:@"title1" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:nil title:@"title2" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir1.png"] title:@"title3" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:nil title:@"title4" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir3.png"] title:@"title5" handler:^(SLPopoverAction *action) {
        
    }]];
    popoverView.imageTitleSpace = 20;
    UITouch *touch = [touches anyObject];
    
    [popoverView showToPoint:[touch locationInView:[UIApplication sharedApplication].keyWindow] withActions:[actions copy]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([subView isKindOfClass:[SLPopoverView class]]) {
            SLPopoverView *view = (SLPopoverView *)subView;
            [view hide];
            break;
        }
    }
}
@end
