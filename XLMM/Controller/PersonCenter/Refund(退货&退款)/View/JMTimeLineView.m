//
//  JMTimeLineView.m
//  XLMM
//
//  Created by zhang on 16/6/16.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMTimeLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "MASViewAttribute.h"
#import "MMClass.h"


@interface JMTimeLineView () {
    BOOL didStopAnimation;
    NSMutableArray *layers;
    NSMutableArray *circleLayers;
    int layerCounter;
    int circleCounter;
    CGFloat timeOffset;
    CGFloat leftWidth;
    CGFloat rightWidth;
    CGFloat viewWidther;
    
}

@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIView *progressDesView;

@property (nonatomic, strong) NSMutableArray *labelDesArr;
@property (nonatomic, strong) NSMutableArray *sizes;

@end

@implementation JMTimeLineView

@synthesize viewWidth = viewWidth;

- (NSMutableArray *)labelDesArr {
    if (_labelDesArr == nil) {
        _labelDesArr = [NSMutableArray array];
    }
    return _labelDesArr;
}

- (NSMutableArray *)sizes {
    if (_sizes == nil) {
        _sizes = [NSMutableArray array];
    }
    return _sizes;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


- (id)initWithTimeArray:(NSArray *)time andTimeDesArray:(NSArray *)timeDes andCurrentStatus:(NSInteger)status andFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        viewWidth = 75.0;
        
        self.progressView = [UIView new];
        self.timeView = [UIView new];
        self.progressDesView = [UIView new];
        [self addSubview:self.progressDesView];
        [self addSubview:self.progressView];
        [self addSubview:self.timeView];
        
        [self addTimeDesLabel:timeDes addTime:time currentStatus:status];
        [self setNeedsUpdateConstraints];
        [self addProgressBaseOnLabel:self.labelDesArr currentStatus:status];
        [self addtimeLabel:time currentStatus:status];
        
    }
    
    return self;
}

- (void)addtimeLabel:(NSArray *)time currentStatus:(NSInteger)currentStatus {
    CGFloat betweenLabelOffset = 0;
    CGFloat totlaWidther = 6;
    NSInteger i = 0;
    for (NSString *timeDes in time) {
        UILabel *label = [UILabel new];
        [label setText:timeDes];
        label.numberOfLines = 2;
        label.textColor = i < currentStatus ? [UIColor blackColor] : [UIColor grayColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setFont:[UIFont systemFontOfSize:12.]];
        [self.timeView addSubview:label];
        UILabel *desLabel = self.labelDesArr[i];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeView);
            make.width.mas_equalTo(@0);
            make.left.equalTo(desLabel.mas_left);
        }];
        CGSize fittingSize = [label systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        betweenLabelOffset = 20;
        totlaWidther += (fittingSize.width + betweenLabelOffset);
        
        [self.labelDesArr addObject:label];
        i++;
        
    }
    viewWidth = totlaWidther;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}
- (void)addTimeDesLabel:(NSArray *)timeDes addTime:(NSArray *)time currentStatus:(NSInteger)currentStatus {
    CGFloat betweenLabelOffset = 0;
    CGFloat totlaWidth = 6;
    CGSize fittingSizeLabel;
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:_progressDesView.frame];
    [_progressDesView addSubview:lastLabel];
    NSInteger i = 0;
    for (NSString *timeDesStr in timeDes) {
        UILabel *label = [UILabel new];
        label.text = timeDesStr;
        label.numberOfLines = 0;
        label.textColor = i < currentStatus ? [UIColor orangeColor] : [UIColor grayColor];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont systemFontOfSize:12.];
        [self.progressDesView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastLabel.mas_right).offset(betweenLabelOffset);
            make.top.equalTo(_progressDesView);
        }];
        //        [label setPreferredMaxLayoutWidth:leftWidth];
        [label sizeToFit];
        fittingSizeLabel = [label systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        betweenLabelOffset = 20;
        totlaWidth += (fittingSizeLabel.width + betweenLabelOffset);
        lastLabel = label;
        [self.labelDesArr addObject:label];
        i++;
    }
    viewWidth = fittingSizeLabel.width;
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
}

