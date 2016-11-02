//
//  JMGoodsExplainCell.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsExplainCell.h"
#import "JMCountDownView.h"

NSString *const JMGoodsExplainCellIdentifier = @"JMGoodsExplainCellIdentifier";

@interface JMGoodsExplainCell ()//<JMCountDownViewDelegate>

@property (nonatomic, strong) UILabel *nameTitle;

@property (nonatomic, strong) UILabel *PriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
@property (nonatomic, strong) UILabel *itemMask;

@property (nonatomic, strong) UILabel *timerLabel;

@property (nonatomic, strong) UIButton *storeUpButton;

@property (nonatomic, strong) JMCountDownView *countDownView;


@end

@implementation JMGoodsExplainCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)setDetailContentDic:(NSDictionary *)detailContentDic {
    _detailContentDic = detailContentDic;
    self.nameTitle.text = detailContentDic[@"name"];
    self.PriceLabel.text = [NSString stringWithFormat:@"¥%.2f",[detailContentDic[@"lowest_agent_price"] floatValue]];
    self.oldPriceLabel.text = [NSString stringWithFormat:@"%.2f",[detailContentDic[@"lowest_std_sale_price"] floatValue]];
//    self.timerLabel.text = detailContentDic[@"offshelf_time"];

    NSArray *itemMask = detailContentDic[@"item_marks"];
    NSString *itemString = @"包邮";
    if (itemMask.count == 0) {
        return ;
    }else {
        itemString = itemMask[0];
    
    }
    self.itemMask.text = [NSString stringWithFormat:@"%@",itemString];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
    CGSize size = [itemString sizeWithAttributes:dic];
    [self.itemMask mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(size.width + 20));
    }];
