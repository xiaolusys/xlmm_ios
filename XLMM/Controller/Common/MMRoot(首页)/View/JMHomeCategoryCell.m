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
    self.iconImage1.userInteractionEnabled = YES;
    self.iconImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImage1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.iconImage1 addGestureRecognizer:tap];
    UIView *tapView1 = [tap view];
    tapView1.tag = 100;
    
    
    self.iconImage2 = [UIImageView new];
    self.iconImage2.userInteractionEnabled = YES;
    self.iconImage2.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.iconImage2];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.iconImage2 addGestureRecognizer:tap1];
    UIView *tapView2 = [tap1 view];
    tapView2.tag = 101;
    
    
    kWeakSelf
    [self.iconImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.left.equalTo(weakSelf.contentView).offset(5);
        make.width.mas_equalTo(@((SCREENWIDTH) / 2));
        make.height.mas_equalTo(@(SCREENWIDTH * 0.32));
    }];
    
    [self.iconImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.right.equalTo(weakSelf.contentView).offset(-5);
        make.width.mas_equalTo(@((SCREENWIDTH) / 2));
        make.height.mas_equalTo(@(SCREENWIDTH * 0.32));
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

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIView *tapView = [tap view];
    NSInteger index = tapView.tag;
    if (_delegate && [_delegate respondsToSelector:@selector(composeCategoryCellTapView:TapClick:)]) {
        [_delegate composeCategoryCellTapView:self TapClick:index];
    }
    
}





@end



































































































































