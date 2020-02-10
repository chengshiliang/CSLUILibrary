//
//  SLImageDownLoader.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/11.
//

#import "SLImageDownLoader.h"
#import <CSLCommonLibrary/NSString+Util.h>
#import <SDWebImage/SDWebImage.h>
#import <CSLCommonLibrary/SLUtil.h>
#import <CSLCommonLibrary/SLUIConsts.h>
#import <CSLUILibrary/SLImageView.h>

@interface SLDownTask : NSObject

@property (strong, nonatomic) NSString *url;
@property (copy, nonatomic) void (^complete) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error);

+ (SLDownTask *)taskWithUrl:(NSString *)url complete:(void (^) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error))complete;

@end

@implementation SLDownTask

+ (SLDownTask *)taskWithUrl:(NSString *)url complete:(void (^) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error))complete {
    SLDownTask *task = [[SLDownTask alloc] init];
    task.url = url;
    task.complete = complete;
    return task;
}

@end
@interface SLDownOperation : NSObject
@property (strong, nonatomic) SDWebImageCombinedOperation *operation;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) void (^complete) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error);

+ (SLDownOperation *)operateWithUrl:(NSString *)url operation:(SDWebImageCombinedOperation *)operation complete:(void (^) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error))complete;
@end

@implementation SLDownOperation
+ (SLDownOperation *)operateWithUrl:(NSString *)url operation:(SDWebImageCombinedOperation *)operation complete:(void (^) (UIImage *image,NSURL *imageURL,CGFloat progress,BOOL finished,NSError *error))complete {
    SLDownOperation *operate = [[SLDownOperation alloc] init];
    operate.operation = operation;
    operate.url = url;
    operate.complete = complete;
    return operate;
}

@end
@interface SLImageDownLoader ()
@property (strong, nonatomic) NSMutableDictionary *downOperations;
@property (strong, nonatomic) NSMutableArray *nextDownQueue;
@property (strong, nonatomic) NSLock *lock;
@end
@implementation SLImageDownLoader
+ (instancetype)share {
    static SLImageDownLoader *downLoader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoader = [[SLImageDownLoader alloc]init];
        downLoader.maxQueueCount = 5;
        downLoader.lock = [[NSLock alloc]init];
    });
    return downLoader;
}
- (UIImage *)downloadImage:(NSString *)url complete:(void(^)(UIImage *image,NSURL *imageUrl,CGFloat progress,BOOL finished,NSError *error))completeBlock {
    if ([NSString emptyString:url]) {
        !completeBlock?:completeBlock(nil,nil,0.0,true,[NSError errorWithDomain:@"com.csl.imageDownload" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey: @"图片下载url为空"}]);
        return nil;
    }
    NSURL *imageUrl = [NSURL URLWithString:url];
    SDImageCache *imageCache = [[SDWebImageManager sharedManager]imageCache];
    NSString *cacheKey = [[SDWebImageManager sharedManager]cacheKeyForURL:imageUrl];
    UIImage *cacheImage = [imageCache imageFromMemoryCacheForKey:cacheKey];
    if (cacheImage) {
        !completeBlock?:completeBlock(cacheImage,imageUrl,0.0,true,nil);
        return cacheImage;
    }
    if ([imageCache diskImageDataExistsWithKey:cacheKey]) {
        [SLUtil runBackground:^{
            UIImage *diskImage = [imageCache imageFromDiskCacheForKey:cacheKey];
            !completeBlock?:completeBlock(diskImage,imageUrl,100.0,true,nil);
        }];
        return nil;
    }
    [self.lock lock];
    if ([self.downOperations objectForKey:url] && completeBlock) {
        NSMutableArray *sameDownOperation = [self.downOperations objectForKey:url];
        [sameDownOperation addObject:[SLDownOperation operateWithUrl:url operation:nil complete:completeBlock]];
        [self.lock unlock];
        return nil;
    }
    if (self.downOperations.count > self.maxQueueCount) {
        [self.nextDownQueue addObject:[SLDownTask taskWithUrl:url complete:completeBlock]];
        [self.lock unlock];
        return nil;
    }
    [self.lock unlock];
    NSLog(@"开始下载");
    WeakSelf;
    SDWebImageCombinedOperation *operation = [[SDWebImageManager sharedManager] loadImageWithURL:imageUrl options:SDWebImageRefreshCached context:NULL progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        StrongSelf;
        [strongSelf.lock lock];
        NSString *urlString = targetURL.absoluteString;
        NSMutableArray *sameDownOperation = [strongSelf.downOperations objectForKey:urlString];
        for (int i = 0 ; i < sameDownOperation.count; i ++) {
            SLDownOperation *operation = sameDownOperation[i];
            !operation.complete?:operation.complete(nil, nil, receivedSize*100.0/expectedSize,false,nil);
        }
        [strongSelf.lock unlock];
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        StrongSelf;
        NSLog(@"下载完成");
        [strongSelf.lock lock];
        NSString *urlString = imageURL.absoluteString;
        NSMutableArray *sameDownOperation = [strongSelf.downOperations objectForKey:urlString];
        [strongSelf.downOperations removeObjectForKey:urlString];
        for (int i = 0 ; i < sameDownOperation.count; i ++) {
            SLDownOperation *operation = sameDownOperation[i];
            if (!error) {
                !operation.complete?:operation.complete(image, imageURL, 100.0, true,nil);
            } else {
                !operation.complete?:operation.complete(nil, nil, 0.0,false,[NSError errorWithDomain:@"com.csl.imageDownload" code:-1 userInfo:@{NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"图片%@下载失败", urlString]}]);
            }
        }
        if (strongSelf.nextDownQueue.count == 0) {
            [strongSelf.lock unlock];
            return;
        }
        SLDownTask *nextTask = strongSelf.nextDownQueue[0];
        [strongSelf.nextDownQueue removeObjectAtIndex:0];
        [strongSelf.lock unlock];
        [strongSelf downloadImage:nextTask.url complete:nextTask.complete];
    }];
    NSMutableArray *sameDownOperation = [NSMutableArray array];
    [sameDownOperation addObject:[SLDownOperation operateWithUrl:url operation:operation complete:completeBlock]];
    [self.downOperations setObject:sameDownOperation forKey:url];
    return nil;
}

- (void)cancelDownLoad:(NSString *)url {
    [self.lock lock];
    NSMutableArray *sameDownOperation = [self.downOperations objectForKey:url];
    [self.downOperations removeObjectForKey:url];
    for (int i = 0 ; i < sameDownOperation.count; i ++) {
        SLDownOperation *operation = sameDownOperation[i];
        if (operation.operation) {
            [operation.operation cancel];
        }
    }
    NSMutableArray *cancelTaskArray = self.nextDownQueue.mutableCopy;
    for (SLDownTask *task in cancelTaskArray) {
        if ([task.url isEqualToString:url]) {
            [self.nextDownQueue removeObject:task];
        }
    }
    [self.lock unlock];
}

- (void)cancelAllDownLoad {
    [self.lock lock];
    [self.downOperations removeAllObjects];
    [self.nextDownQueue removeAllObjects];
    [self.lock unlock];
}

- (NSMutableArray *)nextDownQueue {
    if (!_nextDownQueue) {
        _nextDownQueue = [NSMutableArray array];
    }
    return _nextDownQueue;
}

- (NSMutableDictionary *)downOperations
{
    if (!_downOperations) {
        _downOperations = [NSMutableDictionary dictionaryWithCapacity:self.maxQueueCount];
    }
    return _downOperations;
}
@end
