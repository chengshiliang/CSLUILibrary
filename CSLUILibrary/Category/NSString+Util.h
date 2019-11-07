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
-(CGSize)sizeWithFont:(UIFont*)font size:(CGSize)size;
-(CGFloat)heightWithFont:(UIFont*)font width:(CGFloat)width;
-(CGFloat)widthWithFont:(UIFont*)font height:(CGFloat)height;
- (NSUInteger)compareTo:(NSString*)comp;
- (NSUInteger)compareToIgnoreCase:(NSString*) comp;
- (bool)contains:(NSString*)substring;
- (bool)endsWith:(NSString*)substring;
- (bool)startsWith:(NSString*)substring;
- (NSUInteger)indexOf:(NSString*)substring;
- (NSUInteger)indexOf:(NSString *)substring startingFrom:(NSUInteger)index;
- (NSUInteger)lastIndexOf:(NSString*)substring;
- (NSUInteger)lastIndexOf:(NSString *)substring startingFrom:(NSUInteger)index;
- (NSString*)substringFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
- (NSString*)trim;
- (NSArray*)split:(NSString*)token;
- (NSString*)replace:(NSString*) target withString:(NSString*)replacement;
- (NSArray*)split:(NSString*)token limit:(NSUInteger)maxResults;

- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
- (CGSize)sizeWithConstrainedToSize:(CGSize)size fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;
/**
 利用CoreText进行文字的绘制
 */
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height andWidth:(float)width;
- (void)drawInContext:(CGContextRef)context withPosition:(CGPoint)p andFont:(UIFont *)font andTextColor:(UIColor *)color andHeight:(float)height;
@end

NS_ASSUME_NONNULL_END
