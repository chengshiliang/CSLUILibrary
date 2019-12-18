//
//  SLTableViewCell.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLTableViewCell.h"
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLLabel.h>
#import <CSLUILibrary/SLView.h>
#import <CSLUILibrary/SLTableCellModel.h>
#import <Masonry/Masonry.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLTableViewCell()

@end

@implementation SLTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setModel:(id <SLTableCellProtocol>)model {
    _model = model;
    if (!model || ![model conformsToProtocol:@protocol(SLTableCellProtocol)]) {
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        return;
    }
    UIEdgeInsets inset = [model contentInset];
    UIView *tempView = [[UIView alloc]init];
    [self.contentView addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).with.insets(inset);
    }];
    self.contentView.clipsToBounds = YES;
    UIView *leftView = nil;
    CGFloat leftViewWidth = 0.0;
    CGSize leftSize = [model leftViewSize];
    UIView *customLeftView = [model leftView];
    UIImageView *customLeftImageView = [model leftImage];
    if (customLeftView) {
        leftView = customLeftView;
    } else if (customLeftImageView) {
        leftView = customLeftImageView;
    }
    if (leftView) {
        if (leftSize.width <= 0 || leftSize.height <= 0) {
            leftSize = leftView.frame.size;
        }
        [tempView addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tempView);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(leftSize.height);
            make.width.mas_equalTo(leftSize.width);
        }];
        leftViewWidth += leftSize.width;
    }
    NSArray *leftTitleArray = [model leftTitles];
    NSInteger leftTitleCount = leftTitleArray ? leftTitleArray.count : 0;
    if (leftView && leftTitleCount > 0) {
        leftViewWidth += [model spaceBetweenImageAndTitleAtLeftItem];
    }
    CGFloat leftTitleMaxWidth = 0;
    if (leftTitleCount > 0) {
        CGFloat leftTitleHeight = leftTitleCount > 1 ? [model spaceTitlesAtLeftItem]*(leftTitleCount - 1) : 0;
        for (UILabel *titleLabel in leftTitleArray) {
            leftTitleHeight += titleLabel.frame.size.height;
            leftTitleMaxWidth = ceil(MAX(leftTitleMaxWidth, titleLabel.frame.size.width));
        }
        
        UIView *titleViews = [[UIView alloc]init];
        [tempView addSubview:titleViews];
        [titleViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tempView).offset(leftViewWidth);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(leftTitleHeight);
            make.width.mas_equalTo(leftTitleMaxWidth);
        }];
        CGFloat originTitleLabelY = 0;
        for (int i = 0; i < leftTitleCount; i++) {
            UILabel *titleLabel = leftTitleArray[i];
            [titleViews addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.mas_equalTo(titleViews);
               make.top.mas_equalTo(titleViews).offset(originTitleLabelY);
               make.height.mas_equalTo(titleLabel.frame.size.height);
               make.width.mas_equalTo(titleViews);
            }];
            originTitleLabelY += titleLabel.frame.size.height + [model spaceTitlesAtLeftItem];
        }
    }
    leftViewWidth += leftTitleMaxWidth;
    UIView *middeleView = [model middleView];
    if (middeleView && [model middleViewAtLeft]) {
        if (leftViewWidth > 0) {
            leftViewWidth += [model spaceBetweenMiddleItemAndLeftItem];
        }
        [tempView addSubview:middeleView];
        [middeleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tempView).offset(leftViewWidth);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(middeleView.frame.size.height);
            make.width.mas_equalTo(middeleView.frame.size.width);
        }];
        leftViewWidth += middeleView.frame.size.width;
        leftViewWidth += [model spaceBetweenMiddleItemAndRightItem];
    }
    
    UIView *rightView = nil;
    CGFloat rightViewWidth = 0;
    CGSize rightSize = [model rightViewSize];
    UIView *customRightView = [model rightView];
    UIImageView *customRightImageView = [model rightImage];
    if (customRightView) {
        rightView = customRightView;
    } else if (customRightImageView) {
        rightView = customRightImageView;
    }
    if (rightView) {
        if (rightSize.width <= 0 || rightSize.height <= 0) {
            rightSize = rightView.frame.size;
        }
        [tempView addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(tempView);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(rightSize.height);
            make.width.mas_equalTo(rightSize.width);
        }];
        rightViewWidth += rightSize.width;
    }
    NSArray *rightTitleArray = [model rightTitles];
    NSInteger rightTitleCount = rightTitleArray ? rightTitleArray.count : 0;
    if (rightView && rightTitleArray > 0) {
        rightViewWidth += [model spaceBetweenImageAndTitleAtRightItem];
    }
    if (rightTitleCount > 0) {
        CGFloat rightTitleHeight = rightTitleCount > 1 ? [model spaceTitlesAtRightItem]*(rightTitleCount - 1) : 0;
        CGFloat rightTitleMaxWidth = 0;
        for (UILabel *titleLabel in rightTitleArray) {
            rightTitleHeight += titleLabel.frame.size.height;
            rightTitleMaxWidth = ceil(MAX(rightTitleMaxWidth, titleLabel.frame.size.width));
        }
        UIView *titleViews = [[UIView alloc]init];
        [tempView addSubview:titleViews];
        [titleViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(tempView).offset(-rightViewWidth);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(rightTitleHeight);
            make.width.mas_equalTo(rightTitleMaxWidth);
        }];
        rightViewWidth += rightTitleMaxWidth;
        CGFloat originTitleLabelY = 0;
        for (int i = 0; i < rightTitleCount; i++) {
            UILabel *titleLabel = rightTitleArray[i];
            [titleViews addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.right.mas_equalTo(titleViews);
               make.top.mas_equalTo(titleViews).offset(originTitleLabelY);
               make.height.mas_equalTo(titleLabel.frame.size.height);
               make.left.mas_equalTo(titleViews);
            }];
            originTitleLabelY += titleLabel.frame.size.height + [model spaceTitlesAtRightItem];
        }
    }
    if (middeleView && ![model middleViewAtLeft]) {
        if (rightViewWidth > 0) {
            rightViewWidth += [model spaceBetweenMiddleItemAndRightItem];
        }
        [tempView addSubview:middeleView];
        [middeleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(tempView).offset(-rightViewWidth);
            make.centerY.mas_equalTo(tempView);
            make.height.mas_equalTo(middeleView.frame.size.height);
            make.width.mas_equalTo(middeleView.frame.size.width);
        }];
        rightViewWidth += middeleView.frame.size.width;
    }
    if (![model bottomLineViewHidden]) {
        if (![model bottomLineView]) {
            SLView *lineView = [[SLView alloc]init];
            lineView.backgroundColor = SLUIHexColor(0xe0e0e0);
            [self.contentView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(tempView);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(tempView).offset(inset.bottom);
            }];
        } else {
            [self.contentView addSubview:[model bottomLineView]];
        }
    }
}

@end
