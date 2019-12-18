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
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir0.png"] title:@"title2" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir1.png"] title:@"title3" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir2.png"] title:@"title4" handler:^(SLPopoverAction *action) {
        
    }]];
    [actions addObject:[SLPopoverAction actionWithImage:[UIImage imageNamed:@"cir3.png"] title:@"title5" handler:^(SLPopoverAction *action) {
        
    }]];
    popoverView.imageTitleSpace = 20;
    [popoverView showToView:sender withActions:[actions copy]];
}


@end
