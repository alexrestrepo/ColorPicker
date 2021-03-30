//
//  ColorSlider.h
//  ColorPicker
//
//  Created by Alex Restrepo on 7/24/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat SliderHeight;

NS_CLASS_AVAILABLE_IOS(10.0)
@interface SimpleSlider : UIControl
@property (nonatomic, assign, readonly) CGFloat value; // [0, 1]
@end

NS_CLASS_AVAILABLE_IOS(10.0)
@interface ColorSlider : SimpleSlider
@property (nonatomic, strong) UIColor *selectedColor;
@end

NS_CLASS_AVAILABLE_IOS(10.0)
@interface AlphaSlider : ColorSlider
+ (UIImage *)checkerboardImage;
@property (nonatomic, assign) CGFloat alphaValue;
@end

NS_ASSUME_NONNULL_END
