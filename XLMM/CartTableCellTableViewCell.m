//
//  CartTableCellTableViewCell.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartTableCellTableViewCell.h"
#import "MMClass.h"

@implementation CartTableCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reduceBtn:(id)sender {
    NSLog(@"reduce");
    NSInteger number = [self.numberLabel.text integerValue];
    number --;
    if (number == 0) {
        NSLog(@"买一个吧");
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCartView:)]) {
            [self.delegate deleteCartView:_cartModel];
        }
       
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(reduceNumber:)]) {
            [self.delegate reduceNumber:_cartModel];
        }
    }
}

- (IBAction)addBtn:(id)sender {
    NSLog(@"add");
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNumber:)]) {
        [self.delegate addNumber:_cartModel];
    }
    
}






@end
