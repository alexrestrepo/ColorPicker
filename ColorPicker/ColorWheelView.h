//
//  ColorWheelView.h
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorWheelViewDelegate;
@interface ColorWheelView : UIControl

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, weak) id <ColorWheelViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *borderView;

- (void)setSelectedColor:(UIColor *)selectedColor animated:(BOOL)animated;

@end

@protocol ColorWheelViewDelegate <NSObject>
- (void)colorWheelViewDidSnapToCenter:(ColorWheelView *)view;
@end

NS_ASSUME_NONNULL_END
