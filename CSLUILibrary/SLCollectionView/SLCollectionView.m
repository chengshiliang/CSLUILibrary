//
//  SLCollectionView.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLCollectionView.h"

@implementation SLCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self == [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = YES;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return self;
}
@end
