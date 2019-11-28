//
//  RuiXingCoffeeHomeHeaderView.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/11/27.
//  Copyright © 2019 csl. All rights reserved.
//

#import "RuiXingCoffeeHomeHeaderView.h"
#import "StaticCollectionViewController.h"
#import "StaticCollectionViewCell.h"
#import <CSLCommonLibrary/NSNotificationCenter+Base.h>

@interface RuiXingCoffeeHomeHeaderView()<SLCollectionViewProtocol>
{
    NSArray *dataSource;
}
@end

@implementation RuiXingCoffeeHomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.recycleView = [[SLRecycleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth*2.0/3)];
    self.recycleView.imageDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    self.recycleView.titleDatas=@[@"cir0",@"cir1",@"cir2",@"cir3"];
    [self addSubview:self.recycleView];
    [self.recycleView startLoading];
    self.noRuleCollectionView = [[SLNoRuleCollectionView alloc]initWithFrame:CGRectMake(0, kScreenWidth*2.0/3, kScreenWidth, kScreenWidth*3.0/4)];
    [self addSubview:self.noRuleCollectionView];
    
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        SLPupModel *pupModel = [SLPupModel new];
        CGFloat width = 0;
        CGFloat height = 0;
        switch (i) {
            case 0:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.5;
            }
                break;
            case 1:
            {
                width = kScreenWidth*0.5;
                height = kScreenWidth*0.25;
            }
                break;
            case 2:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 3:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            case 4:
            {
                width = kScreenWidth*0.75;
                height = kScreenWidth*0.25;
            }
                break;
            case 5:
            {
                width = kScreenWidth*0.25;
                height = kScreenWidth*0.25;
            }
                break;
            default:
                break;
        }
        pupModel.width = width;
        pupModel.height = height;
        StaticCollectionModel *model = [StaticCollectionModel new];
        model.str = [NSString stringWithFormat:@"COUNT%@", @(i)];
        pupModel.data = model;
        [arrM addObject:pupModel];
    }
    dataSource = arrM.copy;
    self.noRuleCollectionView.dataSource = arrM.copy;
    self.noRuleCollectionView.delegate = self;
    self.noRuleCollectionView.columns = 4;
    self.noRuleCollectionView.columnMagrin = 5.0f;
    self.noRuleCollectionView.rowMagrin = 5.0f;
    self.noRuleCollectionView.insets = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.noRuleCollectionView reloadData];
}

static NSString *const cellId3 = @"kNoRuleCollectionViewCellID";

- (void)registerCell:(SLCollectionView *)collectionView forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
        [collectionView registerNib:[UINib nibWithNibName:@"StaticCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellId3];
    }
}

- (SLCollectionViewCell *)collectionView:(SLCollectionView *)collectionView customCellForItemAtIndexPath:(NSIndexPath *)indexPath forView:(SLView *)view {
    if ([view isKindOfClass:[SLNoRuleCollectionView class]]) {
        StaticCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId3 forIndexPath:indexPath];
        SLPupModel *pupModel = dataSource[indexPath.row];
        StaticCollectionModel *model = (StaticCollectionModel *)pupModel.data;
        cell.title = model.str;
        if (indexPath.row%3==0) {
            cell.backgroundColor = [UIColor redColor];
        } else if (indexPath.row%3==1) {
            cell.backgroundColor = [UIColor greenColor];
        } else if (indexPath.row%3==2) {
            cell.backgroundColor = [UIColor blueColor];
        }
        return cell;
   }
    return nil;
}

/**
 - (void)swizzAppearMethod:(NSObject *)target callback:(void(^)(__unsafe_unretained NSObject *appearObj))callback {
     @synchronized (swizzledClasses()) {
         NSMutableArray *callbackArrayM = objc_getAssociatedObject(target, ClassAppearAssociationKey);
         if (!callbackArrayM) {
             callbackArrayM = [NSMutableArray array];
         }
         [callbackArrayM addObject:[callback copy]];
         objc_setAssociatedObject(target, ClassAppearAssociationKey, callbackArrayM.mutableCopy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
         Class classToSwizzle = target.class;
         NSString *className = [NSStringFromClass(classToSwizzle) stringByAppendingString:@"Appear"];
         if ([swizzledClasses() containsObject:className]) return;
         SEL appearSelector = sel_registerName("viewDidAppear:");
         __block void (*originalAppear)(__unsafe_unretained id, SEL) = NULL;
         id newDisappear = ^(__unsafe_unretained NSObject *appearObj) {
             NSMutableArray *realCallbackArray = objc_getAssociatedObject(appearObj, ClassAppearAssociationKey);
             if (realCallbackArray) {
                 for (void(^currentCallback)(__unsafe_unretained NSObject *appearObj) in realCallbackArray) {
                     if (currentCallback) {
                         currentCallback(appearObj);
                     }
                 }
                 objc_setAssociatedObject(appearObj, ClassAppearAssociationKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
             }
             if (originalAppear == NULL) {
                 struct objc_super superInfo = {
                     .receiver = appearObj,
                     .super_class = class_getSuperclass(classToSwizzle)
                 };
                 
                 void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                 msgSend(&superInfo, appearSelector);
             } else {
                 originalAppear(appearObj, appearSelector);
             }
         };
         
         IMP newDisappearIMP = imp_implementationWithBlock(newDisappear);
         Method appearMethod = class_getInstanceMethod(classToSwizzle, appearSelector);
         if (!class_addMethod(classToSwizzle, appearSelector, newDisappearIMP, method_getTypeEncoding(appearMethod))) {
             originalAppear = (__typeof__(originalAppear))method_getImplementation(appearMethod);
             originalAppear = (__typeof__(originalAppear))method_setImplementation(appearMethod, newDisappearIMP);
         }
         [swizzledClasses() addObject:className];
     }
 }
 */
@end
