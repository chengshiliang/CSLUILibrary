//
//  SLCollectRowRenderProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLCollectSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLCollectRowRenderProtocol <NSObject>
@optional
- (void)renderWithRowModel:(id<SLCollectRowProtocol>)row;
- (void)renderHeaderWithSectionModel:(id<SLCollectSectionProtocol>)sec;
- (void)renderFooterWithSectionModel:(id<SLCollectSectionProtocol>)sec;
@end

NS_ASSUME_NONNULL_END
