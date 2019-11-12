//
//  LabelController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "LabelController.h"
//#import "SLLabel.h"

@interface LabelController ()
@property (weak, nonatomic) IBOutlet SLLabel *h1;
@property (weak, nonatomic) IBOutlet SLLabel *h2;
@property (weak, nonatomic) IBOutlet SLLabel *h3;
@property (weak, nonatomic) IBOutlet SLLabel *h4;
@property (weak, nonatomic) IBOutlet SLLabel *h5;
@property (weak, nonatomic) IBOutlet SLLabel *h6;
@property (weak, nonatomic) IBOutlet SLLabel *bold;
@property (weak, nonatomic) IBOutlet SLLabel *normal;
@property (weak, nonatomic) IBOutlet SLLabel *select;
@property (weak, nonatomic) IBOutlet SLLabel *disable;
@property (weak, nonatomic) IBOutlet SLCoreText *coreText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coreTextHeight;

@end

@implementation LabelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.h1.labelType = LabelH1;
    
    self.h2.labelType = LabelH2;
    
    self.h3.labelType = LabelH3;
    
    self.h4.labelType = LabelH4;
    
    self.h5.labelType = LabelH5;
    
    self.h6.labelType = LabelH6;
    
    self.bold.labelType = LabelBold;
    
    self.normal.labelType = LabelNormal;
    
    self.select.labelType = LabelSelect;
    
    self.disable.labelType = LabelDisabel;

    [self.coreText addAttributeString:@"\ntest\r\n" font:[UIFont systemFontOfSize:14.0] color:[UIColor redColor] click:^(NSString * _Nonnull string) {
        NSLog(@"STRING%@",string);
    }];
    [self.coreText addAttributeString:@"te\r\nst1\r" font:[UIFont boldSystemFontOfSize:18] color:[UIColor greenColor] attributes:nil click:^(NSString * _Nonnull string) {
        NSLog(@"STRING333%@",string);
    }];
    [self.coreText addAttributeImage:[UIImage imageNamed:@"3.jpg"] width:100 height:100 click:^(UIImage * _Nonnull image) {
        NSLog(@"IMAGE%@",image);
    }];
    [self.coreText addAttributeString:@"\r\nhttps://www.baidu.com" font:[UIFont boldSystemFontOfSize:18] color:[UIColor greenColor] attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} click:^(NSString * _Nonnull string) {
        NSLog(@"STRING222%@",string);
    }];
    __weak typeof (self)weakSelf = self;
    self.coreText.lineHeightChange = ^(double lineHeight) {
        __strong typeof (weakSelf)strongSelf = weakSelf;
        strongSelf.coreTextHeight.constant = lineHeight;
    };
//    [self.coreText reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

@end
