//
//  SLCollectRowProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

@class SLCollectBaseView;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SLCollectType) {
    SLCollectTypeXib = 1,
    SLCollectTypeCode
};

typedef UICollectionViewCell *_Nonnull(^CollectCellForRow)(SLCollectBaseView *_Nonnull collectionView, NSIndexPath *_Nonnull indexPath);

@protocol SLCollectRowProtocol <NSObject>
@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat rowWidth;

@property (nonatomic, assign) SLCollectType type;

///XIB Name or Class Name
@property (nonatomic, copy) NSString *registerName;

@property (nonatomic, copy) CollectCellForRow cellForRowBlock;
@end

NS_ASSUME_NONNULL_END

