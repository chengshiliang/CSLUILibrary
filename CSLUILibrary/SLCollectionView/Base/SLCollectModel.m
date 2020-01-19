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
        switch (strongSelf.type) {
            case SLCollectRowTypeCode:{
                if ([NSString emptyString:strongSelf.reuseIdentifier]) break;
                if (!collectView.manager.cellClasses[strongSelf.reuseIdentifier] && NSClassFromString(strongSelf.registerName)) {
                    [collectView registerClass:NSClassFromString(strongSelf.registerName) forCellWithReuseIdentifier:strongSelf.reuseIdentifier];
                    collectView.manager.cellClasses[strongSelf.reuseIdentifier] = NSClassFromString(strongSelf.registerName);
                }
            }
                break;
            case SLCollectRowTypeXib:{
                if (!collectView.manager.cellClasses[strongSelf.reuseIdentifier]) {
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
@end

@implementation SLCollectModel
@end
