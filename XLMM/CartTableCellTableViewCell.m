//
//  CartTableCellTableViewCell.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartTableCellTableViewCell.h"

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
}

- (IBAction)addBtn:(id)sender {
    NSLog(@"add");
    
}

- (IBAction)deleteBtn:(id)sender {
    NSLog(@"delete");
    
}
@end
