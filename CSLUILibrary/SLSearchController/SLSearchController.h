//
//  SLSearchController.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/8.
//

#import "SLViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface SLSearchController : SLViewController
/**
 parentvc: 装载searchvc的容器
 resultvc为显示结果的容器，此处可自定义传进来，内部有一个默认的
 selectBlock 为内部searchResultVC进行选择结果的回调，外部如果自定义实现resultvc，则此处可为nil
 */
+ (instancetype)initWithParentVC:(UIViewController *)parentvc
                  searchResultVC:(UIViewController *_Nullable)resultVC
                     selectBlock:(void(^ _Nullable)(SLSearchController *vc,id data))selectBlock
               searchResultBlock:(NSArray *(^ _Nullable)(SLSearchController *vc, NSString *str))searchResultBlock;
- (void)show;// 在调用此方法之前，不要触发viewDidload().类似:SLSearchController.view.background都不要提前调用
- (void)dismiss;
@property (nonatomic, strong) UIImage *searchIcon;
@property (nonatomic, assign) CGFloat leftMargin;// default 16.0f
@property (nonatomic, assign) CGFloat rightMargin;// default 16.0f
@property (nonatomic, assign) CGFloat searchBarMargin;// default 10.0f
@property (nonatomic, strong) UIColor *searchBarTextColor;// default black color
@property (nonatomic, strong) UIColor *searchBarBackgroundColor;// default clear color
@property (nonatomic, copy) NSString *searchBarPlaceHolder;// default 请输入想搜索的内容
@property (nonatomic, copy) NSString *searchBarDefaultValue;// 输入框的默认添加的值
@property (nonatomic, assign) CGFloat searchBarRadius;// default 5.0f
@property (nonatomic, assign) CGFloat searchBarBorderWidth;// default 1.0f
@property (nonatomic, strong) UIColor *searchBarBorderColor;// default 0xe0e0e0
@property (nonatomic, assign) CGFloat contentLeftMargin;// default 16.0f
@property (nonatomic, assign) CGFloat cancelButtonBorderWidth;// default 0.0f
@property (nonatomic, strong) UIColor *cancelButtonBorderColor;// default clear color
@property (nonatomic, assign) CGFloat cancelButtonRadius;// default 0.0f
@property (nonatomic, assign) CGFloat contentRightMargin;// default 16.0f
@property (nonatomic, strong) UIColor *cancelButtonTextColor;// default black color
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;// default clear color
@property (nonatomic, copy) NSString *cancelButtonText;// default 取消
@property (nonatomic, strong) UIFont *searchBarTextFont;// default system 17.0f
@property (nonatomic, strong) UIFont *cancelButtonTextFont;// default system 14.0f
@end

NS_ASSUME_NONNULL_END
