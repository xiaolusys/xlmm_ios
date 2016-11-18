//
//  JMPushingDayCell.m
//  XLMM
//
//  Created by zhang on 16/11/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDayCell.h"
#import "SharePicModel.h"
#import "JMPicContainerView.h"

@interface JMPushingDayCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *desTitleLabel;

@property (nonatomic, strong) JMPicContainerView *picView;

//@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *savePhotoBtn;

@end

@implementation JMPushingDayCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}




- (void)initUI {
    kWeakSelf
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor settingBackgroundColor];
    self.titleLabel.font = CS_SYSTEMFONT(16.);
    [self.contentView addSubview:self.titleLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor dingfanxiangqingColor];
    self.timeLabel.font = CS_SYSTEMFONT(12.);
    [self.contentView addSubview:self.timeLabel];
    
    self.desTitleLabel = [UILabel new];
    self.desTitleLabel.textColor = [UIColor buttonTitleColor];
    self.desTitleLabel.font = CS_SYSTEMFONT(15.);
    self.desTitleLabel.numberOfLines = 0.;
    [self.contentView addSubview:self.desTitleLabel];
    
    self.picView = [JMPicContainerView new];
    [self.contentView addSubview:self.picView];
    
    
    UIView *toolView = [UIView new];
    [self.contentView addSubview:toolView];
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:self.likeButton];
    [self.likeButton setImage:[UIImage imageNamed:@"pushingDays_saveImage"] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    self.likeButton.titleLabel.font = CS_SYSTEMFONT(12.);
    self.likeButton.enabled = NO;
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolView addSubview:self.shareButton];
    [self.shareButton setImage:[UIImage imageNamed:@"pushingDays_shareImage"] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = CS_SYSTEMFONT(12.);
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.shareButton.enabled = NO;
    
    self.savePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:self.savePhotoBtn];
    self.savePhotoBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.savePhotoBtn.layer.borderWidth = 1.0;
    self.savePhotoBtn.layer.cornerRadius = 15;
    self.savePhotoBtn.titleLabel.textColor = [UIColor buttonEmptyBorderColor];
    self.savePhotoBtn.userInteractionEnabled = YES;
    self.savePhotoBtn.alpha = 1.0;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf.contentView).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.titleLabel);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
    }];
    [self.desTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.titleLabel);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
    }];
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.desTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.titleLabel);
        make.width.mas_equalTo(@(SCREENWIDTH - 20));
        make.height.mas_equalTo(@0);
    }];
    
    [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.picView.mas_bottom).offset(0);
        make.left.equalTo(weakSelf.contentView);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(30));
    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.shareButton.mas_left);
        make.centerY.equalTo(toolView);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@(30));
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(toolView);
        make.centerY.equalTo(toolView);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@(30));
    }];
    [self.savePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.top.equalTo(toolView.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(@(200));
        make.height.mas_equalTo(@(30));
    }];

    
    
}

- (void)setPicModel:(SharePicModel *)picModel {
    _picModel = picModel;
    
    self.titleLabel.text = picModel.title_content;
    self.timeLabel.text = [NSString jm_cutOutYearWihtSec:picModel.start_time];
    self.desTitleLabel.text = picModel.descriptionTitle;
    self.picView.picUrlArray = picModel.pic_arry;
    [self.likeButton setTitle:picModel.save_times forState:UIControlStateNormal];
    [self.shareButton setTitle:picModel.save_times forState:UIControlStateNormal];
    
    
}


- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.timeLabel sizeThatFits:size].height;
    totalHeight += [self.desTitleLabel sizeThatFits:size].height;
    totalHeight += [self.picView sizeThatFits:size].height;
    totalHeight += 100.;
    
    return CGSizeMake(size.width, totalHeight);
}











@end



































