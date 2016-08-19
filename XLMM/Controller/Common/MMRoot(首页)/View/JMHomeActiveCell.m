//
//  JMHomeActiveCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeActiveCell.h"
#import "MMClass.h"

NSString *const JMHomeActiveCellIdentifier = @"JMHomeActiveCellIdentifier";

@interface JMHomeActiveCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JMHomeActiveCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.iconImage = [UIImageView new];
    [self.contentView addSubview:self.iconImage];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
    kWeakSelf
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(10);
        make.left.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@150);
    }];
    
}

- (void)setImageUrlString:(NSString *)imageUrlString {
    _imageUrlString = imageUrlString;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[imageUrlString JMUrlEncodedString] imageNormalCompression]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    
}





@end
























































































