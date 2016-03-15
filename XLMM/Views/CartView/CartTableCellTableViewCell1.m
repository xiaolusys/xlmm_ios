//
//  CartTableCellTableViewCell.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartTableCellTableViewCell1.h"
#import "MMClass.h"

@implementation CartTableCellTableViewCell1

- (void)awakeFromNib {
    // Initialization code
}

- (void)drawRect:(CGRect)rect{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CartTableCellTableViewCell1" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UITableViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        
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
