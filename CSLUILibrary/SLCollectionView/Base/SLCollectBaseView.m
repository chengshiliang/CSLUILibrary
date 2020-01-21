//
//  SLCollectBaseView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLCollectBaseView.h"
#import <CSLUILibrary/SLCollectManager.h>
#import <CSLUILibrary/SLUIConsts.h>

@implementation SLCollectBaseView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self == [super initWithFrame:frame collectionViewLayout:layout]) {
        [self initial];
    }
    return self;
}

- (void)setManager:(SLCollectManager *)manager {
    _manager = manager;
    [manager bindToCollectView:self];
}

- (void)initial {
    if (@available(iOS 11, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    self.bounces = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.backgroundColor = SLUIHexColor(0xffffff);
}

@end
