//
//  SLHorizontalCollectionViewLayout.h
//  CSLCommonLibrary
//
//  Created by SZDT00135 on 2019/11/25.
//

#import <UIKit/UIKit.h>
#import <CSLUILibrary/SLCollectRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLHorizontalCollectionViewLayout : UICollectionViewLayout
@property(copy,nonatomic) NSArray<id<SLCollectRowProtocol>> *data;
@property(assign,nonatomic) float columnMagrin;//列距离
@end

NS_ASSUME_NONNULL_END
