//
//  SLLabel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/10/31.
//

#import "SLLabel.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLUILibrary/SLLableConfig.h>

@interface SLLabel()

@end

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
    NSDictionary *config = [SLLableConfig share].labelConfig;
    NSString *typeKey = [NSString stringWithFormat:@"%ld", (long)labelType];
    NSDictionary *dic = config[typeKey];
    if (!dic) {
        self.font = [SLLableConfig fontSize:labelType];
        self.textColor = [SLLableConfig color:labelType];
    } else {
        self.font = dic[SLLabelFontSize];
        self.textColor = dic[SLLabelColor];
    }
}

- (CGRect)getContentRect {
    return [self textRectForBounds:self.frame limitedToNumberOfLines:self.numberOfLines];
}

@end
