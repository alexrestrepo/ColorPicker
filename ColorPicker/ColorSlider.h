//
//  ColorSlider.h
//  ColorPicker
//
//  Created by Alex Restrepo on 7/24/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SimpleSlider : UIControl
@property (nonatomic, assign, readonly) CGFloat value; // [0, 1]
@end

@interface ColorSlider : SimpleSlider
@property (nonatomic, strong) UIColor *selectedColor;
@end

@interface AlphaSlider : ColorSlider
@property (nonatomic, assign) CGFloat alphaValue;
@end

NS_ASSUME_NONNULL_END
