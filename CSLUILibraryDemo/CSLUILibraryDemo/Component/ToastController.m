//
//  ToastController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/9.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ToastController.h"

@interface ToastController ()
@property (nonatomic, weak) IBOutlet SLButton *toast;
@property (nonatomic, weak) IBOutlet SLButton *toastWithNothing;
@property (nonatomic, weak) IBOutlet SLButton *toastOnlyTitle;
@property (nonatomic, weak) IBOutlet SLButton *toastOnlyMessage;
@property (nonatomic, weak) IBOutlet SLButton *toastOnlyImage;
@property (nonatomic, weak) IBOutlet SLButton *toastTitleAndMessage;
@property (nonatomic, weak) IBOutlet SLButton *toastTitleAndImage;
@property (nonatomic, weak) IBOutlet SLButton *toastMessageAndImage;
@end

@implementation ToastController

- (void)viewDidLoad {
    [super viewDidLoad];
    SLToast *toast = [SLToast new];
    [self.toastWithNothing onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:nil title:nil image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
    }];
    
    [self.toast onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
//        [toast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonTop];
//        [toast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonBottom];
//        [toast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonLeft];
        [toast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonRight];
    }];
    
    [self.toastOnlyTitle onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:nil title:@"title" image:nil duration:2.0f position:SLToastPositonBottom];
    }];
    
    [self.toastOnlyMessage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:@"message" title:nil image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonTop];
    }];
    
    [self.toastOnlyImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonBottom];
//        [toast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
//        [toast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonRight];
//        [toast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonTop];
    }];
    
    [self.toastTitleAndMessage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:@"message" title:@"title" image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
    }];
    
    [self.toastTitleAndImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [toast makeToast:nil title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonRight];
    }];
    
    [self.toastMessageAndImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLToastStyle *style = [SLToastConfig share].toastStyle;
        style.superContentView = (SLView *)self.view;
        style.imageSize = CGSizeMake(30, 30);
        style.titleLabel.textAlignment = NSTextAlignmentLeft;
        style.messageLabel.textAlignment = NSTextAlignmentLeft;
        style.width = 150;
        [toast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft style:style];
    }];
}

@end
