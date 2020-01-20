//
//  SLCollectModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLCollectModel.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/SLCollectBaseView.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLCollectManager.h>

@implementation SLCollectRowModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.registerName = NSStringFromClass([UICollectionViewCell class]);
        self.type = SLCollectRowTypeCode;
        self.rowHeight = 44.0;
        self.rowWidth = 30.0;
        self.reuseIdentifier = NSStringFromClass([self class]);
    }
    return self;
}

- (CollectCellForRow)cellForRowBlock{
    WeakSelf;
    return ^UICollectionViewCell *(SLCollectBaseView * _Nonnull collectView, NSIndexPath * _Nonnull indexPath) {
        StrongSelf;
        SLCollectManager *manager = collectView.manager;
        switch (strongSelf.type) {
            case SLCollectRowTypeCode:{
                if ([NSString emptyString:strongSelf.reuseIdentifier]) break;
                if (manager && !collectView.manager.cellClasses[strongSelf.reuseIdentifier] && NSClassFromString(strongSelf.registerName)) {
                    [collectView registerClass:NSClassFromString(strongSelf.registerName) forCellWithReuseIdentifier:strongSelf.reuseIdentifier];
                    collectView.manager.cellClasses[strongSelf.reuseIdentifier] = NSClassFromString(strongSelf.registerName);
                }
            }
                break;
            case SLCollectRowTypeXib:{
                if (manager && !collectView.manager.cellClasses[strongSelf.reuseIdentifier]) {
                    UINib *nib = [UINib nibWithNibName:strongSelf.registerName bundle:nil];
                    if (nib) {
                        [collectView registerNib:nib forCellWithReuseIdentifier:strongSelf.reuseIdentifier];
                        collectView.manager.cellNibs[strongSelf.reuseIdentifier] = nib;
                    }
                }
            }
                break;
            default:
                break;
        }
        UICollectionViewCell *cell = [collectView dequeueReusableCellWithReuseIdentifier:strongSelf.reuseIdentifier forIndexPath:indexPath];
        
        return cell;
    };
}
@end

@implementation SLCollectSectionModel
- (id)mutableCopyWithZone:(NSZone *)zone {
    id<SLCollectSectionProtocol>model = [[[self class]allocWithZone:zone]init];
    model.titleForHeader = self.titleForHeader.copy;
    model.heightForHeader = self.heightForHeader;
    model.widthForHeader = self.widthForHeader;
    model.heightForFooter = self.heightForFooter;
    model.widthForFooter = self.widthForFooter;
    model.sectionIndexTitle = self.sectionIndexTitle.copy;
    model.minimumLineSpacing = self.minimumLineSpacing;
    model.minimumInteritemSpacing = self.minimumInteritemSpacing;
    model.insetForSection = self.insetForSection;
    model.viewForHeader = [self.viewForHeader copyWithZone:zone];
    model.viewForFooter = [self.viewForFooter copyWithZone:zone];
    model.rows = [self.rows mutableCopyWithZone:zone];
    return model;
}
@end

@implementation SLCollectModel
@end
