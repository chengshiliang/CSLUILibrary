//
//  SLImageDownLoader.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 防重复下载，防大批量下载。maxQueueCount 控制下载最大并发数
 */
@interface SLImageDownLoader : NSObject
@property (assign, nonatomic) NSInteger maxQueueCount;// 最大下载队列,default 5;
+ (instancetype)share;
- (UIImage *)downloadImage:(NSString *)url complete:(void(^)(UIImage *image,NSURL *imageUrl,CGFloat progress,BOOL finished,NSError *error))completeBlock;

- (void)cancelDownLoad:(NSString *)url;

- (void)cancelAllDownLoad;
@end

NS_ASSUME_NONNULL_END
