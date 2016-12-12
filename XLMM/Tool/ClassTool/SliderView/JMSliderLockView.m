//
//  HBLockSliderView.m
//  MySliderDemo
//
//  Created by 屌炸天 on 16/9/18.
//  Copyright © 2016年 yhb. All rights reserved.
//

#define kSliderW self.bounds.size.width
#define kSliderH self.bounds.size.height
#define kCornerRadius 5.0  //默认圆角为5
#define kBorderWidth 0.2 //默认边框为2
#define kAnimationSpeed 0.5 //默认动画移速
#define kForegroundColor [UIColor orangeColor] //默认滑过颜色
#define kBackgroundColor [UIColor darkGrayColor] //默认未滑过颜色
#define kThumbColor [UIColor lightGrayColor] //默认Thumb颜色
#define kBorderColor [UIColor blackColor] //默认边框颜色
#define kThumbW 60 //默认的thumb的宽度

#import "JMSliderLockView.h"


@interface JMSliderLockView ()



@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UILabel *sliderLabel;



@end
@implementation JMSliderLockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    //    UIImageView *backgroundV = [[UIImageView alloc] initWithFrame:self.bounds];
    //    backgroundV.image = [self drawRoundedCornerImageWithSize:backgroundV.frame.size radius:kCornerRadius borderWidth:kBorderWidth backgroundColor:kBackgroundColor borderColor:kBorderColor];
    //    [self insertSubview:backgroundV atIndex:0];
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:18];
    self.foregroundView = [[UIView alloc] init];
    [self addSubview:self.foregroundView];
    self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.thumbImageView.layer.cornerRadius = kCornerRadius;
    self.thumbImageView.layer.masksToBounds = YES;
    self.thumbImageView.userInteractionEnabled = YES;
    
    kWeakSelf
    self.sliderLabel = [UILabel new];
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    self.sliderLabel.font = [UIFont systemFontOfSize:18];
    [self.thumbImageView addSubview:self.sliderLabel];
    [self.sliderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.thumbImageView);
    }];
    
    
//    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.thumbImageView];
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = kBorderWidth;
    [self setSliderValue:0.0];
    //默认配置
    self.thumbBack = YES;
    self.backgroundColor = kBackgroundColor;
    self.foregroundView.backgroundColor = kForegroundColor;
    self.thumbImageView.backgroundColor = kThumbColor;
    [self.layer setBorderColor:kBorderColor.CGColor];
    self.touchView = self.thumbImageView;
    
}

#pragma mark - Public
- (void)setText:(NSString *)text{
    _text = text;
    self.label.text = text;
    if (!self.label.superview) {
        [self insertSubview:self.label atIndex:1];
    }
}


- (void)setFont:(UIFont *)font{
    _font = font;
    self.label.font = font;
}

- (void)setSliderValue:(CGFloat)value{
    [self setSliderValue:value animation:NO completion:nil];
}

