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
@property (nonatomic, weak) IBOutlet SLButton *customViewAlert;// 自定义内容块的视图内容 如imageview、uitextfield
@end

@implementation AlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.normalAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:@"title" message:@"message"];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel callback:^{}];
        [alert show];
    }];
    
    [self.onlyMessageAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:nil message:@"message"];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive callback:^{}];
        [alert show];
    }];
    
    [self.onlyTitleAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:@"title" message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive callback:^{}];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault callback:^{}];
        [alert show];
    }];
    
    [self.nothingAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:nil message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive callback:^{}];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault callback:^{}];
        [alert addActionWithTitle:@"第四选项" type:AlertActionDestructive callback:^{}];
        [alert show];
    }];
    
    [self.customViewAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]initWithType:AlertView title:nil message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel callback:^{}];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view1.backgroundColor = [UIColor redColor];
        [alert addCustomView:view1 alignment:AlertContentViewAlignmentLeft];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive callback:^{}];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view2.backgroundColor = [UIColor greenColor];
        [alert addCustomView:view2 alignment:AlertContentViewAlignmentRight];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault callback:^{}];
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view3.backgroundColor = [UIColor blueColor];
        [alert addCustomView:view3 alignment:AlertContentViewAlignmentCenter];
        [alert addActionWithTitle:@"第四选项" type:AlertActionDestructive callback:^{}];
        [alert show];
    }];
}

@end
