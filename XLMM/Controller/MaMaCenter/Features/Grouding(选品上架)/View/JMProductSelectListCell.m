//
//  JMProductSelectListCell.m
//  XLMM
//
//  Created by zhang on 16/6/30.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMProductSelectListCell.h"

@interface JMProductSelectListCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *nameLabtl;

@property (nonatomic, strong) UILabel *agentPriceLabel;

@property (nonatomic, strong) UILabel *salePriceLabel;

@property (nonatomic, strong) UILabel *saleNumLabel;

@property (nonatomic, strong) UILabel *rebetLabel;

@property (nonatomic, strong) UILabel *nextRebetLabtl;

@property (nonatomic, strong) UILabel *vipLabel;

@property (nonatomic, strong) UIButton *addOrCancelButton;



@end

@implementation JMProductSelectListCell


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
    
    UILabel *nameLabtl = [UILabel new];
    [self.contentView addSubview:nameLabtl];
    self.nameLabtl = nameLabtl;
    self.nameLabtl.font = [UIFont systemFontOfSize:13.];
    self.nameLabtl.textColor = [UIColor cartViewBackGround];
    
    UILabel *agentPriceLabel = [UILabel new];
    [self.contentView addSubview:agentPriceLabel];
    self.agentPriceLabel = agentPriceLabel;
    self.agentPriceLabel.font = [UIFont boldSystemFontOfSize:18.];
    
    UILabel *currentLabel = [UILabel new];
    [self.contentView addSubview:currentLabel];
    currentLabel.text = @"/";
    currentLabel.font = [UIFont systemFontOfSize:12.];
    currentLabel.textColor = [UIColor timeLabelColor];
    
    UILabel *salePriceLabel = [UILabel new];
    [self.contentView addSubview:salePriceLabel];
    self.salePriceLabel = salePriceLabel;
    self.salePriceLabel.font = [UIFont systemFontOfSize:12.];
    self.salePriceLabel.textColor = [UIColor timeLabelColor];
    
    UIView *saleLineView = [UIView new];
    [self.salePriceLabel addSubview:saleLineView];
    saleLineView.backgroundColor = [UIColor timeLabelColor];
    
    UILabel *saleNumLabel = [UILabel new];
    [self.contentView addSubview:saleNumLabel];
    self.saleNumLabel = saleNumLabel;
    self.saleNumLabel.font = [UIFont systemFontOfSize:12.];
    self.saleNumLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *rebetLabel = [UILabel new];
    [self.contentView addSubview:rebetLabel];
    self.rebetLabel = rebetLabel;
    self.rebetLabel.font = [UIFont systemFontOfSize:11.];
    
    UILabel *nextRebetLabtl = [UILabel new];
    [self.contentView addSubview:nextRebetLabtl];
    self.nextRebetLabtl = nextRebetLabtl;
    self.nextRebetLabtl.font = [UIFont systemFontOfSize:11.];
    self.nextRebetLabtl.textColor = [UIColor buttonEnabledBackgroundColor];
    
    UILabel *vipLabel = [UILabel new];
    [self.contentView addSubview:vipLabel];
    self.vipLabel = vipLabel;
    self.vipLabel.font = [UIFont systemFontOfSize:11.];
    self.vipLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
//    UIButton *addOrCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.contentView addSubview:addOrCancelButton];
//    self.addOrCancelButton = addOrCancelButton;
//    [self.addOrCancelButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *statusLabel = [UILabel new];
//    [self.contentView addSubview:statusLabel];
//    self.statusLabel = statusLabel;
//    self.statusLabel.textColor = [UIColor cartViewBackGround];
//    self.statusLabel.font = [UIFont systemFontOfSize:12.];
    
    UIView *lineView = [UIView new];
    [self.contentView addSubview:lineView];
    
    kWeakSelf
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@100);
    }];
    
    [self.nameLabtl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImage).offset(5);
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(5);
        make.width.mas_equalTo(@(SCREENWIDTH - 120));
    }];
    
    [self.agentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabtl);
        make.top.equalTo(weakSelf.nameLabtl.mas_bottom).offset(10);
    }];
    [currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(weakSelf.agentPriceLabel);
        make.left.equalTo(weakSelf.agentPriceLabel.mas_right);
    }];
    [self.salePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(currentLabel.mas_right);
        make.bottom.equalTo(weakSelf.agentPriceLabel);
    }];
    [saleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.salePriceLabel);
        make.centerY.equalTo(weakSelf.salePriceLabel.mas_centerY);
        make.height.mas_equalTo(@1);
    }];
    
    [self.saleNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.agentPriceLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.agentPriceLabel);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.agentPriceLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.nameLabtl);
    }];
    
    [self.rebetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.nameLabtl);
    }];
    
    [self.vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nextRebetLabtl.mas_left);
        make.centerY.equalTo(weakSelf.rebetLabel.mas_centerY);
    }];
    
    [self.nextRebetLabtl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.rebetLabel.mas_centerY);
    }];
    
