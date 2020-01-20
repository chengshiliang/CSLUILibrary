//
//  SLCollectManager.h
//  CSLUILibrary
//
//  Created by SZDT00135 on 2020/1/13.
//

#import <Foundation/Foundation.h>
#import <CSLUILibrary/SLCollectSectionProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@class SLCollectProxy;
@interface SLCollectManager : NSObject
@property (nonatomic, weak) SLCollectBaseView *collectView;
@property (nonatomic, strong) NSMutableDictionary<Class,NSString *> *cellClasses;
@property (nonatomic, strong) NSMutableDictionary<UINib *,NSString *> *cellNibs;
@property (nonatomic, strong) NSMutableArray<id<SLCollectSectionProtocol>> *sections;
@property (nonatomic, strong) SLCollectProxy *delegateHandler;
@property (nonatomic, copy) void(^selectCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayCell)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^scrollCallback)(SLCollectBaseView *collectView);
- (id)initWithSections:(NSArray<id<SLCollectSectionProtocol>> *)sections delegateHandler:(SLCollectProxy *_Nullable)handler;

- (void)bindToCollectView:(SLCollectBaseView *)collectView;

- (id<SLCollectRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
