//
//  SLTableDispatch.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import "SLTableDispatch.h"

@implementation SLTableTask

- (id)initWithIdentifier:(NSString *)identifier task:(ExecuteTask)task{
    self = [super init];
    if (self) {
        self.taskID = identifier;
        self.task = task;
    }
    return self;
}

- (void)excute{
    if (self.task) {
        self.task();
    }
}

@end

@interface SLTableDispatch()
@property (nonatomic, strong) NSMutableDictionary<NSString *, SLTableTask *> *taskPool;
@property (nonatomic, strong) NSMutableArray<NSString *> *taskKeys;
@property (nonatomic, assign) SLTableTaskState state;
@property (nonatomic, assign) SLTableTaskMode mode;
@end

static CFRunLoopObserverRef observer;
@implementation SLTableDispatch
- (instancetype)init {
    if (self == [super init]) {
        _state = SLTableTaskStateSuspend;
    }
    return self;
}

- (void)addTask:(NSString *)taskID excute:(ExecuteTask)excute mode:(SLTableTaskMode)mode{
    self.mode = mode;
    SLTableTask *task = [[SLTableTask alloc] initWithIdentifier:taskID task:excute];
    [self addTask:task];
}

- (void)cancelTask:(NSString *)taskID{
    if (!self.taskPool[taskID]) return;
    self.taskPool[taskID] = nil;
    if ([self.taskKeys containsObject:taskID]) {
        [self.taskKeys removeObject:taskID];
    }
    if (self.taskPool.count == 0 && self.state == SLTableTaskStateRunning) {
        [self invaliate];
    }
}

- (void)addTask:(SLTableTask *)task{
    self.taskPool[task.taskID] = task;
    [self.taskKeys addObject:task.taskID];
    if (self.state == SLTableTaskStateSuspend) {
        reigsterObserver(self);
    }
}

- (void)executeTask{
    NSString *taskID = [self.taskKeys firstObject];
    if (!taskID) return;
    [self.taskKeys removeObjectAtIndex:0];
    SLTableTask *task = self.taskPool[taskID];
    [task excute];
    self.taskPool[taskID] = nil;
    if (self.taskPool.count == 0 && self.state == SLTableTaskStateRunning) {
        [self invaliate];
    }
}

- (void)invaliate{
    CFRunLoopRemoveObserver([NSRunLoop mainRunLoop].getCFRunLoop, observer, kCFRunLoopCommonModes);
    self.state = SLTableTaskStateSuspend;
}

- (void)dealloc {
    [self invaliate];
}

static void reigsterObserver(id self){
    CFRunLoopRef runLoop = [NSRunLoop mainRunLoop].getCFRunLoop;
    CFRunLoopActivity activities = kCFRunLoopBeforeWaiting | kCFRunLoopExit;
    observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                  activities,
                                                  YES, NSUIntegerMax, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
                                                      [self executeTask];
                                                  });
    SLTableDispatch *dispatcher = (SLTableDispatch *)self;
    CFRunLoopAddObserver(runLoop, observer, dispatcher.mode == SLTableTaskModeDefault ? kCFRunLoopDefaultMode : kCFRunLoopCommonModes);
    dispatcher.state = SLTableTaskStateRunning;
}
@end