//    [self.addOrCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf.contentView).offset(-15);
//        make.top.equalTo(weakSelf.contentView).offset(30);
//        make.width.height.mas_equalTo(@40);
//    }];
//    
//    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.addOrCancelButton.mas_centerX);
//        make.top.equalTo(weakSelf.addOrCancelButton.mas_bottom);
//    }];
    
}

- (void)configListCell:(JMProductSelectionListModel *)model {
    
//    NSDictionary *dic = model.level_info;
//    self.leveModel = [JMLevelinfoModel mj_objectWithKeyValues:dic];
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[model.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImage.layer.cornerRadius = 8;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
    self.nameLabtl.text = model.name;
    self.agentPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.lowest_agent_price floatValue]];
    self.salePriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.lowest_std_sale_price floatValue]];
    self.saleNumLabel.text = [NSString stringWithFormat:@"%@人在卖",model.sale_num];
    
    if (model.is_boutique == 1) {
//        NSDictionary *dict = model.elite_level_prices;
        self.rebetLabel.text = CS_STRING(model.elite_level_prices.elite_level_price);
        self.nextRebetLabtl.text = [NSString stringWithFormat:@"  %@",model.elite_level_prices.next_elite_level_price];
        self.vipLabel.text = @"";
    }else {
        self.rebetLabel.text = CS_STRING(model.rebet_amount_desc);//[NSString stringWithFormat:@"返利佣金  ¥%.2f",rebetAmount];
        self.nextRebetLabtl.text = [NSString stringWithFormat:@"  %@",model.next_rebet_amount_desc];
        self.vipLabel.text = model.level_info.next_agencylevel_desc;
    }
//    CGFloat rebetAmount = [model.rebet_amount floatValue];
//    CGFloat nextRebetAmount = [model.next_rebet_amount floatValue];
    
    self.pdtID = [NSString stringWithFormat:@"%@", model.goodsID];
//    if ([model.in_customer_shop intValue]) {
//        self.addOrCancelButton.selected = YES;
//        [self.addOrCancelButton setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiaright"] forState:UIControlStateNormal];;
//        self.statusLabel.text = @"已加入";
//    }else {
//        self.addOrCancelButton.selected = NO;
//        [self.addOrCancelButton setBackgroundImage:[UIImage imageNamed:@"xuanpinshangjiajia"] forState:UIControlStateNormal];
//        self.statusLabel.text = @"加入精选";
//    }
}
//- (void)addButtonClick:(UIButton *)button {
//    if (_delegate && [_delegate respondsToSelector:@selector(composeProductSelectionList:addButton:)]) {
//        [_delegate composeProductSelectionList:self addButton:button];
//    }
//}

//我的精选
- (void)fillMyChoice:(JMProductSelectionListModel *)product {
    
//    NSDictionary *dic = product.level_info;
//    self.leveModel = [JMLevelinfoModel mj_objectWithKeyValues:dic];
    
    self.listModel = product;
    self.nameLabtl.text = product.name;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[product.pic_path imageGoodsOrderCompression] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei.png"]];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.pdtID = [NSString stringWithFormat:@"%@", product.goodsID];
    self.addOrCancelButton.selected = YES;
    self.addOrCancelButton.layer.cornerRadius = 12;
    self.addOrCancelButton.layer.borderWidth = 0.5;
    self.addOrCancelButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [self.addOrCancelButton setTitle:@"下架" forState:UIControlStateNormal];
    self.iconImage.layer.cornerRadius = 8;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderWidth = 0.5;
    self.iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
    self.agentPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.lowest_agent_price floatValue]];
    self.salePriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [product.lowest_std_sale_price floatValue]];
    self.rebetLabel.text = [NSString stringWithFormat:@"¥%.2f", [product.rebet_amount floatValue]];
    self.saleNumLabel.text = [NSString stringWithFormat:@"%ld件", (long)[product.sale_num integerValue]];
    
    //[self.addBtnClick setImage:[UIImage imageNamed:@"shopping_cart_jian.png"]forState:UIControlStateSelected];
}
@end


















