//
//  SLTableDispatch.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SLTableTaskState){
    SLTableTaskStateRunning,
    SLTableTaskStateSuspend
};
typedef NS_ENUM(NSUInteger, SLTableTaskMode){
    SLTableTaskModeDefault,
    SLTableTaskModeCommon
};

typedef void(^ExecuteTask)(void);
@interface SLTableTask : NSObject

@property (nonatomic, strong) NSString *taskID;
@property (nonatomic, copy) ExecuteTask task;

- (id)initWithIdentifier:(NSString *)identifier task:(ExecuteTask)task;

- (void)excute;

@end
@interface SLTableDispatch : NSObject
- (void)addTask:(NSString *)taskID excute:(ExecuteTask)excute mode:(SLTableTaskMode)mode;

- (void)cancelTask:(NSString *)taskID;
@end

NS_ASSUME_NONNULL_END
