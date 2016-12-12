//
//  JMRefreshLoadView.m
//  XLMM
//
//  Created by zhang on 16/11/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRefreshLoadView.h"

const CGFloat SURefreshHeaderHeight = 35.0;
const CGFloat SURefreshPointRadius = 5.0;

const CGFloat SURefreshPullLen     = 54.;
const CGFloat SURefreshTranslatLen = 5.0;

#define topPointColor    [UIColor colorWithRed:245 / 255.0 green:177 / 255.0 blue:35 / 255.0 alpha:1.0].CGColor  // 橙色
#define leftPointColor   [UIColor colorWithRed:255 / 255.0 green:99 / 255.0 blue:71 / 255.0 alpha:1.0].CGColor   // 红色
#define bottomPointColor [UIColor colorWithRed:71 / 255.0 green:155 / 255.0 blue:256 / 255.0 alpha:1.0].CGColor  // 蓝色
#define rightPointColor  [UIColor colorWithRed:138 / 255.0 green:43 / 255.0 blue:226 / 255.0 alpha:1.0].CGColor  // 紫色

@interface JMRefreshLoadView ()

@property (nonatomic, strong) CAShapeLayer * lineLayer;
@property (nonatomic, strong) CAShapeLayer * TopPointLayer;
@property (nonatomic, strong) CAShapeLayer * BottomPointLayer;
@property (nonatomic, strong) CAShapeLayer * LeftPointLayer;
@property (nonatomic, strong) CAShapeLayer * rightPointLayer;

@property (nonatomic, assign) BOOL animating;

@end

@implementation JMRefreshLoadView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initLayers];
    }
    return self;
}
#pragma mark - Iniatial
- (void)initLayers {
    CGFloat centerLine = SURefreshHeaderHeight / 2;
    CGFloat radius = SURefreshPointRadius;
    //
    CGPoint topPoint = CGPointMake(centerLine, radius);
    self.TopPointLayer = [self layerWithPoint:topPoint color:topPointColor];
    self.TopPointLayer.hidden = NO;
    self.TopPointLayer.opacity = 0.f;
    [self.layer addSublayer:self.TopPointLayer];
    
    CGPoint leftPoint = CGPointMake(radius, centerLine);
    self.LeftPointLayer = [self layerWithPoint:leftPoint color:leftPointColor];
    [self.layer addSublayer:self.LeftPointLayer];
    
    CGPoint bottomPoint = CGPointMake(centerLine, SURefreshHeaderHeight - radius);
    self.BottomPointLayer = [self layerWithPoint:bottomPoint color:bottomPointColor];
    [self.layer addSublayer:self.BottomPointLayer];
    
    CGPoint rightPoint = CGPointMake(SURefreshHeaderHeight - radius, centerLine);
    self.rightPointLayer = [self layerWithPoint:rightPoint color:rightPointColor];
    [self.layer addSublayer:self.rightPointLayer];
    
    //
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.frame = self.bounds;
    self.lineLayer.lineWidth = SURefreshPointRadius * 2;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.fillColor = topPointColor;
    self.lineLayer.strokeColor = topPointColor;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:topPoint];
    [path addLineToPoint:leftPoint];
    [path moveToPoint:leftPoint];
    [path addLineToPoint:bottomPoint];
    [path moveToPoint:bottomPoint];
    [path addLineToPoint:rightPoint];
    [path moveToPoint:rightPoint];
    [path addLineToPoint:topPoint];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeStart = 0.f;
    self.lineLayer.strokeEnd = 0.f;
    [self.layer insertSublayer:self.lineLayer above:self.TopPointLayer];
}
- (CAShapeLayer *)layerWithPoint:(CGPoint)center color:(CGColorRef)color {
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(center.x - SURefreshPointRadius, center.y - SURefreshPointRadius, SURefreshPointRadius * 2, SURefreshPointRadius * 2);
    layer.fillColor = color;
    layer.path = [self pointPath];
    layer.hidden = YES;
    return layer;
}
- (CGPathRef)pointPath {
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(SURefreshPointRadius, SURefreshPointRadius) radius:SURefreshPointRadius startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
}
#pragma mark - Property
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //如果不是正在刷新，则渐变动画
    if (!self.animating) {
        if (progress >= 0) {
            self.mj_y = self.mj_h * 0.5 - 9;
        }else {
            if (progress <= self.mj_h) {
                self.mj_y = -progress + 9;
            }else {
                self.mj_y = - (self.mj_h + (progress - self.mj_h) / 2);
            }
        }
        [self setLineLayerStrokeWithProgress:progress];
    }
    //如果到达临界点，则执行刷新动画
    if (progress >= SURefreshPullLen && !self.animating && !self.scrollView.isDragging) {
        [self startLoading];
    }
}
#pragma mark - Adjustment
- (void)setLineLayerStrokeWithProgress:(CGFloat)progress {
//    progress += self.progressOffsetY;
//    NSLog(@"%.2f",self.progressOffsetY);
    float startProgress = 0.f;
    float endProgress = 0.f;
    float spaceProgress = 45;
    //隐藏
    if (progress < 0) {
        self.TopPointLayer.opacity = 0.f;
        [self adjustPointStateWithIndex:0];
    }
    else if (progress >= 0 && progress < (SURefreshPullLen - spaceProgress)) {
//        self.TopPointLayer.opacity = progress / 20;
        self.TopPointLayer.opacity = 0.f;
        [self adjustPointStateWithIndex:0];
    }
    else if (progress >= (SURefreshPullLen - spaceProgress) && progress < SURefreshPullLen) {
        self.TopPointLayer.opacity = 1.0;
        //大阶段 0 ~ 3
        NSInteger stage = (progress - (SURefreshPullLen - spaceProgress)) / 10;
//        NSLog(@"stage --- > %ld",stage);
        //大阶段的前半段
        CGFloat subProgress = (progress - (SURefreshPullLen - spaceProgress)) - (stage * 10);
        if (subProgress >= 0 && subProgress <= 5) {
            [self adjustPointStateWithIndex:stage * 2];
            startProgress = stage / 4.0;
            endProgress = stage / 4.0 + subProgress / spaceProgress * 2;
        }
        //大阶段的后半段
        if (subProgress > 5 && subProgress < 10) {
            [self adjustPointStateWithIndex:stage * 2 + 1];
            startProgress = stage / 4.0 + (subProgress - 5) / spaceProgress * 2;
            if (startProgress < (stage + 1) / 4.0 - 0.1) {
                startProgress = (stage + 1) / 4.0 - 0.1;
            }
            endProgress = (stage + 1) / 4.0;
        }
    }
    else {
        self.TopPointLayer.opacity = 1.0;
        [self adjustPointStateWithIndex:NSIntegerMax];
        startProgress = 1.0;
        endProgress = 1.0;
    }
    self.lineLayer.strokeStart = startProgress;
    self.lineLayer.strokeEnd = endProgress;
}

