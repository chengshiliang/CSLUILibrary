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

@interface MyPupCollectSectionModel : SLCollectSectionModel

@end

@interface StaticCollectionModel : SLCollectRowModel
@property (nonatomic, copy) NSString *str;
@end

@interface MyPupCollectRowModel : SLCollectRowModel
@property (nonatomic, strong) UIColor *color;
@end

@interface MyStaticCollectSectionModel : SLCollectSectionModel

@end

@interface MyStaticCollectRowModel : SLCollectRowModel
@property (nonatomic, copy) NSString *str;
@end

@interface MyNoRuleCollectSectionModel : SLCollectSectionModel

@end

@interface MyNoRuleCollectRowModel : SLCollectRowModel
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *str;
@end
@interface MyRecycleSectionModel : SLCollectSectionModel

@end
@interface MyRecycleRowModel : SLCollectRowModel
@property (nonatomic, copy) NSString *str;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIColor *color;
@end
@interface MyTableRowModel: SLTableRowModel
@property (nonatomic, copy) NSString *title;
@end
@interface MyTableSectionModel : SLTableSectionModel
@property (nonatomic, copy) NSString *title;
@end
@interface MyCollectRowModel: SLCollectRowModel
@property (nonatomic, copy) NSString *title;
@end
@interface RuixingCoffeeSectionModel : SLCollectSectionModel
@property (nonatomic, strong) MyRecycleSectionModel *recycleModel;
@property (nonatomic, strong) MyNoRuleCollectSectionModel *noRuleModel;
@end
@interface RuixingCoffeeRowModel : SLCollectRowModel

@end
@interface DropDownSectionModel : SLCollectSectionModel
@property (nonatomic, copy) NSString *title;
@end
@interface DropDownRowModel : SLCollectRowModel
@property (nonatomic, copy) NSString *title;
@end
@interface DropDownTableSectionModel : SLTableSectionModel
@property (nonatomic, copy) NSString *title;
@end
@interface DropDownTableRowModel : SLTableRowModel
@property (nonatomic, copy) NSString *title;
@end
NS_ASSUME_NONNULL_END
