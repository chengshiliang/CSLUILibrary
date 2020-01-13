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
@property (nonatomic, strong) UIView *contentViews;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *leftTitleView;
@property (nonatomic, strong) UILabel *leftTitleLabel0;
@property (nonatomic, strong) UILabel *leftTitleLabel1;
@property (nonatomic, strong) UILabel *leftTitleLabel2;
@property (nonatomic, strong) UILabel *leftTitleLabel3;
@property (nonatomic, strong) UILabel *leftTitleLabel4;
@property (nonatomic, strong) UIView *middeleView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *rightTitleView;
@property (nonatomic, strong) UILabel *rightTitleLabel0;
@property (nonatomic, strong) UILabel *rightTitleLabel1;
@property (nonatomic, strong) UILabel *rightTitleLabel2;
@property (nonatomic, strong) UILabel *rightTitleLabel3;
@property (nonatomic, strong) UILabel *rightTitleLabel4;
@property (nonatomic, strong) SLView *lineView;
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
    self.contentViews = [[UIView alloc]init];
    [self.contentView addSubview:self.contentViews];
    
    self.leftView = [[UIView alloc]init];
    [self.contentViews addSubview:self.leftView];
    self.leftView.hidden = YES;
    
    self.leftImageView = [[UIImageView alloc]init];
    [self.contentViews addSubview:self.leftImageView];
    self.leftImageView.hidden = YES;
    
    self.leftTitleView = [[UIView alloc]init];
    [self.contentViews addSubview:self.leftTitleView];
    self.leftTitleView.hidden = YES;
    
    self.leftTitleLabel0 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.leftTitleLabel0];
    self.leftTitleLabel0.hidden = YES;
    self.leftTitleLabel1 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.leftTitleLabel1];
    self.leftTitleLabel1.hidden = YES;
    self.leftTitleLabel2 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.leftTitleLabel2];
    self.leftTitleLabel2.hidden = YES;
    self.leftTitleLabel3 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.leftTitleLabel3];
    self.leftTitleLabel3.hidden = YES;
    self.leftTitleLabel4 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.leftTitleLabel4];
    self.leftTitleLabel4.hidden = YES;
    
    self.middeleView = [[UIView alloc] init];
    [self.contentViews addSubview:self.middeleView];
    self.middeleView.hidden = YES;
    
    self.rightView = [[UIView alloc]init];
    [self.contentViews addSubview:self.rightView];
    self.rightView.hidden = YES;
    
    self.rightImageView = [[UIImageView alloc]init];
    [self.contentViews addSubview:self.rightImageView];
    self.rightImageView.hidden = YES;
    
    self.rightTitleView = [[UIView alloc]init];
    [self.contentViews addSubview:self.rightTitleView];
    self.rightTitleView.hidden = YES;
    
    self.rightTitleLabel0 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.rightTitleLabel0];
    self.rightTitleLabel0.hidden = YES;
    self.rightTitleLabel1 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.rightTitleLabel1];
    self.rightTitleLabel1.hidden = YES;
    self.rightTitleLabel2 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.rightTitleLabel2];
    self.rightTitleLabel2.hidden = YES;
    self.rightTitleLabel3 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.rightTitleLabel3];
    self.rightTitleLabel3.hidden = YES;
    self.rightTitleLabel4 = [[UILabel alloc]init];
    [self.leftTitleView addSubview:self.rightTitleLabel4];
    self.rightTitleLabel4.hidden = YES;
    
    self.lineView = [[SLView alloc]init];
    self.lineView.backgroundColor = SLUIHexColor(0xe0e0e0);
    [self.contentView addSubview:self.lineView];
}


