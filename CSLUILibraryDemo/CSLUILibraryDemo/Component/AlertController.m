//
//  AlertController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/4.
//  Copyright © 2019 csl. All rights reserved.
//

#import "AlertController.h"

@interface AlertController ()
@property (nonatomic, weak) IBOutlet SLButton *normalAlert;
@property (nonatomic, weak) IBOutlet SLButton *onlyMessageAlert;
@property (nonatomic, weak) IBOutlet SLButton *onlyTitleAlert;
@property (nonatomic, weak) IBOutlet SLButton *nothingAlert;
@property (nonatomic, weak) IBOutlet SLButton *customViewAlert;
@end

@implementation AlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf;
    [self.normalAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        StrongSelf;
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:@"title" titleModel:nil titleLineModel:nil message:@"message" messageModel:nil];
        [alert show];
    }];
}

@end
