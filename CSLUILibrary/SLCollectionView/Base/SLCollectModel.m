//
//  SLCollectModel.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLCollectModel.h"
#import <CSLUILibrary/SLUIConsts.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLCollectBaseView.h>
#import <CSLUILibrary/NSString+Util.h>
#import <CSLUILibrary/SLCollectManager.h>

@implementation SLCollectRowModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.registerName = NSStringFromClass([UICollectionViewCell class]);
        self.type = SLCollectTypeCode;
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
            case SLCollectTypeCode:{
                if ([NSString emptyString:strongSelf.reuseIdentifier]) break;
                Class class = NSClassFromString(strongSelf.registerName);
                if (manager && !collectView.manager.cellClasses[strongSelf.reuseIdentifier] && class) {
                    [collectView registerClass:class forCellWithReuseIdentifier:strongSelf.reuseIdentifier];
                    collectView.manager.cellClasses[strongSelf.reuseIdentifier] = class;
                }
            }
                break;
            case SLCollectTypeXib:{
                UINib *nib = [UINib nibWithNibName:strongSelf.registerName bundle:nil];
                if (manager && !collectView.manager.cellClasses[strongSelf.reuseIdentifier] && nib) {
                    [collectView registerNib:nib forCellWithReuseIdentifier:strongSelf.reuseIdentifier];
                    collectView.manager.cellNibs[strongSelf.reuseIdentifier] = nib;
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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerType = SLCollectTypeCode;
        self.footerType = SLCollectTypeCode;
        self.headerRegisterName = NSStringFromClass([UIView class]);
        self.footerRegisterName = NSStringFromClass([UIView class]);
    }
    return self;
}
- (HeaderFooterCollect)viewForHeader{
    WeakSelf;
    return ^UICollectionReusableView * _Nullable(SLCollectBaseView *collectView, NSIndexPath *indexPath) {
        StrongSelf;
        if ([NSString emptyString:strongSelf.headerReuseIdentifier]) return nil;
        SLCollectManager *manager = collectView.manager;
        switch (strongSelf.headerType) {
            case SLCollectTypeCode:{
                Class headerClass = NSClassFromString(strongSelf.headerRegisterName);
                if (manager && !collectView.manager.cellClasses[strongSelf.headerReuseIdentifier] && headerClass) {
                    [collectView registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strongSelf.headerReuseIdentifier];
                    collectView.manager.cellClasses[strongSelf.headerReuseIdentifier] = headerClass;
                }
            }
                break;
            case SLCollectTypeXib:{
                UINib *nib = [UINib nibWithNibName:strongSelf.headerRegisterName bundle:nil];
                if (manager && !collectView.manager.cellClasses[strongSelf.headerReuseIdentifier] && nib) {
                    [collectView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strongSelf.headerReuseIdentifier];
                    collectView.manager.cellNibs[strongSelf.headerReuseIdentifier] = nib;
                }
            }
                break;
            default:
                break;
        }
        UICollectionReusableView *view = [collectView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:strongSelf.headerReuseIdentifier forIndexPath:indexPath];
        return view;
    };
}
- (HeaderFooterCollect)viewForFooter{
    WeakSelf;
    return ^UICollectionReusableView * _Nullable(SLCollectBaseView *_Nullable collectView, NSIndexPath *indexPath) {
        StrongSelf;
        if ([NSString emptyString:strongSelf.footerReuseIdentifier]) return nil;
        SLCollectManager *manager = collectView.manager;
        switch (strongSelf.footerType) {
            case SLCollectTypeCode:{
                Class headerClass = NSClassFromString(strongSelf.footerRegisterName);
                if (manager && !collectView.manager.cellClasses[strongSelf.footerReuseIdentifier] && headerClass) {
                    [collectView registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:strongSelf.footerReuseIdentifier];
                    collectView.manager.cellClasses[strongSelf.footerReuseIdentifier] = headerClass;
                }
            }
                break;
            case SLCollectTypeXib:{
               UINib *nib = [UINib nibWithNibName:strongSelf.footerRegisterName bundle:nil];
               if (manager && !collectView.manager.cellClasses[strongSelf.footerReuseIdentifier] && nib) {
                   [collectView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:strongSelf.footerReuseIdentifier];
                   collectView.manager.cellNibs[strongSelf.footerReuseIdentifier] = nib;
               }
            }
                break;
            default:
                break;
        }
        UICollectionReusableView *view = [collectView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:strongSelf.footerReuseIdentifier forIndexPath:indexPath];
        return view;
    };
}
@end

@implementation SLCollectModel
@end
