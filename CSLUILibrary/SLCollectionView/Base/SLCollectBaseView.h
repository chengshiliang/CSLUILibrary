//
//  SLCollectBaseView.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectManager;
@interface SLCollectBaseView : UICollectionView
@property (nonatomic, strong) SLCollectManager *manager;
@end

NS_ASSUME_NONNULL_END
