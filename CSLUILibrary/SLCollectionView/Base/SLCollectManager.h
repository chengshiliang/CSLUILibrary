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
@property (nonatomic, strong) NSMutableDictionary<NSString *,Class> *cellClasses;
@property (nonatomic, strong) NSMutableDictionary<NSString *,UINib *> *cellNibs;
@property (nonatomic, strong) NSMutableArray<id<SLCollectSectionProtocol>> *sections;
@property (nonatomic, strong) SLCollectProxy *delegateHandler;
@property (nonatomic, copy) void(^selectCollectView)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayCell)(SLCollectBaseView *collectView, UICollectionViewCell *cell, NSIndexPath *indexPath, id<SLCollectRowProtocol>rowModel);
@property (nonatomic, copy) void(^displayHeader)(SLCollectBaseView *collectView, UIView *view, NSInteger section, id<SLCollectSectionProtocol>secModel);
@property (nonatomic, copy) void(^displayFooter)(SLCollectBaseView *collectView, UIView *view, NSInteger section, id<SLCollectSectionProtocol>secModel);
@property (nonatomic, copy) void(^scrollViewDidEndDeceleratingCallback)(SLCollectBaseView *collectView);
@property (nonatomic, copy) void(^scrollViewDidScrollCallback)(SLCollectBaseView *collectView);
@property (nonatomic, copy) void(^scrollViewWillBeginDraggingCallback)(SLCollectBaseView *collectView);
@property (nonatomic, copy) void(^scrollViewDidEndDraggingCallback)(SLCollectBaseView *collectView, BOOL decelerate);
@property (nonatomic, copy) void(^scrollViewDidEndScrollingAnimationCallback)(SLCollectBaseView *collectView);
- (id)initWithSections:(NSMutableArray<id<SLCollectSectionProtocol>> *)sections delegateHandler:(SLCollectProxy *_Nullable)handler;

- (void)bindToCollectView:(SLCollectBaseView *)collectView;

- (id<SLCollectRowProtocol>)rowAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
