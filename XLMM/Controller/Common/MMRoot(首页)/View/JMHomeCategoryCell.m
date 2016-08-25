//
//  JMHomeCategoryCell.m
//  XLMM
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMHomeCategoryCell.h"
#import "MMClass.h"

NSString *const JMHomeCategoryCellIdentifier = @"JMHomeCategoryCellIdentifier";

@interface JMHomeCategoryCell ()

@property (nonatomic, strong) UIImageView *iconImage1;
@property (nonatomic, strong) UIImageView *iconImage2;

@end

@implementation JMHomeCategoryCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
        
    }
    return self;
}


- (void)createUI {
    
    self.iconImage1 = [UIImageView new];
    self.iconImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImage1];
    
    self.iconImage2 = [UIImageView new];
    self.iconImage2.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImage2];
    
    kWeakSelf
    [self.iconImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(5);
        make.width.mas_equalTo(@((SCREENWIDTH - 15) / 2));
        make.height.mas_equalTo(@120);
    }];
    
    [self.iconImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.right.equalTo(weakSelf.contentView).offset(-5);
        make.width.mas_equalTo(@((SCREENWIDTH - 15) / 2));
        make.height.mas_equalTo(@120);
    }];
    
    
    
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    _imageArray = imageArray;
    
    if (imageArray.count == 0) {
        
    }else {
        [self.iconImage1 sd_setImageWithURL:[NSURL URLWithString:[imageArray[0] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
        [self.iconImage2 sd_setImageWithURL:[NSURL URLWithString:[imageArray[1] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"]];
    }
    
    
}





@end



































































































































