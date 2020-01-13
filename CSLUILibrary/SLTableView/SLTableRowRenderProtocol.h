//
//  SLTableRowRenderProtocol.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLTableRowProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SLTableRowRenderProtocol <NSObject>
- (void)renderWithRowModel:(id<SLTableRowProtocol>)row;
@end

NS_ASSUME_NONNULL_END
