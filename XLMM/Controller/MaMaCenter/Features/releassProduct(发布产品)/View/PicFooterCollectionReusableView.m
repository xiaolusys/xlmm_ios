//
//  PicFooterCollectionReusableView.m
//  XLMM
//
//  Created by 张迎 on 16/1/7.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PicFooterCollectionReusableView.h"
#import "MMClass.h"

@implementation PicFooterCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    self.savePhotoBtn.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    self.savePhotoBtn.layer.borderWidth = 1.0;
    self.savePhotoBtn.layer.cornerRadius = 15;
    self.savePhotoBtn.titleLabel.textColor = [UIColor buttonEmptyBorderColor];
    self.savePhotoBtn.userInteractionEnabled = YES;
    self.savePhotoBtn.alpha = 1.0;
    
//    self.seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.statisticsView addSubview:self.seeButton];
//    [self.seeButton setImage:[UIImage imageNamed:@"display_passwd_icon"] forState:UIControlStateNormal];
//    [self.seeButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
//    self.seeButton.enabled = NO;
//    self.seeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
//    self.seeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statisticsView addSubview:self.likeButton];
    [self.likeButton setImage:[UIImage imageNamed:@"pushingDays_saveImage"] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    self.likeButton.titleLabel.font = CS_SYSTEMFONT(12.);
    self.likeButton.enabled = NO;
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.statisticsView addSubview:self.shareButton];
    [self.shareButton setImage:[UIImage imageNamed:@"pushingDays_shareImage"] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor dingfanxiangqingColor] forState:UIControlStateNormal];
    self.shareButton.titleLabel.font = CS_SYSTEMFONT(12.);
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.shareButton.enabled = NO;
    
    kWeakSelf
//    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.statisticsView);
//        make.centerY.equalTo(weakSelf.statisticsView);
//        make.width.mas_equalTo(@(80));
//        make.height.mas_equalTo(@(40));
//    }];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.shareButton.mas_left);
        make.centerY.equalTo(weakSelf.statisticsView);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@(30));
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.statisticsView);
        make.centerY.equalTo(weakSelf.statisticsView);
        make.width.mas_equalTo(@(70));
        make.height.mas_equalTo(@(30));
    }];
    
    
    
    
    
    
}

@end
