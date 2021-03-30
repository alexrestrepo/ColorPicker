//
//  ColorPicker.h
//  ColorPicker
//
//  Created by Alex Restrepo on 7/24/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(10.0)
@interface ColorPicker : UIControl

@property (nonatomic, strong) UIColor *selectedColor;

@end

NS_ASSUME_NONNULL_END
