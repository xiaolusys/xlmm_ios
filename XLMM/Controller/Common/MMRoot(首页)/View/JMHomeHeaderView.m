//
//  JMHomeHeaderView.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeHeaderView.h"
#import "MMClass.h"

@interface JMHomeHeaderView ()

@property (strong, nonatomic) UIImageView *imageView;



@end

@implementation JMHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    kWeakSelf
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@(SCREENHEIGHT * 0.65));
    }];
    
    
    
}
- (void)setImageString:(NSString *)imageString {
    _imageString = imageString;
    NSMutableString *newImageUrl = [NSMutableString stringWithString:imageString];
    [newImageUrl appendString:@"?"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[newImageUrl imageNormalCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    
    
}

@end
