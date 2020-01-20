//
//  SLCollectBaseView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/12.
//

#import "SLCollectBaseView.h"
#import <CSLUILibrary/SLCollectManager.h>

@implementation SLCollectBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame collectionViewLayout:[UICollectionViewFlowLayout new]]) {
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
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

@end
