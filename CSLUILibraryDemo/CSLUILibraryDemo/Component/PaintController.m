//
//  PaintController.m
//  CSLUILibraryDemo
//
//  Created by 程石亮(寿险总部人工智能研发团队AI平台领域AI应用平台组) on 2020/5/25.
//  Copyright © 2020 csl. All rights reserved.
//

#import "PaintController.h"

@interface PaintController ()
{
    NSArray *_colors;
    NSInteger _currentIndex;
    NSArray *_widths;
    NSInteger _currentWidth;
    UIColor *_paintColor;
}
@property (weak, nonatomic) IBOutlet SLPaintView *paintView;
@end

@implementation PaintController

- (void)viewDidLoad {
    [super viewDidLoad];
    _colors = @[[UIColor blueColor],[UIColor redColor],[UIColor greenColor],[UIColor yellowColor]];
    _widths = @[@1,@2,@3,@4,@5];
    _currentIndex = 0;
    _currentWidth = 0;
    self.paintView.backgroundColor = [UIColor blackColor];
    self.paintView.lineColor = _colors[_currentIndex];
    self.paintView.lineWidth = [_widths[_currentWidth] integerValue];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.paintView show];
}
- (IBAction)clean:(id)sender {
    [self.paintView clearScreen];
}
- (IBAction)back:(id)sender {
    [self.paintView undo];
}
- (IBAction)forword:(id)sender {
    [self.paintView redo];
}
- (IBAction)ajustWidth:(id)sender {
    if (_currentWidth == _widths.count - 1) {
        _currentWidth = 0;
    } else {
        _currentWidth ++;
    }
    self.paintView.lineWidth = [_widths[_currentWidth] integerValue];
}
- (IBAction)ajustColor:(SLButton *)sender {
    if (_currentIndex == _colors.count - 1) {
        _currentIndex = 0;
    } else {
        _currentIndex ++;
    }
    self.paintView.lineColor = _colors[_currentIndex];
}
- (IBAction)eraser:(id)sender {
    [self.paintView eraser];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
