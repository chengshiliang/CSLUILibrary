//
//  RecycleViewController.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/5.
//  Copyright © 2019 csl. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN
@interface RecycleViewModel : SLModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageUrl;
@end
@interface RecycleViewController : BaseController

@end

NS_ASSUME_NONNULL_END
