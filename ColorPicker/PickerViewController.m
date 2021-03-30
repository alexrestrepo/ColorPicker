//
//  PickerViewController.m
//  ColorPicker
//
//  Created by Alex Restrepo on 3/30/21.
//  Copyright © 2021 KZ. All rights reserved.
//

#import "PickerViewController.h"
#import "ColorPicker.h"

@interface PickerViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation PickerViewController

- (instancetype)initWithColor:(UIColor *)color {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
        _selectedColor = color;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    ColorPicker *picker = [[ColorPicker alloc] initWithFrame:self.view.bounds];
    picker.selectedColor = _selectedColor;
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [picker addTarget:self action:@selector(onColorChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:picker];
    
    self.preferredContentSize = CGSizeMake(240, 240);
}

- (void)onColorChange:(ColorPicker *)picker {
    _selectedColor = picker.selectedColor;
    [_delegate pickerControllerDidSelectColor:self];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

@end
