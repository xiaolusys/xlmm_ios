//
//  JMPushingDaysCell.m
//  XLMM
//
//  Created by zhang on 16/10/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDaysCell.h"
#import "SharePicModel.h"
#import "JMPushingDaysPhotoContainer.h"
#import "MMClass.h"
#import "JMSelecterButton.h"

@interface JMPushingDaysCell () {
    CGFloat conteH;
    CGFloat imageViewW;
    long lineNumber;
    
}
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *nameImage;
@property (nonatomic, strong) JMSelecterButton *baocunButton;
@property (nonatomic, strong) JMPushingDaysPhotoContainer *photoContainerView;



@end

@implementation JMPushingDaysCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initUI];
        
        
        
    }
    return self;
}
- (void)initUI {
    
    self.nameImage = [UIImageView new];
    [self.contentView addSubview:self.nameImage];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = CS_SYSTEMFONT(16.);
    self.timeLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    [self.contentView addSubview:self.detailLabel];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = CS_SYSTEMFONT(14.);
    [self.contentView addSubview:self.detailLabel];
    
    self.photoContainerView = [JMPushingDaysPhotoContainer new];
    self.photoContainerView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.photoContainerView];
    
    [self.baocunButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"保存图片" TitleFont:14. CornerRadius:20];
    [self.contentView addSubview:self.baocunButton];

    kWeakSelf
    
    [self.nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.contentView).offset(10);
        make.width.height.mas_equalTo(@60);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameImage);
        make.left.equalTo(weakSelf.nameImage.mas_right).offset(10);
        make.width.mas_equalTo(@(SCREENWIDTH - 95));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLabel);
        make.top.equalTo(weakSelf.timeLabel.mas_bottom);
        make.width.mas_equalTo(@(SCREENWIDTH - 95));
    }];
    [self.photoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.detailLabel.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.timeLabel);
        make.width.mas_equalTo(@(SCREENWIDTH - 90));
        make.height.mas_equalTo(@(SCREENWIDTH - 90));
    }];
    [self.baocunButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset((SCREENWIDTH - 90) * 0.15 + 80);
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.width.mas_equalTo(@((SCREENWIDTH - 90) * 0.7));
        make.height.mas_equalTo(@40);
    }];
    
    
    
    
}
- (void)setModel:(SharePicModel *)model {
    _model = model;
    self.nameImage.backgroundColor = [UIColor redColor];
    self.timeLabel.text = model.start_time;
    self.detailLabel.text = model.title;
    self.photoContainerView.picPathStringsArray = model.pic_arry;

}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.timeLabel sizeThatFits:size].height;
    totalHeight += [self.detailLabel sizeThatFits:size].height;
    CGFloat photoViewH = [self.photoContainerView sizeThatFits:CGSizeMake(SCREENWIDTH - 90, 0)].height;
    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(photoViewH));
    }];
    totalHeight += photoViewH;
    //    totalHeight += [self.bottomView sizeThatFits:size].height;
//    totalHeight += conteH;
    totalHeight += 120; // margins
    return CGSizeMake(size.width, totalHeight);
    
    
}


@end

















































































