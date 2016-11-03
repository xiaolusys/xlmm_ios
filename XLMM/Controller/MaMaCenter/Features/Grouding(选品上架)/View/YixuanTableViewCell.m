//
//  YixuanTableViewCell.m
//  XLMM
//
//  Created by younishijie on 16/3/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "YixuanTableViewCell.h"


@implementation YixuanTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        _addBtnClick.layer.cornerRadius = 15;
        //        _addBtnClick.layer.borderWidth = 0.5;
        //        _addBtnClick.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
        self = [[NSBundle mainBundle] loadNibNamed:@"YixuanTableViewCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)fillData:(JMAlreadyChooseModel *)model{
    [self.headImageView sd_setImageWithURL:[ NSURL URLWithString:[model.pic_path JMUrlEncodedString]]];
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor   = [UIColor buttonDisabledBorderColor].CGColor;
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.agent_price floatValue]];
    self.stdPriceLabel.text = [NSString stringWithFormat:@"/¥%.0f", [model.std_sale_price floatValue]];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.pdtID = model.product;
    self.model = model;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)xiajiaClicked:(id)sender {
    
    [self.delegate productxiajiaBtnClick:self btn:sender];
    
}
@end
