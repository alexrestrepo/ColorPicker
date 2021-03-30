//
//  ViewController.m
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import "ViewController.h"

#import "PickerViewController.h"

@interface ViewController () <PickerViewControllerDelegate>
@property (nonatomic, strong) UIButton *pickerButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    _pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_pickerButton setTitle:@"Colors..." forState:UIControlStateNormal];
    [_pickerButton sizeToFit];
    _pickerButton.frame = CGRectInset(_pickerButton.bounds, -15, -5);
    _pickerButton.backgroundColor = [UIColor whiteColor];
    _pickerButton.layer.cornerRadius = 8;
    [_pickerButton addTarget:self action:@selector(onPickColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pickerButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) - CGRectGetHeight(_pickerButton.bounds) - 40);
}

- (void)onPickColor:(UIButton *)sender {
    PickerViewController *picker = [[PickerViewController alloc] initWithColor:_pickerButton.backgroundColor];
    picker.delegate = self;
    picker.popoverPresentationController.sourceView = _pickerButton;
    picker.popoverPresentationController.sourceRect = _pickerButton.bounds;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)pickerControllerDidSelectColor:(PickerViewController *)controller {
    _pickerButton.backgroundColor = controller.selectedColor;
}

@end
