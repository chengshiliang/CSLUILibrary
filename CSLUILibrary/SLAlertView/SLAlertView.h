//
//  SLAlertView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import "SLView.h"
#import <CSLUILibrary/SLAlertProtocol.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, AlertType){
    AlertView = 0,// UIAlertView
    AlertSheet = 1,// UIActionSheet
};
typedef NS_ENUM(NSInteger, AlertActionType){
    AlertActionCancel = 0,
    AlertActionDefault = 1,
    AlertActionDestructive = 2
};
@interface SLAlertView : SLView
@property (nonatomic, copy) NSString *title;// 更新title，但不会引起frame变化。可能会引起...的现象
@property (nonatomic, copy) NSString *message;// 更新message，但不会引起frame变化。会引起...的现象
- (instancetype)initWithType:(AlertType)type
                       title:(NSString *)title
                  titleModel:(id<SLAlertTitleProtocol> _Nullable)titleModel
              titleLineModel:(id<SLAlertLineProtocol> _Nullable)titleLineModel
                     message:(NSString *)message
                messageModel:(id<SLAlertMessageProtocol> _Nullable)messageModel;
- (void)addActionWithTitle:(NSString *)title
                      type:(AlertActionType)type
                 lineModel:(id<SLAlertLineProtocol> _Nullable)lineModel
               actionModel:(id<SLAlertActionProtocol> _Nullable)actionModel
                  callback:(void(^)(void))callback;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
