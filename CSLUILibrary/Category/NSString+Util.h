//
//  NSString+Util.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/5.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (Util)
-(BOOL)emptyString;
-(NSString *)blankString;
-(CGSize)sizeWithFont:(UIFont*)font;
-(CGFloat)heightWithFont:(UIFont*)font width:(CGFloat)width;
-(CGFloat)widthWithFont:(UIFont*)font height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
