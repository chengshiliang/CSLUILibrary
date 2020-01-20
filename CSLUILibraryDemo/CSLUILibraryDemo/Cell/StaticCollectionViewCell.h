//
//  StaticCollectionViewCell.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/25.
//  Copyright © 2019 csl. All rights reserved.
//

#import "SLCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface StaticCollectionViewCell : SLCollectionViewCell<SLCollectRowRenderProtocol>
@property (nonatomic, copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