- (void)setModel:(id <SLTableCellProtocol>)model {
    _model = model;
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!model || ![model conformsToProtocol:@protocol(SLTableCellProtocol)]) {
        return;
    }
    UIEdgeInsets inset = [model contentInset];
    [self.contentViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).with.insets(inset);
    }];
    CGFloat leftViewWidth = 0.0;
    CGSize leftSize = [model leftViewSize];
    UIView *customLeftView = [model leftView];
    UIImageView *customLeftImageView = [model leftImage];
    NSArray *leftTitleArray = [model leftTitles];
    NSInteger leftTitleCount = leftTitleArray ? leftTitleArray.count : 0;
    if (customLeftView) {
        self.leftView = customLeftView;
        self.leftView.hidden = NO;
        if (leftSize.width <= 0 || leftSize.height <= 0) {
            leftSize = self.leftView.frame.size;
        }
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(leftSize.height);
            make.width.mas_equalTo(leftSize.width);
        }];
        leftViewWidth += leftSize.width;
        if (leftTitleCount > 0) {
            leftViewWidth += [model spaceBetweenImageAndTitleAtLeftItem];
        }
    } else if (customLeftImageView) {
        self.leftImageView = customLeftImageView;
        self.leftImageView.hidden = NO;
        if (leftSize.width <= 0 || leftSize.height <= 0) {
            leftSize = self.leftImageView.frame.size;
        }
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(leftSize.height);
            make.width.mas_equalTo(leftSize.width);
        }];
        leftViewWidth += leftSize.width;
        if (leftTitleCount > 0) {
            leftViewWidth += [model spaceBetweenImageAndTitleAtLeftItem];
        }
    } else {
        self.leftView.hidden = YES;
        self.leftImageView.hidden = YES;
    }
    self.leftTitleView.hidden = leftTitleCount <= 0;
    if (leftTitleCount > 0) {
        CGFloat leftTitleMaxWidth = 0;
        CGFloat leftTitleHeight = leftTitleCount > 1 ? [model spaceTitlesAtLeftItem]*(leftTitleCount - 1) : 0;
        for (UILabel *titleLabel in leftTitleArray) {
            leftTitleHeight += titleLabel.frame.size.height;
            leftTitleMaxWidth = ceil(MAX(leftTitleMaxWidth, titleLabel.frame.size.width));
        }
        [self.leftTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews).offset(leftViewWidth);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(leftTitleHeight);
            make.width.mas_equalTo(leftTitleMaxWidth);
        }];
        CGFloat originTitleLabelY = 0;
        for (int i = 0; i < leftTitleCount; i++) {
            if (i > 4) {
                break;
            }
            UILabel *titleLabel = leftTitleArray[i];
            switch (i) {
                case 0:
                {
                    self.leftTitleLabel0 = titleLabel;
                    self.leftTitleLabel0.hidden = NO;
                    [self.leftTitleLabel0 mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.leftTitleView);
                       make.top.mas_equalTo(self.leftTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.leftTitleView);
                    }];
                }
                    break;
                case 1:
                {
                    self.leftTitleLabel1 = titleLabel;
                    self.leftTitleLabel1.hidden = NO;
                    [self.leftTitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.leftTitleView);
                       make.top.mas_equalTo(self.leftTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.leftTitleView);
                    }];
                }
                    break;
                case 2:
                {
                    self.leftTitleLabel2 = titleLabel;
                    self.leftTitleLabel2.hidden = NO;
                    [self.leftTitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.leftTitleView);
                       make.top.mas_equalTo(self.leftTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.leftTitleView);
                    }];
                }
                    break;
                case 3:
                {
                    self.leftTitleLabel3 = titleLabel;
                    self.leftTitleLabel3.hidden = NO;
                    [self.leftTitleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.leftTitleView);
                       make.top.mas_equalTo(self.leftTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.leftTitleView);
                    }];
                }
                    break;
                case 4:
                {
                    self.leftTitleLabel4 = titleLabel;
                    self.leftTitleLabel4.hidden = NO;
                    [self.leftTitleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.leftTitleView);
                       make.top.mas_equalTo(self.leftTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.leftTitleView);
                    }];
                }
                    break;
                default:
                    break;
            }
            originTitleLabelY += titleLabel.frame.size.height + [model spaceTitlesAtLeftItem];
        }
        leftViewWidth += leftTitleMaxWidth;
    }
    
    self.middeleView = [model middleView];
    if (self.middeleView) {
        self.middeleView.hidden = NO;
    }
    if (self.middeleView && [model middleViewAtLeft]) {
        if (leftViewWidth > 0) {
            leftViewWidth += [model spaceBetweenMiddleItemAndLeftItem];
        }
        [self.middeleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews).offset(leftViewWidth);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(self.middeleView.frame.size.height);
            make.width.mas_equalTo(self.middeleView.frame.size.width);
        }];
        leftViewWidth += self.middeleView.frame.size.width;
        leftViewWidth += [model spaceBetweenMiddleItemAndRightItem];
    }
    
    CGFloat rightViewWidth = 0.0;
    CGSize rightSize = [model leftViewSize];
    UIView *customRightView = [model leftView];
    UIImageView *customRightImageView = [model leftImage];
    NSArray *rightTitleArray = [model rightTitles];
    NSInteger rightTitleCount = rightTitleArray ? rightTitleArray.count : 0;
    if (customRightView) {
        self.rightView = customRightView;
        self.rightView.hidden = NO;
        if (rightSize.width <= 0 || rightSize.height <= 0) {
            rightSize = self.rightView.frame.size;
        }
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(rightSize.height);
            make.width.mas_equalTo(rightSize.width);
        }];
        rightViewWidth += rightSize.width;
        if (rightTitleCount > 0) {
            rightViewWidth += [model spaceBetweenImageAndTitleAtRightItem];
        }
    } else if (customRightImageView) {
        self.rightImageView = customRightImageView;
        self.rightImageView.hidden = NO;
        if (rightSize.width <= 0 || rightSize.height <= 0) {
            rightSize = self.rightImageView.frame.size;
        }
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(rightSize.height);
            make.width.mas_equalTo(rightSize.width);
        }];
        rightViewWidth += rightSize.width;
        if (rightTitleCount > 0) {
            rightViewWidth += [model spaceBetweenImageAndTitleAtRightItem];
        }
    } else {
        self.leftView.hidden = YES;
        self.leftImageView.hidden = YES;
    }
    self.rightTitleView.hidden = rightTitleCount <= 0;

    if (rightTitleCount > 0) {
        CGFloat rightTitleHeight = rightTitleCount > 1 ? [model spaceTitlesAtRightItem]*(rightTitleCount - 1) : 0;
        CGFloat rightTitleMaxWidth = 0;
        for (UILabel *titleLabel in rightTitleArray) {
            rightTitleHeight += titleLabel.frame.size.height;
            rightTitleMaxWidth = ceil(MAX(rightTitleMaxWidth, titleLabel.frame.size.width));
        }
        [self.rightTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentViews).offset(leftViewWidth);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(rightTitleHeight);
            make.width.mas_equalTo(rightTitleMaxWidth);
        }];
        CGFloat originTitleLabelY = 0;
        for (int i = 0; i < rightTitleCount; i++) {
            if (i > 4) {
                break;
            }
            UILabel *titleLabel = rightTitleArray[i];
            switch (i) {
                case 0:
                {
                    self.rightTitleLabel0 = titleLabel;
                    self.rightTitleLabel0.hidden = NO;
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.rightTitleView);
                       make.top.mas_equalTo(self.rightTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.rightTitleView);
                    }];
                }
                    break;
                case 1:
                {
                    self.rightTitleLabel1 = titleLabel;
                    self.rightTitleLabel1.hidden = NO;
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.rightTitleView);
                       make.top.mas_equalTo(self.rightTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.rightTitleView);
                    }];
                }
                    break;
                case 2:
                {
                    self.rightTitleLabel2 = titleLabel;
                    self.rightTitleLabel2.hidden = NO;
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.rightTitleView);
                       make.top.mas_equalTo(self.rightTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.rightTitleView);
                    }];
                }
                    break;
                case 3:
                {
                    self.rightTitleLabel3 = titleLabel;
                    self.rightTitleLabel3.hidden = NO;
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.rightTitleView);
                       make.top.mas_equalTo(self.rightTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.rightTitleView);
                    }];
                }
                    break;
                case 4:
                {
                    self.rightTitleLabel4 = titleLabel;
                    self.rightTitleLabel4.hidden = NO;
                    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       make.left.mas_equalTo(self.rightTitleView);
                       make.top.mas_equalTo(self.rightTitleView).offset(originTitleLabelY);
                       make.height.mas_equalTo(titleLabel.frame.size.height);
                       make.width.mas_equalTo(self.rightTitleView);
                    }];
                }
                    break;
                default:
                    break;
            }
            originTitleLabelY += titleLabel.frame.size.height + [model spaceTitlesAtRightItem];
        }
        leftViewWidth += rightTitleMaxWidth;
    }
    if (self.middeleView && ![model middleViewAtLeft]) {
        if (rightViewWidth > 0) {
            rightViewWidth += [model spaceBetweenMiddleItemAndRightItem];
        }
        [self.middeleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentViews).offset(-rightViewWidth);
            make.centerY.mas_equalTo(self.contentViews);
            make.height.mas_equalTo(self.middeleView.frame.size.height);
            make.width.mas_equalTo(self.middeleView.frame.size.width);
        }];
        rightViewWidth += self.middeleView.frame.size.width;
    }
    self.lineView.hidden = [model bottomLineViewHidden];
    if (![model bottomLineViewHidden]) {
        if (![model bottomLineView]) {
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.contentViews);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(self.contentViews).offset(inset.bottom);
            }];
        } else {
            self.lineView = [model bottomLineView];
        }
    }
}

@end