- (void)setSliderValue:(CGFloat)value animation:(BOOL)animation completion:(void (^)(BOOL))completion{
    if (value > 1) {
        value = 1;
    }
    if (value < 1) {
        value = 0;
    }
    CGPoint point = CGPointMake(value * kSliderW, 0);
    typeof(self) weakSelf = self;
    if (animation) {
        [UIView animateWithDuration:kAnimationSpeed animations:^{
            [weakSelf fillForeGroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self fillForeGroundViewWithPoint:point];
    }
}

- (void)setColorForBackgroud:(UIColor *)backgroud foreground:(UIColor *)foreground thumb:(UIColor *)thumb border:(UIColor *)border textColor:(UIColor *)textColor{
    self.backgroundColor = backgroud;
    self.foregroundView.backgroundColor = foreground;
    self.thumbImageView.backgroundColor = thumb;
    [self.layer setBorderColor:border.CGColor];
    self.label.textColor = textColor;
}

- (void)setThumbImage:(UIImage *)thumbImage{
    _thumbImage = thumbImage;
    self.thumbImageView.image = thumbImage ;
    //    self.thumbImageView.image = [self imageAddCornerWithImage:thumbImage Radius:kCornerRadius andSize:thumbImage.size];
    [self.thumbImageView sizeToFit];
    [self setSliderValue:0.0];
}


- (void)setThumbBeginImage:(UIImage *)beginImage finishImage:(UIImage *)finishImage{
    self.thumbImage = beginImage;
    self.finishImage = finishImage;
}
- (void)setThumbString:(NSString *)thumbString {
    _thumbString = thumbString;
    self.sliderLabel.text = thumbString;
    [self setSliderValue:0.0];
}
- (void)setThumbBeginString:(NSString *)beginString finishString:(NSString *)finishString {
    self.thumbString = beginString;
    self.finishString = finishString;
}

- (void)removeRoundCorners:(BOOL)corners border:(BOOL)border{
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = NO;
        self.thumbImageView.layer.cornerRadius = 0.0;
        self.thumbImageView.layer.masksToBounds = NO;
    }
    if (border) {
        [self.layer setBorderWidth:0.0];
    }
}

- (void)setThumbHidden:(BOOL)thumbHidden{
    _thumbHidden = thumbHidden;
    self.touchView = thumbHidden ? self : self.thumbImageView;
    self.thumbImageView.hidden = thumbHidden;
}


#pragma mark - Private
- (void)fillForeGroundViewWithPoint:(CGPoint)point{
    CGFloat thunmbW = kThumbW;  // self.thumbImage ? self.thumbImage.size.width : kThumbW
    CGPoint p = point;
    //修正
//    p.x += thunmbW/2;
    if (p.x > kSliderW - kThumbW / 2) {
        p.x = kSliderW ;
    }
    if (p.x < kThumbW / 2) {
        p.x = 0;
    }
//    self.sliderView.sliderText = @"🙂";self.sliderView.sliderText = @"😄";
    if (self.finishString) {
        self.sliderLabel.text = point.x  < (kSliderW - kThumbW / 2) ? self.thumbString : self.finishString;
    }
    self.value = p.x  / kSliderW;
    NSLog(@"self.value === %.f",self.value);
    
    self.foregroundView.frame = CGRectMake(0, 0, p.x, kSliderH);
    
    
    if (self.foregroundView.frame.size.width <= 0) {
        self.thumbImageView.frame = CGRectMake(0, kBorderWidth, thunmbW, self.foregroundView.frame.size.height- kBorderWidth);
        
    }else if (self.foregroundView.frame.size.width >= kSliderW) {
        self.thumbImageView.frame = CGRectMake(self.foregroundView.frame.size.width - thunmbW, kBorderWidth, thunmbW, self.foregroundView.frame.size.height - 2 * kBorderWidth );
        
    }else{
        self.thumbImageView.frame = CGRectMake(self.foregroundView.frame.size.width-thunmbW/2, kBorderWidth, thunmbW, self.foregroundView.frame.size.height-kBorderWidth*2);
    }
    
}




#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if ( self.touchView == self.thumbImageView) {
        return;
    }
    CGPoint point = [touch locationInView:self];
    NSLog(@"%f",point.x);
    [self fillForeGroundViewWithPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self.touchView) {
        return;
    }
    CGPoint point = [touch locationInView:self];
//    if (point.x < 30 || point.x > (SCREENWIDTH - 60)) {
//        return ;
//    }
    NSLog(@"touchesMoved  ====  %f",point.x);
    [self fillForeGroundViewWithPoint:point];
    if ([self.delegate respondsToSelector:@selector(sliderValueChanging:)] ) {
        [self.delegate sliderValueChanging:self];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view != self.touchView) {
        return;
    }
    CGPoint __block point = [touch locationInView:self];
    NSLog(@"touchesEnded  ====  %f",point.x);
    if ([self.delegate respondsToSelector:@selector(sliderEndValueChanged:)]) {
        [self.delegate sliderEndValueChanged:self];
    }
    typeof(self) weakSelf = self;
    if (_thumbBack) {
        //回到原点
        [UIView animateWithDuration:0.5 animations:^{
            point.x = 0;
            [weakSelf fillForeGroundViewWithPoint:point];
            
        }];
    }
    
}
- (void)setThumbBack:(BOOL)thumbBack {
    _thumbBack = thumbBack;
//    CGFloat thunmbW = kThumbW; // self.thumbImage ? self.thumbImage.size.width : kThumbW
    if (thumbBack) {
        [self setSliderValue:0.0];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.foregroundView.frame = CGRectMake(0, 0, 0, kSliderH);
//            self.thumbImageView.frame = CGRectMake(0, kBorderWidth, thunmbW, self.foregroundView.frame.size.height- kBorderWidth);
//        }];
    }
    
}






@end
















