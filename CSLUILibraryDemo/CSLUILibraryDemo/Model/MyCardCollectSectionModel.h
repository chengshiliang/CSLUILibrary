//
//  MyCardCollectSectionModel.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2020/1/20.
//  Copyright © 2020 csl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCardCollectSectionModel : SLCollectSectionModel

@end

@interface StaticCollectionModel : SLCollectRowModel
@property (nonatomic, copy) NSString *str;
@end

NS_ASSUME_NONNULL_END
