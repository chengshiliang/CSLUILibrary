//
//  SLCardCollectViewFlowLayout.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SLModel;
@interface SLCardCollectViewFlowLayout : UICollectionViewFlowLayout
@property(copy,nonatomic) NSArray<SLModel *> *data;
@end

NS_ASSUME_NONNULL_END
