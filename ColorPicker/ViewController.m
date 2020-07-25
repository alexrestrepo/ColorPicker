//
//  ViewController.m
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import "ViewController.h"

#import "ColorWheelView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    ColorWheelView *wheel = [[ColorWheelView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    wheel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                              | UIViewAutoresizingFlexibleBottomMargin
                              | UIViewAutoresizingFlexibleLeftMargin
                              | UIViewAutoresizingFlexibleRightMargin);
    wheel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:wheel];
}

@end
