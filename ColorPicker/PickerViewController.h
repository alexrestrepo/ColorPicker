//
//  PickerViewController.h
//  ColorPicker
//
//  Created by Alex Restrepo on 3/30/21.
//  Copyright © 2021 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewControllerDelegate;
@interface PickerViewController : UIViewController

@property (nonatomic, strong, readonly) UIColor *selectedColor;
@property (nonatomic, weak) id <PickerViewControllerDelegate> delegate;
- (instancetype)initWithColor:(UIColor *)color;

@end

@protocol PickerViewControllerDelegate <NSObject>

- (void)pickerControllerDidSelectColor:(PickerViewController *)controller;

@end
