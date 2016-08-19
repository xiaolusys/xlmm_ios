//
//  JMHomeCategoryCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeCategoryCell.h"

NSString *const JMHomeCategoryCellIdentifier = @"JMHomeCategoryCellIdentifier";

@interface JMHomeCategoryCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JMHomeCategoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

    }
    return self;
}



@end
