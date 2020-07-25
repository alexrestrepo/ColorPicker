//
//  ColorWheelView.m
//  ColorPicker
//
//  Created by Alex Restrepo on 7/23/20.
//  Copyright © 2020 KZ. All rights reserved.
//

#import "ColorWheelView.h"

@interface FloatingColorIndicator : UIView
@property (nonatomic, strong) UIView *colorView;
@end

@implementation FloatingColorIndicator
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(29.62, 0.12)];
        [bezierPath addCurveToPoint: CGPointMake(30.85, 1.28) controlPoint1: CGPointMake(30.25, 0.34) controlPoint2: CGPointMake(30.66, 0.75)];
        [bezierPath addCurveToPoint: CGPointMake(31, 3.09) controlPoint1: CGPointMake(31, 1.76) controlPoint2: CGPointMake(31, 2.2)];
        [bezierPath addLineToPoint: CGPointMake(31, 28.26)];
        [bezierPath addCurveToPoint: CGPointMake(30.87, 30) controlPoint1: CGPointMake(31, 29.15) controlPoint2: CGPointMake(31, 29.6)];
        [bezierPath addCurveToPoint: CGPointMake(30.63, 30.51) controlPoint1: CGPointMake(30.79, 30.23) controlPoint2: CGPointMake(30.72, 30.37)];
        [bezierPath addLineToPoint: CGPointMake(30.54, 30.62)];
        [bezierPath addCurveToPoint: CGPointMake(30.28, 30.89) controlPoint1: CGPointMake(30.46, 30.72) controlPoint2: CGPointMake(30.38, 30.81)];
        [bezierPath addCurveToPoint: CGPointMake(17.7, 43.62) controlPoint1: CGPointMake(25.28, 35.94) controlPoint2: CGPointMake(18.25, 43.06)];
        [bezierPath addCurveToPoint: CGPointMake(16.35, 44.79) controlPoint1: CGPointMake(17.03, 44.29) controlPoint2: CGPointMake(16.72, 44.6)];
        [bezierPath addCurveToPoint: CGPointMake(14.71, 44.83) controlPoint1: CGPointMake(15.79, 45.06) controlPoint2: CGPointMake(15.21, 45.06)];
        [bezierPath addCurveToPoint: CGPointMake(13.34, 43.65) controlPoint1: CGPointMake(14.27, 44.6) controlPoint2: CGPointMake(13.96, 44.28)];
        [bezierPath addCurveToPoint: CGPointMake(4.43, 34.65) controlPoint1: CGPointMake(13.34, 43.65) controlPoint2: CGPointMake(8.87, 39.13)];
        [bezierPath addCurveToPoint: CGPointMake(0.72, 30.89) controlPoint1: CGPointMake(3.16, 33.36) controlPoint2: CGPointMake(1.88, 32.07)];
        [bezierPath addCurveToPoint: CGPointMake(0.46, 30.63) controlPoint1: CGPointMake(0.62, 30.81) controlPoint2: CGPointMake(0.54, 30.72)];
        [bezierPath addLineToPoint: CGPointMake(0.34, 30.51)];
        [bezierPath addCurveToPoint: CGPointMake(0.15, 30.08) controlPoint1: CGPointMake(0.28, 30.37) controlPoint2: CGPointMake(0.21, 30.23)];
        [bezierPath addCurveToPoint: CGPointMake(0, 28.26) controlPoint1: CGPointMake(0, 29.6) controlPoint2: CGPointMake(0, 29.15)];
        [bezierPath addLineToPoint: CGPointMake(0, 3.09)];
        [bezierPath addCurveToPoint: CGPointMake(0.13, 1.36) controlPoint1: CGPointMake(0, 2.2) controlPoint2: CGPointMake(0, 1.76)];
        [bezierPath addCurveToPoint: CGPointMake(1.26, 0.15) controlPoint1: CGPointMake(0.34, 0.75) controlPoint2: CGPointMake(0.75, 0.34)];
        [bezierPath addCurveToPoint: CGPointMake(3.06, 0) controlPoint1: CGPointMake(1.74, 0) controlPoint2: CGPointMake(2.18, 0)];
        [bezierPath addLineToPoint: CGPointMake(27.94, 0)];
        [bezierPath addCurveToPoint: CGPointMake(29.66, 0.13) controlPoint1: CGPointMake(28.82, 0) controlPoint2: CGPointMake(29.26, -0)];
        [bezierPath addLineToPoint: CGPointMake(29.62, 0.12)];
        [bezierPath closePath];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = bezierPath.CGPath;
        self.layer.mask = maskLayer;

        CGRect rect = CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetWidth(frame)), 3, 3);
        _colorView = [[UIView alloc] initWithFrame:rect];
        _colorView.layer.cornerRadius = 1.5;
        _colorView.backgroundColor = UIColor.redColor;
        [self addSubview:_colorView];

        self.userInteractionEnabled = NO;
    }
    return self;
}
@end

@interface ColorWheelView ()
@property (nonatomic, strong) UIImageView *colorWheelImageView;
@property (nonatomic, strong) UIImageView *selectionView;
@property (nonatomic, strong) FloatingColorIndicator *floatingColorView;
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

        _floatingColorView = [[FloatingColorIndicator alloc] initWithFrame:CGRectMake(0, 0, 31, 45)];
        _floatingColorView.backgroundColor = [UIColor blackColor];
        _floatingColorView.hidden = YES;
        [self addSubview:_floatingColorView];

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
    _floatingColorView.colorView.backgroundColor = _selectedColor;
    _floatingColorView.center = CGPointMake(_selectionView.center.x,
                                            _selectionView.center.y
                                            - CGRectGetMidY(_floatingColorView.bounds)
                                            - CGRectGetMidY(_selectionView.bounds) - 3.0);
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

    if (dist < 8.0) {
        saturation = 0.0; // snap to center
    }

    if (point.x < center.x) {
        angle = M_PI - angle;
    }

    if (point.y > center.y) {
        angle = 2.0 * M_PI - angle;
    }

    self.selectedColor = [UIColor colorWithHue:angle / (2.0 * M_PI) saturation:saturation brightness:self.value alpha:1.0];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    _floatingColorView.hidden = NO;
    return CGRectContainsPoint(_colorWheelImageView.frame, [touch locationInView:_colorWheelImageView]);
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self mapPointToColor:[touch locationInView:_colorWheelImageView]];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self continueTrackingWithTouch:touch withEvent:event];
    _floatingColorView.hidden = YES;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    _floatingColorView.hidden = YES;
}

@end
