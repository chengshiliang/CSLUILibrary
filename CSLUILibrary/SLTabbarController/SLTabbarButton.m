//
//  SLTabbarButton.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/4.
//

#import "SLTabbarButton.h"

@interface SLTabbarButton()
{
    CGRect _imageReact;
    CGRect _titleReact;
}
@end

@implementation SLTabbarButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return _titleReact;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if ((self.imageSize.width > 0 || self.imageSize.height > 0) && self.tabbarButtonType != SLButtonTypeOnlyTitle) {
        NSLog(@"imageSize111%@", NSStringFromCGSize(self.imageSize));
        CGFloat imageW = self.imageSize.width;
        CGFloat imageH = self.imageSize.height;
        if (self.tabbarButtonType == SLButtonTypeOnlyImage) {// 只有图片显示
            _titleReact = CGRectZero;
            //内容总高度
            CGFloat totalHeight = imageH;
            CGFloat imageY = (contentRect.size.height - totalHeight)/2.0;
            CGFloat imageX = (contentRect.size.width - imageW)/2.0;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            return _imageReact;
        } else if (self.tabbarButtonType == SLButtonTypeImageLeft) {
            CGSize titleSize = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            //内容总宽度
            CGFloat totalWidth = titleSize.width + imageW + self.imageTitleSpace;
            CGFloat imageY = (contentRect.size.height - imageH)/2.0;
            CGFloat imageX = (contentRect.size.width - totalWidth)/2.0;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            
            CGFloat titleX = imageX + imageW + self.imageTitleSpace;
            CGFloat titleY = (contentRect.size.height - titleSize.height)/2.0;
            CGFloat titleW = titleSize.width;
            CGFloat titleH = titleSize.height;
            _titleReact = CGRectMake(titleX, titleY, titleW, titleH);
            return _imageReact;
        } else if (self.tabbarButtonType == SLButtonTypeImageTop) {
            CGSize titleSize = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            //内容总高度
            CGFloat totalHeight = titleSize.height + imageH + self.imageTitleSpace;
            CGFloat imageY = (contentRect.size.height - totalHeight)/2.0;
            CGFloat imageX = (contentRect.size.width - imageW)/2.0;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            
            CGFloat titleX = (contentRect.size.width - titleSize.width)/2.0;
            CGFloat titleY = imageY + imageH + self.imageTitleSpace;
            CGFloat titleW = titleSize.width;
            CGFloat titleH = titleSize.height;
            _titleReact = CGRectMake(titleX, titleY, titleW, titleH);
            return _imageReact;
        } else if (self.tabbarButtonType == SLButtonTypeImageRight) {
            CGSize titleSize = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            //内容总宽度
            CGFloat totalWidth = titleSize.width + imageW + self.imageTitleSpace;
            CGFloat imageY = (contentRect.size.height - imageH)/2.0;
            CGFloat imageX = (contentRect.size.width - totalWidth)/2.0 + titleSize.width + self.imageTitleSpace;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            
            CGFloat titleX = (contentRect.size.width - totalWidth)/2.0;
            CGFloat titleY = (contentRect.size.height - titleSize.height)/2.0;
            CGFloat titleW = titleSize.width;
            CGFloat titleH = titleSize.height;
            _titleReact = CGRectMake(titleX, titleY, titleW, titleH);
            return _imageReact;
        } else {
            CGSize titleSize = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            //内容总高度
            CGFloat totalHeight = titleSize.height + imageH + self.imageTitleSpace;
            CGFloat imageY = (contentRect.size.height - totalHeight)/2.0 + titleSize.height + self.imageTitleSpace;
            CGFloat imageX = (contentRect.size.width - imageW)/2.0;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            
            CGFloat titleX = (contentRect.size.width - titleSize.width)/2.0;
            CGFloat titleY = (contentRect.size.height - totalHeight)/2.0;
            CGFloat titleW = titleSize.width;
            CGFloat titleH = titleSize.height;
            _titleReact = CGRectMake(titleX, titleY, titleW, titleH);
            return _imageReact;
        }
    } else {
        NSLog(@"imageSize222%@", NSStringFromCGSize(self.imageSize));
        if (self.tabbarButtonType == SLButtonTypeOnlyTitle) {
            CGSize titleSize = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            CGFloat titleX = (contentRect.size.width - titleSize.width)/2.0;
            CGFloat titleY = (contentRect.size.height - titleSize.height)/2.0;
            CGFloat titleW = titleSize.width;
            CGFloat titleH = titleSize.height;
            _titleReact = CGRectMake(titleX, titleY, titleW, titleH);
            _imageReact = CGRectZero;
            return _imageReact;
        }
        _titleReact = CGRectZero;
        return [super imageRectForContentRect:contentRect];
    }
}

- (void)layoutSubviews {
    UIImage *image = self.currentImage;
    if (self.imageSize.width <= 0 && self.imageSize.height <= 0) {
        self.imageSize = CGSizeMake(image.size.width > self.frame.size.width ? self.frame.size.width : image.size.width,
                                    image.size.width > self.frame.size.height ? self.frame.size.height : image.size.height);
    }
    NSLog(@"imageSize%@~~~~~%ld", NSStringFromCGSize(self.imageSize), self.tabbarButtonType);
    [super layoutSubviews];
}
@end
