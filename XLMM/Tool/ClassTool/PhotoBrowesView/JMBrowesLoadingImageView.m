//
//  JMBrowesLoadingImageView.m
//  XLMM
//
//  Created by zhang on 16/12/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMBrowesLoadingImageView.h"

@interface JMBrowesLoadingImageView ()

@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation JMBrowesLoadingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createLoadingImage];
    }
    return self;
}

- (void)createLoadingImage {
    self.image = [UIImage imageNamed:@"browseLoadingImage"];
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    self.rotationAnimation.duration = 0.7f;
    self.rotationAnimation.repeatCount = FLT_MAX;
    
    
}


- (void)startAnimatingBrowesLoading {
    self.hidden = NO;
    [self.layer addAnimation:self.rotationAnimation forKey:@"rotateAnimation"];
}
- (void)stopAnimatingBrowesLoading {
    self.hidden = NO;
    [self.layer removeAnimationForKey:@"rotateAnimation"];
}






@end










































