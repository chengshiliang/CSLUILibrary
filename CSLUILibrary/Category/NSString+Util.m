//
//  NSString+Util.m
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "NSString+Util.h"
#import <CSLUILibrary/SLUIConsts.h>

@implementation NSString (Util)
- (BOOL)emptyString {
    if (!self) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!self.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (NSString *)blankString {
    if ([self emptyString]) {
        return @"";
    }
    return self;
}

- (CGSize)sizeWithFont:(UIFont*)font{
    if (self == nil) return CGSizeZero;
    return [self boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
}

- (CGFloat)heightWithFont:(UIFont*)font width:(CGFloat)width {
    if (self == nil) return 0;
    CGSize titleSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(width > 0 ?: kScreenWidth, 0)];
    return titleSize.height;
}

- (CGFloat)widthWithFont:(UIFont*)font height:(CGFloat)height {
    if (self == nil) return 0;
    CGSize titleSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(0, height > 0 ?: kScreenHeight)];
    return titleSize.width;
}
@end
