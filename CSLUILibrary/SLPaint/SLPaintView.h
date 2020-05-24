//
//  SLPaintView.h
//  CSLUILibrary
//
//  Created by 程石亮(寿险总部人工智能研发团队AI平台领域AI应用平台组) on 2020/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPaintView : UIView
@property (nonatomic, copy) void(^linesChanged)(NSArray *appearLines, NSArray *undoLines, NSInteger num);
@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic,   copy) NSArray * appearLines;// 之前画过的线条
@property (nonatomic,   copy) NSArray * undoLines;  // 之前取消了的线条
- (void)show;

- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
