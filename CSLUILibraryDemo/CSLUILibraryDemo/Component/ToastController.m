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
    [self.toastWithNothing onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:nil title:nil image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
    }];
    
    [self.toast onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
//        [SLToast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonTop];
//        [SLToast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonBottom];
//        [SLToast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonLeft];
        [SLToast makeToast:@"message" title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonTop imagePosition:SLToastImagePositonRight];
    }];
    
    [self.toastOnlyTitle onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:nil title:@"title" image:nil duration:2.0f position:SLToastPositonBottom];
    }];
    
    [self.toastOnlyMessage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:@"message" title:nil image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonTop];
    }];
    
    [self.toastOnlyImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonBottom];
//        [SLToast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
//        [SLToast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonRight];
//        [SLToast makeToast:nil title:nil image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonTop];
    }];
    
    [self.toastTitleAndMessage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:@"message" title:@"title" image:nil duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft];
    }];
    
    [self.toastTitleAndImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        [SLToast makeToast:nil title:@"title" image:[UIImage imageNamed:@"3.jpg"] duration:2.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonRight];
    }];
    
    [self.toastMessageAndImage onEventChange:self event:UIControlEventTouchUpInside change:^(UIControl * _Nonnull control) {
        SLToastStyle *style = [SLUIConfig share].toastStyle;
        style.superContentView = (SLView *)self.view;
        SLToast *toast = [SLToast makeToast:@"message" title:nil image:[UIImage imageNamed:@"3.jpg"] duration:.0f position:SLToastPositonMiddle imagePosition:SLToastImagePositonLeft style:style];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [toast hideToast];
        });
    }];
}

@end
