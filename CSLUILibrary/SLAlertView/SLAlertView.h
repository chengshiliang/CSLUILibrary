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
@interface SLAlertView : SLView
- (instancetype)initWithType:(AlertType)type
                       title:(NSString *)title
                  titleModel:(id<SLAlertTitleProtocol> _Nullable)titleModel
              titleLineModel:(id<SLAlertTitleLineProtocol> _Nullable)titleLineModel
                     message:(NSString *)message
                messageModel:(id<SLAlertMessageProtocol> _Nullable)messageModel;
- (void)show;
@end

NS_ASSUME_NONNULL_END
