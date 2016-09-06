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
        make.height.mas_equalTo(SCREENWIDTH * 0.4);
    }];
    
    
    
}
- (void)setTopDic:(NSDictionary *)topDic {
    _topDic = topDic;
    NSString *imageString = topDic[@"pic_link"];
//    NSMutableString *newImageUrl = [NSMutableString stringWithString:imageString];
//    [newImageUrl appendString:@"?"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[[imageString JMUrlEncodedString] imageNormalCompression]] placeholderImage:nil];
    
    
    
    
}






@end












