//    self.itemMask.textAlignment = NSTextAlignmentCenter;
    
    // === 处理结束时间 === //

    NSString *endTime = @"";
    NSString *timeString = detailContentDic[@"offshelf_time"];
    if ([NSString isStringEmpty:timeString]) {
        self.timerLabel.text = @"即将上架";
    }else {
        endTime = [self spaceFormatTimeString:detailContentDic[@"offshelf_time"]];
        self.countDownView = [JMCountDownView shareCountDown];
//            [JMCountDownView countDownWithCurrentTime:endTime];
        [self.countDownView initWithCountDownTime:endTime];
        //    self.countDownView.delegate = self;
        kWeakSelf
        self.countDownView.timeBlock = ^(NSString *timeString) {
            weakSelf.timerLabel.text = timeString;
        };
    }
    

    
    
}
-(NSString*)spaceFormatTimeString:(NSString*)timeString{
    if ([NSString isStringEmpty:timeString]) {
        return nil;
    }else {
        NSMutableString *ms = [NSMutableString stringWithString:timeString];
        NSRange range = {10,1};
        [ms replaceCharactersInRange:range withString:@" "];
        return ms;
    }
}
- (void)setCustomInfoDic:(NSDictionary *)customInfoDic {
    _customInfoDic = customInfoDic;
    BOOL isSelected = [customInfoDic[@"is_favorite"] boolValue];
    self.storeUpButton.selected = isSelected;
}
- (void)initUI {
    
    UIView *contentView = [UIView new];
    [self.contentView addSubview:contentView];
    
    UILabel *nameTitle = [UILabel new];
    [contentView addSubview:nameTitle];
    nameTitle.font = [UIFont systemFontOfSize:18.];
    nameTitle.textColor = [UIColor buttonTitleColor];
    self.nameTitle = nameTitle;
    
    UILabel *PriceLabel = [UILabel new];
    [contentView addSubview:PriceLabel];
    PriceLabel.font = [UIFont systemFontOfSize:33.];
    PriceLabel.textColor = [UIColor buttonTitleColor];
    self.PriceLabel = PriceLabel;
    
    UILabel *curreLabel = [UILabel new];
    [contentView addSubview:curreLabel];
    curreLabel.text = @"/";
    curreLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *oldPriceLabel = [UILabel new];
    [contentView addSubview:oldPriceLabel];
    oldPriceLabel.font = [UIFont systemFontOfSize:13.];
    oldPriceLabel.textColor = [UIColor dingfanxiangqingColor];
    self.oldPriceLabel = oldPriceLabel;
    
    UILabel *deletLine = [UILabel new];
    [contentView addSubview:deletLine];
    deletLine.backgroundColor = [UIColor titleDarkGrayColor];
    
    UIButton *shoucangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView addSubview:shoucangButton];
    [shoucangButton setImage:[UIImage imageNamed:@"MyCollection_Nomal"] forState:UIControlStateNormal];
    [shoucangButton setImage:[UIImage imageNamed:@"MyCollection_Selected"] forState:UIControlStateSelected];
    [shoucangButton setTitle:@"加入收藏" forState:UIControlStateNormal];
    [shoucangButton setTitle:@"取消收藏" forState:UIControlStateSelected];
    [shoucangButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    [shoucangButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateSelected];
    shoucangButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [shoucangButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    self.storeUpButton = shoucangButton;
//    shoucangButton.tag = 100;
//    shoucangButton.selected = NO;
    [shoucangButton addTarget:self action:@selector(storeUpClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *baoyou = [UILabel new];
    [contentView addSubview:baoyou];
    baoyou.font = [UIFont systemFontOfSize:16.];
    baoyou.textColor = [UIColor buttonEnabledBackgroundColor];
    baoyou.textAlignment = NSTextAlignmentCenter;
    baoyou.layer.masksToBounds = YES;
    baoyou.layer.borderWidth = 1.0;
    baoyou.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    baoyou.layer.cornerRadius = 5.;
    self.itemMask = baoyou;
    
    UIView *currentView = [UIView new];
    [self.contentView addSubview:currentView];
    currentView.backgroundColor = [UIColor lineGrayColor];
    
    
    UIView *timerView = [UIView new];
    [self.contentView addSubview:timerView];
    
    UILabel *shengyuTimer = [UILabel new];
    [timerView addSubview:shengyuTimer];
    shengyuTimer.font = [UIFont systemFontOfSize:14.];
    shengyuTimer.textColor = [UIColor buttonTitleColor];
    shengyuTimer.text = @"剩余时间";
    
    UILabel *timerLabel = [UILabel new];
    [timerView addSubview:timerLabel];
    timerLabel.font = [UIFont systemFontOfSize:14.];
    timerLabel.textColor = [UIColor buttonTitleColor];
    self.timerLabel = timerLabel;
    

    kWeakSelf
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@110);
    }];
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(20);
        make.width.mas_equalTo(@(SCREENWIDTH - 120));
    }];
    [PriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameTitle);
        make.bottom.equalTo(contentView.mas_bottom).offset(-15);
    }];
    
    [curreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(PriceLabel.mas_bottom).offset(-5);
        make.left.equalTo(PriceLabel.mas_right);
        make.height.mas_equalTo(@13);
    }];
    [oldPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(curreLabel.mas_right).offset(2);
        //        make.bottom.equalTo(headerView.mas_bottom).offset(-15);
        make.centerY.equalTo(curreLabel.mas_centerY);
    }];
    
    
    [shoucangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView);
        make.centerY.equalTo(nameTitle.mas_centerY);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@40);
    }];
    
    [deletLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(oldPriceLabel.mas_centerY);
        make.left.right.equalTo(oldPriceLabel);
        make.height.mas_equalTo(@1);
    }];
    
    [baoyou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shoucangButton).offset(-20);
        make.bottom.equalTo(contentView).offset(-20);
        make.height.mas_equalTo(@20);
    }];
    
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@1);
    }];
    
    [timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currentView.mas_bottom);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(@39);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    [shengyuTimer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timerView).offset(10);
        make.centerY.equalTo(timerView.mas_centerY);
    }];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timerView).offset(-10);
        make.centerY.equalTo(timerView.mas_centerY);
    }];

}

- (void)storeUpClick:(UIButton *)button {
//    button.selected = !button.selected;
    if (self.block) {
        self.block(button);
    }
    
}
//-(void)countDownStart:(NSString *)countDownTimeArr {
//    self.timerLabel.text = countDownTimeArr;
//}
//
//-(void)countDownEnd:(NSString *)countDownTimeArr {
//    self.timerLabel.text = @"商品已下架";
//}
//




@end






















































