//
//  SLLabel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLLabel.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLUIConst.h>
#import <CSLUILibrary/SLUtil.h>
#import <CSLUILibrary/SLUIConfig.h>

@implementation SLLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)init {
    if (self == [super init]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    self.labelType = LabelNormal;
    self.textAlignment = NSTextAlignmentLeft;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setLabelType:(LabelType)labelType {
    NSDictionary *config = [SLUIConfig share].labelConfig;
    NSString *typeKey = [NSString stringWithFormat:@"%ld", (long)labelType];
    NSDictionary *dic = config[typeKey];
    if (!dic) {
        self.font = [SLUtil fontSize:labelType];
        self.textColor = [SLUtil color:labelType];
    } else {
        self.font = dic[SLLabelFontSize];
        self.textColor = dic[SLLabelColor];
    }
}

- (CGRect)getContentRect {
    return [self textRectForBounds:self.frame limitedToNumberOfLines:self.numberOfLines];
}

@end
