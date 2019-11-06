//
//  SLCollectionViewCell.m
//  CSLUILibrary
//
//  Created by SZDT00135 on 2019/11/5.
//

#import "SLCollectionViewCell.h"
#import <CSLUILibrary/SLImageView.h>
#import <CSLUILibrary/SLUIConsts.h>

@interface SLCollectionViewCell()
@property(strong,nonatomic)SLImageView *imageView;
@end

@implementation SLCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SLUIColor(arc4random()/255,arc4random()/200,arc4random()/100);
        self.imageView = [[SLImageView alloc]initWithFrame:frame];
        [self addSubview:self.imageView];
    }
    return self;
}
-(void)setModel:(SLModel *)model {
//    self.imageView.frame = self.bounds;
    NSLog(@"MODEL IMAGE%@", model.imageUrl);
    _model = model;
    [self.imageView sl_setImage:[UIImage imageNamed:model.imageUrl]];
}
@end
