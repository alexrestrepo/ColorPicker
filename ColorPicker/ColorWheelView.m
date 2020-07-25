//
//  ColorWheelView.m
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import "ColorWheelView.h"

@interface ColorWheelView ()
@property (nonatomic, strong) UIImageView *colorWheelImageView;
@property (nonatomic, strong) UIImageView *selectionView;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) CIFilter *colorWheelFilter;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat value;
@end

@implementation ColorWheelView

+ (UIImage *)selectionImage {
    static dispatch_once_t onceToken;
    static UIImage *image = nil;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 10.0, *)) {
            UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(19, 19)];
            image = [renderer imageWithActions:^(UIGraphicsImageRendererContext *rendererContext) {
                const CGFloat scale = rendererContext.currentImage.scale;
                const CGFloat hairline = 1.0 / scale;
                const BOOL needsPadding = ((int)(CGRectGetWidth(rendererContext.format.bounds) * scale) % 2 == 0);
                const CGRect bounds = (needsPadding
                                       ? CGRectInset(rendererContext.format.bounds,
                                                     hairline / scale,
                                                     hairline / scale)
                                       : rendererContext.format.bounds);

                const CGFloat fudge = needsPadding ? hairline / scale : 0;
                CGRect rect = CGRectOffset(CGRectInset(bounds, 4 - hairline / 2.0, 4 - hairline / 2.0), -fudge, -fudge);
                UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
                path.lineWidth = hairline;

                [[UIColor blackColor] setStroke];
                [path stroke];

                CGContextRef ctx = rendererContext.CGContext;
                CGContextSetLineWidth(ctx, hairline);
                // horizontal
                CGContextMoveToPoint(ctx,
                                     0,
                                     CGRectGetMidY(bounds) - fudge);
                CGContextAddLineToPoint(ctx,
                                        CGRectGetMaxX(bounds) - fudge,
                                        CGRectGetMidY(bounds) - fudge);

                // vertical
                CGContextMoveToPoint(ctx,
                                     CGRectGetMidX(bounds) - fudge,
                                     0);
                CGContextAddLineToPoint(ctx,
                                        CGRectGetMidX(bounds) - fudge,
                                        CGRectGetMaxY(bounds) - fudge);
                CGContextStrokePath(ctx);
            }];
        }
    });
    return image;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _selectedColor = [UIColor whiteColor];

        _colorWheelImageView = [[UIImageView alloc] initWithFrame:CGRectZero];        
        [self addSubview:_colorWheelImageView];

        _borderView = [[UIView alloc] initWithFrame:CGRectZero];
        _borderView.userInteractionEnabled = NO;
        _borderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _borderView.layer.borderWidth = 2.0f;
        [self addSubview:_borderView];

        _selectionView = [[UIImageView alloc] initWithImage:[ColorWheelView selectionImage]];
        [self addSubview:_selectionView];

        _colorWheelFilter = [CIFilter filterWithName:@"CIHueSaturationValueGradient"
                                 withInputParameters:@{
                                     @"inputSoftness" : @(0),
                                     @"inputValue" : @(1)
                                 }];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews {
    _borderView.frame = self.bounds;
    _borderView.layer.cornerRadius = CGRectGetMidX(self.bounds);

    _colorWheelImageView.frame = CGRectInset(self.bounds, 1, 1);
    self.radius = CGRectGetMidX(_colorWheelImageView.bounds);

    [self updateSelectionView];
}

- (CGFloat)radius {
    return [[_colorWheelFilter valueForKey:@"inputRadius"] doubleValue];
}

- (void)setRadius:(CGFloat)radius {
    if (ABS(radius - self.radius) < CGFLOAT_MIN) {
        return;
    }

    [_colorWheelFilter setValue:@(radius) forKey:@"inputRadius"];
    _colorWheelImageView.image = [UIImage imageWithCIImage:_colorWheelFilter.outputImage];
}

- (CGFloat)value {
    return [[_colorWheelFilter valueForKey:@"inputValue"] doubleValue];
}

- (void)setValue:(CGFloat)value {
    [_colorWheelFilter setValue:@(value) forKey:@"inputValue"];
    _colorWheelImageView.image = [UIImage imageWithCIImage:_colorWheelFilter.outputImage];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    [self setSelectedColor:selectedColor animated:NO];
}

- (void)setSelectedColor:(UIColor *)selectedColor animated:(BOOL)animated {
    if ([_selectedColor isEqual:selectedColor]) {
        return;
    }

    _selectedColor = selectedColor;
    [self setNeedsLayout];

    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)updateSelectionView {
    CGFloat hue, saturation, value;
    [_selectedColor getHue:&hue saturation:&saturation brightness:&value alpha:NULL];

    CGFloat angle = hue * 2.0 * M_PI;
    CGFloat radius = CGRectGetMidX(_colorWheelImageView.bounds);
    CGPoint center = CGPointMake(radius,
                                 CGRectGetMidY(_colorWheelImageView.bounds));

    radius = MIN(radius * saturation, radius - 2.5); // cap to almost the edge
    CGFloat x = center.x + cos(angle) * radius;
    CGFloat y = center.y - sin(angle) * radius;

    _selectionView.center = CGPointMake(x, y);
}

- (void)mapPointToColor:(CGPoint)point {
    CGFloat radius = CGRectGetMidX(_colorWheelImageView.bounds);
    CGPoint center = CGPointMake(radius,
                                 CGRectGetMidY(_colorWheelImageView.bounds));

    CGFloat dx = ABS(point.x - center.x);
    CGFloat dy = ABS(point.y - center.y);
    CGFloat angle = atan(dy / dx);

    if (isnan(angle)) {
        angle = 0.0;
    }

    CGFloat dist = sqrt(dx * dx + dy * dy);
    CGFloat saturation = MIN(dist / radius, 1.0);

    if (dist < 5.0) {
        saturation = 0.0; // snap to center
    }

    if (point.x < center.x) {
        angle = M_PI - angle;
    }

    if (point.y > center.y) {
        angle = 2.0 * M_PI - angle;
    }

    self.selectedColor = [UIColor colorWithHue:angle / (2.0 * M_PI) saturation:saturation brightness:self.value alpha:1.0];
    self.backgroundColor = _selectedColor;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return CGRectContainsPoint(_colorWheelImageView.frame, [touch locationInView:_colorWheelImageView]);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self mapPointToColor:[touch locationInView:_colorWheelImageView]];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self continueTrackingWithTouch:touch withEvent:event];
}

@end
