//
//  ColorWheelView.h
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorWheelView : UIControl

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong, readonly) UIView *borderView;

- (void)setSelectedColor:(UIColor *)selectedColor animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
