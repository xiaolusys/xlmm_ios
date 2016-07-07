//
//  JMFetureFansCell.m
//  XLMM
//
//  Created by zhang on 16/6/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMFetureFansCell.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMFetureFansModel.h"
#import "NSString+URL.h"
#import "VisitorModel.h"

@interface JMFetureFansCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation JMFetureFansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}

- (void)initUI {
    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *descLabel = [UILabel new];
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    self.descLabel.font = [UIFont systemFontOfSize:12.];
    self.descLabel.textColor = [UIColor timeLabelColor];
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:14.];
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    self.timeLabel.font = [UIFont systemFontOfSize:13.];
    self.timeLabel.textColor = [UIColor timeLabelColor];
    
}
- (void)layoutUI {
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.top.equalTo(weakSelf.iconImage.mas_top).offset(10);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel);
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.nameLabel.mas_centerY);
    }];
    
    
}

- (void)fillData:(JMFetureFansModel *)model {
    
    if (model.headimgurl.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.headimgurl JMUrlEncodedString]]];
    }
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    
    if ([model.nick isEqualToString:@""]) {
        self.nameLabel.text = @"匿名用户";
    }else {
        self.nameLabel.text = model.nick;
    }
    self.timeLabel.text = [self composeString:model.modified];
    self.descLabel.text = model.note;
}

- (void)fillVisitorData:(VisitorModel *)model {
    if (model.visitor_img.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.visitor_img JMUrlEncodedString]]];
    }
    
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    self.nameLabel.text = model.visitor_nick;
    
    self.descLabel.text = model.visitor_description;
    
    self.timeLabel.text = [self composeString:model.created];
}
- (void)configNowFnas:(FanceModel *)model {
    if (model.fans_thumbnail.length == 0) {
        self.iconImage.image = [UIImage imageNamed:@"zhanwei"];
    }else {
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[model.fans_thumbnail JMUrlEncodedString]]];
    }
    
    self.iconImage.layer.cornerRadius = 30;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.iconImage.layer.masksToBounds = YES;
    self.nameLabel.text = model.fans_nick;
    
    self.descLabel.text = model.fans_description;
    self.timeLabel.text = [self composeString:model.created];
    
}
- (NSString *)dealTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *year = arr[0];
    NSString *time = [year substringFromIndex:5];
    return time;
}

- (NSString *)dealVisitorTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *year = arr[1];
    NSString *time = [year substringToIndex:5];
    return time;
}

- (NSString *)dealDate:(NSString *)str {
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:str];
    [String1 replaceCharactersInRange:NSMakeRange(10, 1) withString:@" "];
    
    NSString *string2 = [NSString stringWithFormat:@"%@",String1];
    NSString *string3 = [string2 substringWithRange:NSMakeRange(5,11)];
    return string3;
}
- (NSString *)composeString:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *string1 = [arr componentsJoinedByString:@" "];
    NSString *string2 = [string1 substringWithRange:NSMakeRange(5,11)];
    return string2;
}
@end































