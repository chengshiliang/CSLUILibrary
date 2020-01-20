//
//  SLRecycleCollectionLayout.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SLRecycleCollectionViewStyle) {
    SLRecycleCollectionViewStylePage = 0, /** 分页 必须等宽或高*/
    SLRecycleCollectionViewStyleStep   /** 渐进 可以不等宽或高*/
};
@interface SLRecycleCollectionLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) SLRecycleCollectionViewStyle scrollStyle;
@end

NS_ASSUME_NONNULL_END
