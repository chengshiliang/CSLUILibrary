//
//  ViewController.h
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/10/31.
//  Copyright © 2019 csl. All rights reserved.
//

#import "BaseController.h"

@interface MyTableRowModel: SLTableRowModel
@property (nonatomic, copy) NSString *title;
@end
@interface MyTableSectionModel : SLTableSectionModel
@property (nonatomic, copy) NSString *title;
@end
@interface ViewController : BaseController


@end

