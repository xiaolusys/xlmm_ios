//
//  CSLoadingAnimation.m
//  XLMM
//
//  Created by zhang on 17/3/14.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "CSLoadingAnimation.h"
#import <objc/message.h>

#define kSTRefreshRoundTime         1.5


@interface CSLoadingAnimation ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *headerImageV;
@property (nonatomic, strong) CAShapeLayer * circleLayer;
@property (nonatomic, strong) NSArray * colorArray;
@property (nonatomic, assign) BOOL isAnimating;


@end

@implementation CSLoadingAnimation

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)initUI {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.colorArray = @[[UIColor randomColor],
                        [UIColor randomColor],
                        [UIColor randomColor]];
    
    
    self.contentView = [UIView new];
    _contentView.cs_size = CGSizeMake(60, 60);
    _contentView.cs_centerY = self.cs_h / 2;
    _contentView.cs_centerX = self.cs_w / 2;

    self.headerImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _headerImageV.frame = CGRectMake(10, 10, 40, 40);
    _headerImageV.layer.masksToBounds = YES;
    
    self.circleLayer = [[CAShapeLayer alloc]init];
    _circleLayer.frame = _contentView.bounds;
    _circleLayer.fillColor = nil;
    _circleLayer.lineWidth = 2.5f;;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 0;
    _circleLayer.strokeColor = [(UIColor *)_colorArray.firstObject CGColor];
    
    CGPoint center = CGPointMake(_contentView.cs_w / 2.0, _contentView.cs_h / 2.0);
    CGFloat radius = _contentView.cs_h/2.0 - _circleLayer.lineWidth / 2.0;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = 2*M_PI - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    _circleLayer.path = path.CGPath;
    
    [self addSubview:_contentView];
    [_contentView addSubview:_headerImageV];
    [_contentView.layer addSublayer:_circleLayer];
    

    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.cs_centerX = self.cs_w/2;
}
- (void)startLoadingAnimation {
    if (!_isAnimating) {
        [self.circleLayer removeAllAnimations];
    }
    _isAnimating = YES;
    
    // Stroke Head
    CABasicAnimation *headAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation1.fromValue = @0;
    headAnimation1.toValue = @0.25;
    headAnimation1.duration = kSTRefreshRoundTime/3.0;
    headAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *headAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation2.beginTime = kSTRefreshRoundTime/3.0;
    headAnimation2.fromValue = @0.25;
    headAnimation2.toValue = @1;
    headAnimation2.duration = 2*kSTRefreshRoundTime/3.0;
    headAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Stroke Tail
    CABasicAnimation *tailAnimation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation1.fromValue = @0.25;
    tailAnimation1.toValue = @0.85;
    tailAnimation1.duration = kSTRefreshRoundTime/3.0;
    tailAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *tailAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation2.beginTime = kSTRefreshRoundTime/3.0;
    tailAnimation2.fromValue = @0.85;
    tailAnimation2.toValue = @1.25;
    tailAnimation2.duration = 2*kSTRefreshRoundTime/3.0;
    tailAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // Stroke Line Group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = kSTRefreshRoundTime;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[headAnimation1, headAnimation2, tailAnimation1, tailAnimation2];
    
    // Rotation
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.duration = kSTRefreshRoundTime;
    rotationAnimation.repeatCount = INFINITY;
    
    CAKeyframeAnimation *strokeColorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeColor"];
    strokeColorAnimation.values = [self prepareColorValues];
    strokeColorAnimation.keyTimes = [self prepareKeyTimes];
    strokeColorAnimation.calculationMode = kCAAnimationDiscrete;
    strokeColorAnimation.duration = self.colorArray.count *kSTRefreshRoundTime;
    strokeColorAnimation.repeatCount = INFINITY;
    
    [self.circleLayer addAnimation:animationGroup forKey:nil];
    [self.circleLayer addAnimation:rotationAnimation forKey:nil];
    [self.circleLayer addAnimation:strokeColorAnimation forKey:nil];
}
- (void)stopLoadingAnimation {
    if (_isAnimating) {
        [self.circleLayer removeAllAnimations];
    }
    _isAnimating = NO;
    [self.circleLayer setStrokeStart:0];
    [self.circleLayer setStrokeEnd:1];
    [self.circleLayer setStrokeColor:[(UIColor *)_colorArray.firstObject CGColor]];
}

- (NSArray*)prepareColorValues {
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for(UIColor *color in self.colorArray){
        [cgColorArray addObject:(id)color.CGColor];
    }
    return cgColorArray;
}
- (NSArray*)prepareKeyTimes {
    NSMutableArray *keyTimesArray = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < self.colorArray.count + 1; i ++){
        [keyTimesArray addObject:[NSNumber numberWithFloat:i *1.0/self.colorArray.count]];
    }
    return keyTimesArray;
}

- (void)beganRefreshing {
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.cs_centerY = self.cs_h/2;
    } completion:^(BOOL finished) {
        [self startLoadingAnimation];
    }];
}
- (void)endRefreshing {
    [self stopLoadingAnimation];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.contentView.alpha = 0;
        self.circleLayer.strokeEnd = 0;
//        self.headerImageV.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}


@end




















































