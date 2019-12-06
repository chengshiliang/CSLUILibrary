//
//  SLAlertView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/4.
//

#import "SLView.h"
#import <CSLUILibrary/SLTabbarView.h>
#import <CSLUILibrary/SLTabbarButton.h>

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
typedef NS_ENUM(NSInteger, AlertContentViewAlignmentType) {
    AlertContentViewAlignmentCenter = 0,
    AlertContentViewAlignmentLeft = 1,
    AlertContentViewAlignmentRight = 2,
};

@interface SLAlertAction : NSObject
@property (nonatomic, assign) AlertActionType actionType;
@property (nonatomic, copy) void(^callback)(void);
@property (nonatomic, strong) SLTabbarButton *button;
/**
AlertActionCancel -- default  SLUIHexColor(0x007aff)
AlertActionDefault -- default SLUIHexColor(0x007aff)
AlertActionDestructive -- default SLUIHexColor(0xff0000)
*/
@property (nonatomic, strong) UIColor *titleColor;
/**
 AlertActionCancel -- default SLUIBoldFont(17.0)
 AlertActionDefault -- default SLUINormalFont(17.0)
 AlertActionDestructive -- default SLUINormalFont(17.0)
 */
@property (nonatomic, strong) UIFont *titleFont;
@end

@interface SLAlertView : SLView
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, strong, readonly) NSArray<SLAlertAction *> *actionArray;
@property (nonatomic, strong, readonly) NSArray<SLView *> *lineViewArray;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) SLView *titleLineView;// title的分割线
@property (nonatomic, strong) SLTabbarView *buttonView;// 按钮容器视图
- (instancetype)initWithType:(AlertType)type
                       title:(NSString * _Nullable)title
                     message:(NSString * _Nullable)message;
- (void)addActionWithTitle:(NSString *)title
                      type:(AlertActionType)type
                  callback:(void(^)(void))callback;
- (void)addCustomView:(UIView *)customView
            alignment:(AlertContentViewAlignmentType)alignmentType;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
