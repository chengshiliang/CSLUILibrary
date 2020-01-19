//
//  SLCollectRowProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>

@class SLCollectBaseView;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SLCollectRowType) {
    SLCollectRowTypeXib,
    SLCollectRowTypeCode
};

typedef UICollectionViewCell *_Nonnull(^CollectCellForRow)(SLCollectBaseView *_Nonnull collectionView, NSIndexPath *_Nonnull indexPath);

@protocol SLCollectRowProtocol <NSObject>
@property (nonatomic, strong) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat rowWidth;

@property (nonatomic, assign) SLCollectRowType type;

///XIB Name or Class Name
@property (nonatomic, strong) NSString *registerName;

@property (nonatomic, copy) CollectCellForRow cellForRowBlock;
@end

NS_ASSUME_NONNULL_END

