//
//  ImageViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/1.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SLImageView *imageView1;
@property (weak, nonatomic) IBOutlet SLImageView *imageView2;
@property (weak, nonatomic) IBOutlet SLImageView *imageView3;
@property (weak, nonatomic) IBOutlet SLImageView *imageView4;
@property (weak, nonatomic) IBOutlet SLImageView *imageView5;
@property (weak, nonatomic) IBOutlet SLImageView *imageView6;
@property (weak, nonatomic) IBOutlet SLScrollView *scrollView;
@property (weak, nonatomic) IBOutlet SLImageView *netImageView;
@end

@implementation ImageViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof (self) weakSelf = self;
    [[SLImageDownLoader share] downloadImage:@"http://img.hb.aicdn.com/0f608994c82c2efce030741f233b29b9ba243db81ddac-RSdX35_fw658" complete:^(UIImage * _Nonnull image, NSURL * _Nonnull imageUrl, CGFloat progress, BOOL finished, NSError * _Nonnull error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (!error) {
            if (finished) {
                [strongSelf.netImageView decodeImage:image toSize:CGSizeMake(kScreenWidth, kScreenWidth* image.size.height/image.size.width)];
            } else {
                NSLog(@"图片下载进度%.2lf", progress);
            }
        }
    }];
    [self.imageView1 sl_setImage:[UIImage imageNamed:@"3.jpg"]];
    [self.imageView2 sl_scaleImage:[UIImage imageNamed:@"3.jpg"]];
    [self.imageView3 sl_setAlphaForImage:[UIImage imageNamed:@"3.jpg"] alpha:0.8f];
    [self.imageView4 sl_imageBlackToTransparent:[UIImage imageNamed:@"3.jpg"] weight:0.5f];
    [self.imageView5 sl_setImage:[UIImage imageNamed:@"3.jpg"]];
    [self.imageView5 addCorner:YES];
    [self.imageView6 sl_blurEffect];
    [self.imageView6 sl_setImage:[UIImage imageNamed:@"3.jpg"]];
    [self.imageView1 addLoadingWithFillColor:[UIColor blueColor] strokeColor:[UIColor redColor] loadingColor:[UIColor greenColor] lineWidth:5];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SLImageDownLoader share] cancelAllDownLoad];
}

@end
