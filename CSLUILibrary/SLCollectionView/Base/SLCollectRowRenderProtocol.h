//
//  SLCollectRowRenderProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLCollectRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLCollectRowRenderProtocol <NSObject>
- (void)renderWithRowModel:(id<SLCollectRowProtocol>)row;
@end

NS_ASSUME_NONNULL_END