#pragma mark - Animation
- (void)startLoading {
    self.animating = YES;
//    [UIView animateWithDuration:0.5 animations:^{
//        UIEdgeInsets inset = self.scrollView.contentInset;
//        inset.top = SURefreshPullLen;
//        self.scrollView.contentInset = inset;
//    }];
    [self addTranslationAniToLayer:self.TopPointLayer xValue:0 yValue:SURefreshTranslatLen];
    [self addTranslationAniToLayer:self.LeftPointLayer xValue:SURefreshTranslatLen yValue:0];
    [self addTranslationAniToLayer:self.BottomPointLayer xValue:0 yValue:-SURefreshTranslatLen];
    [self addTranslationAniToLayer:self.rightPointLayer xValue:-SURefreshTranslatLen yValue:0];
    [self addRotationAniToLayer:self.layer];
}
- (void)addTranslationAniToLayer:(CALayer *)layer xValue:(CGFloat)x yValue:(CGFloat)y {
    CAKeyframeAnimation * translationKeyframeAni = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translationKeyframeAni.duration = 1.0;
    translationKeyframeAni.repeatCount = HUGE;
    translationKeyframeAni.removedOnCompletion = NO;
    translationKeyframeAni.fillMode = kCAFillModeForwards;
    translationKeyframeAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSValue * fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0.f)];
    NSValue * toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(x, y, 0.f)];
    translationKeyframeAni.values = @[fromValue, toValue, fromValue, toValue, fromValue];
    [layer addAnimation:translationKeyframeAni forKey:@"translationKeyframeAni"];
}
- (void)addRotationAniToLayer:(CALayer *)layer {
    CABasicAnimation * rotationAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAni.fromValue = @(0);
    rotationAni.toValue = @(M_PI * 2);
    rotationAni.duration = 1.0;
    rotationAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAni.repeatCount = HUGE;
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = NO;
    [layer addAnimation:rotationAni forKey:@"rotationAni"];
}
- (void)removeAni {
    [UIView animateWithDuration:0.5 animations:^{
//        UIEdgeInsets inset = self.scrollView.contentInset;
//        inset.top = 0.f;
//        self.scrollView.contentInset = inset;
    } completion:^(BOOL finished) {
        [self.TopPointLayer removeAllAnimations];
        [self.LeftPointLayer removeAllAnimations];
        [self.BottomPointLayer removeAllAnimations];
        [self.rightPointLayer removeAllAnimations];
        [self.layer removeAllAnimations];
        [self adjustPointStateWithIndex:0];
        self.animating = NO;
    }];
}
- (void)adjustPointStateWithIndex:(NSInteger)index { //index : 小阶段： 0 ~ 7
    self.LeftPointLayer.hidden = index > 1 ? NO : YES;
    self.BottomPointLayer.hidden = index > 3 ? NO : YES;
    self.rightPointLayer.hidden = index > 5 ? NO : YES;
    self.lineLayer.strokeColor = index > 5 ? rightPointColor : index > 3 ? bottomPointColor : index > 1 ? leftPointColor : topPointColor;
}
#pragma mark - Stop
- (void)endLoading {
    [self removeAni];
}



@end
























































