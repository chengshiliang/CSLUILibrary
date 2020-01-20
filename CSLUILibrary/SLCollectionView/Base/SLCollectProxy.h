//
//  SLCollectProxy.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectManager;
@interface SLCollectProxy : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) SLCollectManager *collectManager;
@end

@interface SLCollectFlowlayoutProxy : SLCollectProxy<UICollectionViewDelegateFlowLayout>

@end
@interface SLCollectScrollProxy : SLCollectProxy<UIScrollViewDelegate>

@end
@interface SLCollectRecycleProxy : SLCollectScrollProxy<UICollectionViewDelegateFlowLayout>

@end
NS_ASSUME_NONNULL_END
