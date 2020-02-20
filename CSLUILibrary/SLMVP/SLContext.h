//
//  SLContext.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/2/19.
//

#import <Foundation/Foundation.h>
#import "NSObject+SLContext.h"

NS_ASSUME_NONNULL_BEGIN
@class SLContext;
@class SLBaseView;

@interface SLPresenter : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@property (nonatomic, weak) SLBaseView*                    view;
@property (nonatomic, strong) id                          adapter;
@end

@interface SLInteractor : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@end


@interface SLBaseView : UIView
@property (nonatomic, weak) SLPresenter*               presenter;
@property (nonatomic, weak) SLInteractor*              interactor;
@end

@interface SLContext : NSObject
@property (nonatomic, strong) SLPresenter*           presenter;
@property (nonatomic, strong) SLInteractor*          interactor;
@property (nonatomic, strong) SLBaseView*                view;
@end
NS_ASSUME_NONNULL_END
