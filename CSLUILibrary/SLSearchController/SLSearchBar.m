//
//  SLSerchBar.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLSearchBar.h"
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLUILibrary/SLImageView.h>

@implementation SLSearchBar

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.font = SLUINormalFont(14.0);
        self.layer.cornerRadius = 5.f;
        self.backgroundColor = SLUIColor(240, 243, 245);
        self.placeholder = @"输入想搜索的内容";
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 28.f, 28.f)];
        SLImageView *searchIcon = [[SLImageView alloc] initWithFrame:CGRectMake(8.f, 7.5f, 13.f, 13.f)];
        [searchIcon sl_setImage:image];
        [self.leftView addSubview:searchIcon];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}
@end