- (void)addProgressBaseOnLabel:(NSArray *)labels currentStatus:(NSInteger)currentStatus {
    NSInteger i = 0;
    CGFloat betweenLineOffset = 0;
    CGFloat totlaWidth = 8;
    CGPoint lastpoint;
    CGFloat yCenter;
    UIColor *strokColor;
    CGPoint toPoint;
    CGPoint fromPoint;
    circleLayers = [NSMutableArray array];
    layers = [NSMutableArray array];
    for (UILabel *label in labels) {
        CGSize fittingSize = [label systemLayoutSizeFittingSize: UILayoutFittingCompressedSize];
        strokColor = i < currentStatus ? [UIColor orangeColor] : [UIColor lightGrayColor];
        yCenter = totlaWidth;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter];
        CAShapeLayer *circlelabyer = [self getLayerWithCircle:circle andStrokeColor:strokColor];
        [circleLayers addObject:circlelabyer];
        CAShapeLayer *grayStaticCircleLayer = [self getLayerWithCircle:circle andStrokeColor:[UIColor lightGrayColor]];
        [self.progressView.layer addSublayer:grayStaticCircleLayer];
        if (i > 0) {
            fromPoint = lastpoint;
            toPoint = CGPointMake(yCenter - 3,lastpoint.y);
            lastpoint = CGPointMake(yCenter + 3,lastpoint.y);
            
            UIBezierPath *line = [self getLineWithStartPoint:fromPoint endPoint:toPoint];
            CAShapeLayer *lineLayer = [self getLayerWithLine:line andStrokeColor:strokColor];
            [layers addObject:lineLayer];
            CAShapeLayer *grayStaticLineLayer = [self getLayerWithLine:line andStrokeColor:[UIColor lightGrayColor]];
            [self.progressView.layer addSublayer:grayStaticCircleLayer];
            
            
        }else {
            lastpoint = CGPointMake(self.progressView.center.x + 1 + 10 , yCenter + 5.);
        }
        
        betweenLineOffset = 20;
        totlaWidth += (fittingSize.width + betweenLineOffset);
        i++;
    }
    
    [self startAnimatingLayers:circleLayers forStatus:currentStatus];
}
- (CAShapeLayer *)getLayerWithLine:(UIBezierPath *)line andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = line.CGPath;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.fillColor = nil;
    lineLayer.lineWidth = 2.;
    
    return lineLayer;
}

- (UIBezierPath *)getLineWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:start];
    [line addLineToPoint:end];
    
    return line;
}

- (CAShapeLayer *)getLayerWithCircle:(UIBezierPath *)circle andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.progressView.bounds;
    circleLayer.path = circle.CGPath;
    
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.fillColor = nil;
    circleLayer.lineWidth = 2.;
    circleLayer.lineJoin = kCALineJoinBevel;
    
    return circleLayer;
}
- (void)configureBezierCircle:(UIBezierPath *)circle withCenterY:(CGFloat)centerY {
    [circle addArcWithCenter:CGPointMake(centerY, self.progressView.center.x + 3. + 20 / 2)
                      radius:3.
                  startAngle:M_PI_2
                    endAngle:-M_PI_2
                   clockwise:YES];
    [circle addArcWithCenter:CGPointMake(centerY, self.progressView.center.x + 3. + 20 / 2)
                      radius:3.
                  startAngle:-M_PI_2
                    endAngle:M_PI_2
                   clockwise:YES];
}
- (void)startAnimatingLayers:(NSArray *)layersToAnimate forStatus:(int)currentStatus {
    
    float circleTimeOffset = 1;
    circleCounter = 0;
    NSInteger i = 1;
    if (currentStatus == layersToAnimate.count) {
        for (CAShapeLayer *cilrclLayer in layersToAnimate) {
            [self.progressView.layer addSublayer:cilrclLayer];
        }
        for (CAShapeLayer *lineLayer in layers) {
            [self.progressView.layer addSublayer:lineLayer];
        }
    }else {
        for (CAShapeLayer *cilrclLayer in layersToAnimate) {
            [self.progressView.layer addSublayer:cilrclLayer];
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration = 0.2;
            animation.beginTime = [cilrclLayer convertTime:CACurrentMediaTime() fromLayer:nil] + circleTimeOffset;
            animation.fromValue = [NSNumber numberWithFloat:0.0f];
            animation.toValue   = [NSNumber numberWithFloat:1.0f];
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            circleTimeOffset += .4;
            [cilrclLayer setHidden:YES];
            [cilrclLayer addAnimation:animation forKey:@"strokeCircleAnimation"];
            if (i == currentStatus && i != [layersToAnimate count]) {
                CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
                strokeAnim.fromValue         = (id) [UIColor orangeColor].CGColor;
                strokeAnim.toValue           = (id) [UIColor clearColor].CGColor;
                strokeAnim.duration          = 1.0;
                strokeAnim.repeatCount       = HUGE_VAL;
                strokeAnim.autoreverses      = NO;
                [cilrclLayer addAnimation:strokeAnim forKey:@"animateStrokeColor"];
            }
            i++;
        }
        
    }
    
    
}
- (void)animationDidStart:(CAAnimation *)anim {
    if (circleCounter < circleLayers.count) {
        if (anim == [circleLayers[circleCounter] animationForKey:@"strokeCircleAnimation"]) {
            [circleLayers[circleCounter] setHidden:NO];
            circleCounter++;
        }
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (layerCounter >= layers.count) {
        return;
    }
    CAShapeLayer *lineLayer = layers[layerCounter];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.200;
    
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:1.0f];
    animation.fillMode = kCAFillModeForwards;
    
    [self.progressView.layer addSublayer:lineLayer];
    [lineLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    layerCounter++;
    
}
- (void)updateConstraints {
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(viewWidth);
        make.top.equalTo(self.timeView.mas_bottom);
        make.left.equalTo(self).offset(20);
        make.height.mas_equalTo(@30);
    }];
    
    [self.timeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(@0);
        make.height.mas_equalTo(@0);
    }];
    
    [self.progressDesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom);
        make.left.equalTo(self).offset(10);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(@30);
    }];
    
    
    [super updateConstraints];
}
@end
