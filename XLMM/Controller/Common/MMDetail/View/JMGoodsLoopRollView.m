//
//  JMGoodsLoopRollView.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsLoopRollView.h"
#import "MMClass.h"

@interface JMGoodsLoopRollView ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation JMGoodsLoopRollView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    kWeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@(SCREENWIDTH * 4 / 3));
    }];
    

}

- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    NSMutableString *newImageUrl = [NSMutableString stringWithString:imageString];
    [newImageUrl appendString:@"?"];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageNormalCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageNormalCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"] options:SDWebImageProgressiveDownload];
 
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageNormalCompression] JMUrlEncodedString]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        float showProgress = (float)receivedSize/(float)expectedSize;
//        NSLog(@"%f",showProgress);
//        self.imageView.alpha = showProgress;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
}


@end
