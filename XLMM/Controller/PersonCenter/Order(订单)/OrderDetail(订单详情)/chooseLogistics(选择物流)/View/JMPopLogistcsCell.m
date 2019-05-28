//
//  JMPopLogistcsCell.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopLogistcsCell.h"

@interface JMPopLogistcsCell ()

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UIImageView *iconImage;

//@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JMPopLogistcsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {

    UIImageView *iconImage = [UIImageView new];
    [self.contentView addSubview:iconImage];
    self.iconImage = iconImage;
    
    UILabel *nameLabel = [UILabel new];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.font = [UIFont systemFontOfSize:16.];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    
//    UILabel *descLabel = [UILabel new];
//    [self.contentView addSubview:descLabel];
//    self.descLabel = descLabel;
//    self.descLabel.font = [UIFont systemFontOfSize:12.];
//    self.descLabel.textColor = [UIColor dingfanxiangqingColor];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];

//    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
//        make.bottom.equalTo(weakSelf.contentView).offset(-10);
//    }];
//    

}
- (void)configWithModel:(JMPopLogistcsModel *)model Index:(NSInteger)index {
    
    self.nameLabel.text = model.name;
    NSString *code = model.code;
    if ([code isEqualToString:@"POSTB"]) {
        self.iconImage.image = [UIImage imageNamed:@"logistics_youzheng"];
    }else if ([code isEqualToString:@"STO"]) {
        self.iconImage.image = [UIImage imageNamed:@"logistics_shentong"];
    }else if ([code isEqualToString:@"YUNDA_QR"]) {
        self.iconImage.image = [UIImage imageNamed:@"logistics_yunda"];
    }else {
        self.iconImage.image = [UIImage imageNamed:@"logistics_xiaolu"];
    }

}


@end

/**
 *  <__NSCFArray 0x1838ea90>(
 {
 code = "";
 id = "";
 "is_priority" = 1;
 name = "\U81ea\U52a8\U5206\U914d";
 },
 {
 code = POSTB;
 id = 200734;
 "is_priority" = 0;
 name = "\U90ae\U653f\U5c0f\U5305";
 },
 {
 code = STO;
 id = 100;
 "is_priority" = 0;
 name = "\U7533\U901a\U5feb\U9012";
 },
 {
 code = "YUNDA_QR";
 id = "-2";
 "is_priority" = 0;
 name = "\U97f5\U8fbe\U5feb\U9012";
 }
 )

 */




















