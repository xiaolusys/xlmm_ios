//
//  ReBuyTableViewCell.m
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ReBuyTableViewCell.h"


@implementation ReBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UILabel *deleateLine = [UILabel new];
    [self.allPriceLabel addSubview:deleateLine];
    self.deleateLine = deleateLine;
    self.deleateLine.backgroundColor = [UIColor lightGrayColor];
    [self.deleateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allPriceLabel.mas_centerY);
        make.left.equalTo(self.allPriceLabel);
        make.right.equalTo(self.allPriceLabel);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ReBuyTableViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UITableViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.reBuyButton.layer.cornerRadius = 14;
        self.reBuyButton.layer.borderWidth = 1;
        self.reBuyButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self.headImageView addGestureRecognizer:tap];
        self.headImageView.userInteractionEnabled = YES;
        
    }
    return self;
}

- (IBAction)reBuyClicked:(id)sender {
    NSLog(@"重新购买");
    if (self.delegate && [self.delegate respondsToSelector:@selector(reBuyAddCarts:)]) {
        [self.delegate reBuyAddCarts:self.cartModel];
        
    }
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    if (_delegate && [_delegate respondsToSelector:@selector(composeImageTap:)]) {
        [_delegate composeImageTap:self.cartModel];
    }
    
}
@end
















































