//
//  ViewController.m
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import "ColorWheelView.h"
#import "ColorSlider.h"

@interface ViewController () <ColorWheelViewDelegate>
@property (nonatomic, strong) ColorWheelView *wheel;
@property (nonatomic, strong) ColorSlider *slider;
@property (nonatomic, strong) AlphaSlider *alpha;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor lightGrayColor];

    _wheel = [[ColorWheelView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _wheel.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin
                              | UIViewAutoresizingFlexibleBottomMargin
                              | UIViewAutoresizingFlexibleLeftMargin
                              | UIViewAutoresizingFlexibleRightMargin);
    _wheel.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    _wheel.delegate = self;
    [_wheel addTarget:self action:@selector(onColorUpdated:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_wheel];

    _slider = [[ColorSlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_wheel.frame),
                                                            CGRectGetMaxY(_wheel.frame) + 20,
                                                            CGRectGetWidth(_wheel.bounds), 36.0)];
    [_slider addTarget:self action:@selector(onBrightessUpdate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_slider];

    _alpha = [[AlphaSlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_slider.frame),
                                                            CGRectGetMaxY(_slider.frame) + 20,
                                                            CGRectGetWidth(_slider.bounds), 36.0)];
    [self.view addSubview:_alpha];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _slider.frame = CGRectMake(CGRectGetMinX(_wheel.frame),
                               CGRectGetMaxY(_wheel.frame) + 10,
                               CGRectGetWidth(_wheel.bounds), 36.0);
    _alpha.frame = CGRectMake(CGRectGetMinX(_slider.frame),
                              CGRectGetMaxY(_slider.frame) + 20,
                              CGRectGetWidth(_slider.bounds), 36.0);
}

- (void)colorWheelViewDidSnapToCenter:(ColorWheelView *)view {
    AudioServicesPlaySystemSound(1519);
}

- (void)onColorUpdated:(ColorWheelView *)wheel {
    _alpha.selectedColor = wheel.selectedColor;
    _slider.selectedColor = wheel.selectedColor;
}

- (void)onBrightessUpdate:(ColorSlider *)slider {
    _wheel.selectedColor = slider.selectedColor;
    _alpha.selectedColor = slider.selectedColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end
