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
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:@"title" titleModel:nil titleLineModel:nil message:@"message" messageModel:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel lineModel:nil actionModel:nil callback:^{
            
        }];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive lineModel:nil actionModel:nil callback:^{

        }];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault lineModel:nil actionModel:nil callback:^{

        }];
        [alert show];
    }];
    
    [self.customViewAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        StrongSelf;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }]];
        
        [strongSelf presentViewController:alert animated:YES completion:nil];
    }];
}

@end
