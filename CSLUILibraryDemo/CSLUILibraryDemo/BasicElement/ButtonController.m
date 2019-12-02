//
//  ButtonController.m
//  CSLUILibraryDemo
//
//  Created by SZDT00135 on 2019/12/2.
//  Copyright © 2019 csl. All rights reserved.
//

#import "ButtonController.h"

@interface ButtonController ()
@property (nonatomic, weak) IBOutlet SLButton *button1;
@property (nonatomic, weak) IBOutlet SLButton *button2;
@property (nonatomic, weak) IBOutlet SLButton *button3;
@property (nonatomic, weak) IBOutlet SLButton *button4;
@property (nonatomic, weak) IBOutlet SLButton *button5;
@property (nonatomic, weak) IBOutlet SLButton *button6;
@end

@implementation ButtonController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.button1 addCornerRadius:15.0f borderWidth:0.0 borderColor:[UIColor clearColor] backGroundColor:[UIColor redColor]];
    
    [self.button2 addCornerRadius:15.0f borderWidth:2.0 borderColor:[UIColor yellowColor] backGroundColor:[UIColor redColor]];
    
    [self.button3 addCornerRadius:0.0f borderWidth:1.0 borderColor:[UIColor yellowColor] backGroundColor:[UIColor redColor]];
    
    [self.button4 addCornerRadius:15.0f borderWidth:1.0 borderColor:[UIColor yellowColor] backGroundColor:[UIColor clearColor]];
    
    [self.button5 addCornerRadius:15.0f borderWidth:0.0 borderColor:[UIColor yellowColor] backGroundColor:[UIColor clearColor]];
    
    [self.button6 addCornerRadius:0.0f borderWidth:1.0 borderColor:[UIColor yellowColor] backGroundColor:[UIColor clearColor]];
}

@end
