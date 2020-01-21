//
//  SLTableRowRenderProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLTableRowRenderProtocol <NSObject>
@optional
- (void)renderWithRowModel:(id<SLTableRowProtocol>)row;
- (void)renderHeaderWithSectionModel:(id<SLTableSectionProtocol>)sec;
- (void)renderFooterWithSectionModel:(id<SLTableSectionProtocol>)sec;
@end

NS_ASSUME_NONNULL_END
