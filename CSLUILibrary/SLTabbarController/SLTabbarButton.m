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
- (void)show {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setNeedsLayout];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return _titleReact;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if ((self.imageSize.width > 0 || self.imageSize.height > 0) && self.buttonTypes != SLButtonTypeOnlyTitle) {
        CGFloat imageW = self.imageSize.width;
        CGFloat imageH = self.imageSize.height;
        if (self.buttonTypes == SLButtonTypeOnlyImage) {// 只有图片显示
            _titleReact = CGRectZero;
            //内容总高度
            CGFloat totalHeight = imageH;
            CGFloat imageY = (contentRect.size.height - totalHeight)/2.0;
            CGFloat imageX = (contentRect.size.width - imageW)/2.0;
            _imageReact = CGRectMake(imageX, imageY, imageW, imageH);
            return _imageReact;
        } else if (self.buttonTypes == SLButtonTypeLeft) {
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
        } else if (self.buttonTypes == SLButtonTypeTop) {
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
        } else if (self.buttonTypes == SLButtonTypeRight) {
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
        if (self.buttonTypes == SLButtonTypeOnlyTitle) {
            _titleReact = CGRectMake(0, 0, contentRect.size.width, contentRect.size.height);
            _imageReact = CGRectZero;
            return _imageReact;
        }
        return [super imageRectForContentRect:contentRect];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    if (self.imageSize.height <= 0 && self.imageSize.height <= 0) {
        self.imageSize = CGSizeMake(image.size.width > self.frame.size.width ? self.frame.size.width : image.size.width,
                                    image.size.width > self.frame.size.height ? self.frame.size.height : image.size.height);
    }
    [super setImage:image forState:state];
}
@end
