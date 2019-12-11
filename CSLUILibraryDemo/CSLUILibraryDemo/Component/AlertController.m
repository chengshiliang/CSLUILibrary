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
        SLAlertView *alert = [[SLAlertView alloc]init];
        SLLabel *titleLabel = alert.titleLabel;
        titleLabel.textColor = [UIColor redColor];
        alert.titleLabel = titleLabel;
        [alert addAlertWithType:AlertView title:@"title" message:@"message"];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert show];
    }];
    
    [self.onlyMessageAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]init];
        [alert addAlertWithType:AlertSheet title:@"title" message:@"message"];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            SLButton *button1 = [[SLButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
            [button1 setTitle:@"99+" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            [button1 addCornerRadius:10 borderWidth:0 borderColor:nil backGroundColor:[UIColor orangeColor]];
            [button setImage:[UIView sl_renderViewToImage:button1] forState:UIControlStateNormal];
            button.tabbarButtonType = SLButtonTypeImageRight;
            button.imageTitleSpace = 10.0;
        } callback:^{}];
        [alert show];
    }];
    
    [self.onlyTitleAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]init];
        [alert addAlertWithType:AlertView title:@"title" message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert show];
    }];
    
    [self.nothingAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]init];
        [alert addAlertWithType:AlertSheet title:nil message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert addActionWithTitle:@"第四选项" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [view addLoadingWithFillColor:nil strokeColor:nil loadingColor:nil lineWidth:0 duration:5 startAngle:-90];
            [button setImage:[UIView sl_renderViewToImage:[UIView copyView:view]] forState:UIControlStateNormal];
            button.tabbarButtonType = SLButtonTypeImageRight;
            button.imageTitleSpace = 10.0;
            [button.imageView addSubview:view];
        } callback:^{}];
        [alert show];
    }];
    
    [self.customViewAlert onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLAlertView *alert = [[SLAlertView alloc]init];
        [alert addAlertWithType:AlertView title:nil message:nil];
        [alert addActionWithTitle:@"取消" type:AlertActionCancel constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view1.backgroundColor = [UIColor redColor];
        [alert addCustomView:view1 alignment:AlertContentViewAlignmentLeft];
        [alert addActionWithTitle:@"其他" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view2.backgroundColor = [UIColor greenColor];
        [alert addCustomView:view2 alignment:AlertContentViewAlignmentRight];
        [alert addActionWithTitle:@"确认" type:AlertActionDefault constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 100)];
        view3.backgroundColor = [UIColor blueColor];
        [alert addCustomView:view3 alignment:AlertContentViewAlignmentCenter];
        [alert addActionWithTitle:@"第四选项" type:AlertActionDestructive constructAction:^(SLTabbarButton * _Nonnull button) {
            
        } callback:^{}];
        [alert show];
    }];
}

@end
