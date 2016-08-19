//
//  JMHomeActiveCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeActiveCell.h"

NSString *const JMHomeActiveCellIdentifier = @"JMHomeActiveCellIdentifier";

@interface JMHomeActiveCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JMHomeActiveCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)createUI {
    
    self.iconImage = [UIImageView new];
    [self.contentView addSubview:self.iconImage];
    self.iconImage.contentMode = UIViewContentModeScaleAspectFill;
    
}







@end
