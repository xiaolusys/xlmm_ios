//
//  ReBuyTableViewCell.m
//  XLMM
//
//  Created by younishijie on 15/11/12.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ReBuyTableViewCell.h"
#import "UIColor+RGBColor.h"

@implementation ReBuyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ReBuyTableViewCell" owner:self options:nil];
        if (arrayOfViews.count < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0]isKindOfClass:[UITableViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        self.reBuyButton.layer.cornerRadius = 16;
        self.reBuyButton.layer.borderWidth = 1;
        self.reBuyButton.layer.borderColor = [UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor;
        
    }
    return self;
}

- (IBAction)reBuyClicked:(id)sender {
    NSLog(@"重新购买");
    if (self.delegate && [self.delegate respondsToSelector:@selector(reBuyAddCarts:)]) {
        [self.delegate reBuyAddCarts:self.cartModel];
        
    }
    
}
@end
