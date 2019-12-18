//
//  SLTableCellModel.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/12/2.
//

#import "SLTableCellModel.h"
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLUIConsts.h>
#import <SDWebImage/SDWebImage.h>

@implementation SLTableCellTitleModel

- (NSString *)title {
    if ([NSString emptyString:_title]) {
        return @" ";
    }
    return _title;
}

- (UIColor *)color {
    if (!_color) {
        return SLSelectLabelColor;
    }
    return _color;
}

- (UIFont *)font {
    if (!_font) {
        return SLUINormalFont(14.0);
    }
    return _font;
}

- (CGFloat)width {
    if (_width <= 0) {
        return kScreenWidth;
    }
    return _width;
}

@end

@implementation SLTableCellModel

- (UIEdgeInsets)contentInset {
    return ![NSStringFromUIEdgeInsets(self.contentEdgeInset) isEqualToString:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)] ? self.contentEdgeInset : UIEdgeInsetsMake(0, 20.0, 0, 20.0);
}

- (UIView *)leftView {// 自定义cell左边视图
    return self.customLeftView;
}

- (CGSize)leftViewSize {// cell左边视图大小（包括图片和自定义view）
    return ([self leftCustomViewSize].width > 0 && [self leftCustomViewSize].height > 0) ? [self leftCustomViewSize] : CGSizeMake(30, 30);
}

- (UIImageView *)leftImage {
    if ([NSString emptyString:self.leftImageUrl]) {
        return nil;
    }
    CGSize imageSize = [self leftViewSize];
    SLImageView *imageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    if (self.isLeftImageLocal) {
        imageView.image = [UIImage imageNamed:self.leftImageUrl];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.leftImageUrl]];
    }
    return imageView;
}

- (float)spaceBetweenImageAndTitleAtLeftItem {// cell左边文字和图片（自定义视图）间距 (leftImage\leftView 返回非空)才调用
    return self.rowSpaceLeftItem > 0 ? self.rowSpaceLeftItem : 10.0f;
}

- (NSArray<UILabel *> *)leftTitles {
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.leftTitleModels.count];
    for (SLTableCellTitleModel *model in self.leftTitleModels) {
        SLLabel *label = [[SLLabel alloc]init];
        
        if ([NSString emptyString:model.title]) {
            label.frame = CGRectZero;
        } else {
            CGSize titleSize = [model.title sizeWithFont:model.font size:CGSizeMake(model.width, MAXFLOAT)];
            label.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            label.text = model.title;
            label.font = model.font;
            label.textColor = model.color;
            label.textAlignment = NSTextAlignmentLeft;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 0;
        }
        [arrayM addObject:label];
    }
    return arrayM.copy;
}

- (float)spaceTitlesAtLeftItem {// cell左边文字间距 numberRowsAtRightItem 大于1的时候才调用
    return self.columnSpaceLeftItem > 0 ? self.columnSpaceLeftItem : 8.0f;
}

- (BOOL)middleViewAtLeft {
    return self.isLeftForMiddleView;
}

- (UIView *)middleView {// 自定义cell中间部分的视图
    return self.customMiddleView;
}

- (float)spaceBetweenMiddleItemAndLeftItem {// cell左边和中间部分视图的间距
    return self.rowSpaceLeftAndMiddleItem > 0 ? self.rowSpaceLeftAndMiddleItem : 10.0f;
}

- (float)spaceBetweenMiddleItemAndRightItem {// cell左边和中间部分视图的间距
    return self.rowSpaceMiddleAndRightItem > 0 ? self.rowSpaceMiddleAndRightItem : 10.0f;
}

- (UIView *)rightView {// 自定义cell左边视图
    return self.customRightView;
}

- (UIImageView *)rightImage {
    if ([NSString emptyString:self.rightImageUrl]) return nil;
    CGSize imageSize = [self rightViewSize];
    SLImageView *imageView = [[SLImageView alloc]initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    if (self.isRightImageLocal) {
        imageView.image = [UIImage imageNamed:self.rightImageUrl];
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.rightImageUrl]];
    }
    return imageView;
}

- (CGSize)rightViewSize {// cell右边视图大小（包括图片和自定义view）
    return ([self rightCustomViewSize].width > 0 && [self rightCustomViewSize].height > 0) ? [self rightCustomViewSize] : CGSizeMake(30, 30);
}

- (float)spaceBetweenImageAndTitleAtRightItem {// cell右边文字和图片（自定义视图）间距 返回为yes(rightImage\rightView 返回非空)才调用
    return self.rowSpaceRightItem > 0 ? self.rowSpaceRightItem : 10.0f;
}

- (NSArray<UILabel *> *)rightTitles {
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:self.rightTitleModels.count];
    for (SLTableCellTitleModel *model in self.rightTitleModels) {
        SLLabel *label = [[SLLabel alloc]init];
        if ([NSString emptyString:model.title]) {
            label.frame = CGRectZero;
        } else {
            CGSize titleSize = [model.title sizeWithFont:model.font size:CGSizeMake(model.width, MAXFLOAT)];
            label.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
            label.text = model.title;
            label.font = model.font;
            label.textColor = model.color;
            label.textAlignment = NSTextAlignmentRight;
            label.lineBreakMode = NSLineBreakByTruncatingTail;
            label.numberOfLines = 0;
        }
        [arrayM addObject:label];
    }
    return arrayM.copy;
}

- (float)spaceTitlesAtRightItem {// cell右边文字间距 numberRowsAtRightItem 大于1的时候才调用
    return self.columnSpaceRightItem > 0 ? self.columnSpaceRightItem : 8.0f;
}

- (BOOL)bottomLineViewHidden {
    return self.isHiddenForBottomLineView;
}

- (UIView *)bottomLineView {
    return self.customBottomLineView;
}

@end
