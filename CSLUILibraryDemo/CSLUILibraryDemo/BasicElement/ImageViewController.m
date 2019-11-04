//
//  ImageViewController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/1.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ImageViewController.h"
//#import "SLImageView.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet SLImageView *imageView1;
@property (weak, nonatomic) IBOutlet SLImageView *imageView2;
@property (weak, nonatomic) IBOutlet SLImageView *imageView3;
@property (weak, nonatomic) IBOutlet SLImageView *imageView4;
@property (weak, nonatomic) IBOutlet SLImageView *imageView5;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.imageView1 sl_corner:[UIImage imageNamed:@"3.jpg"] radis:10.];
    [self.imageView2 sl_scaleImage:[UIImage imageNamed:@"3.jpg"]];
//    [self.imageView3 sl_setAlphaForImage:[UIImage imageNamed:@"3.jpg"] alpha:0.2f];
    [self.imageView4 sl_imageBlackToTransparent:[UIImage imageNamed:@"3.jpg"] weight:0.5f];
//    [self.imageView5 sl_filterImage:[UIImage imageNamed:@"3.jpg"] filterName:@"CIPhotoEffectMono"];
}

@end
