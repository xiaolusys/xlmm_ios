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

@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation JMGoodsLoopRollView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    
    kWeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@(SCREENHEIGHT * 0.7));
    }];
    
    
    
}
- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    NSMutableString *newImageUrl = [NSMutableString stringWithString:imageString];
    [newImageUrl appendString:@"?"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageNormalCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    
    
}


@end
