//
//  JMMaMaCenterHeaderView.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaCenterHeaderView.h"
#import "MMClass.h"
#import "JMMaMaExtraModel.h"
#import "NSArray+Reverse.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "DotLineView.h"
#import "JMMaMaCenterModel.h"

@interface JMMaMaCenterHeaderView ()<UIScrollViewDelegate>
/**
 *  顶部视图
 */
@property (nonatomic, strong) UIImageView *topView;
/**
 *  折线视图
 */
@property (nonatomic, strong) UIScrollView *foldLineScrollView;
@property (nonatomic, strong) UIImageView *mamaImage;

@property (nonatomic, strong)FSLineChart *lineChart;
@property (nonatomic, strong) UIView *orongeCircleView;
@property (nonatomic, strong) UIView *anotherOrongeView;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *lastweeknames;
@property (nonatomic, strong) NSMutableArray *anotherLabelArray;
@property (nonatomic, strong)NSNumber *visitorDate;
/**
 *  工具栏
 */
@property (nonatomic, strong) UIView *toolView;
/**
 *  今日收益
 */
@property (nonatomic, strong) UILabel *todayEarningsLabel;
/**
 *  潜在收益
 */
@property (nonatomic, strong) UILabel *futureEarningsLabe;
/**
 *  排名
 */
@property (nonatomic, strong) UILabel *rankingLabel;
/**
 *  妈妈头像
 */
@property (nonatomic, strong) UIImageView *mamaIconImage;
/**
 *  MaMaID
 */
@property (nonatomic, strong) UILabel *mamaIDLabel;
/**
 *  Vip剩余时间
 */
@property (nonatomic, strong) UILabel *remainingTimeLabel;
/**
 *  MaMa是不是会员
 */
@property (nonatomic, strong) UILabel *isMaMaVipLabel;
/**
 *  MaMa等级
 */
@property (nonatomic, strong) UILabel *mamaLeveLabel;
/**
 *  续费图片
 */
@property (nonatomic, strong) UIButton *renewButton;
/**
 *  Vip等级考试
 */
@property (nonatomic, strong) UIImageView *vipExamination;
/**
 *  账户余额
 */
@property (nonatomic, strong) UILabel *balanceLabel;
/**
 *  累计收益
 */
@property (nonatomic, strong) UILabel *accumulatedEarningsLabel;
/**
 *  活跃度
 */
@property (nonatomic, strong) UILabel *activenessLabel;

@property (nonatomic, strong) JMMaMaExtraModel *extraModel;

@property (nonatomic, strong) NSArray *mamaOrderArray;

@property (nonatomic, strong) NSNumber *weekDay;

@end

@implementation JMMaMaCenterHeaderView {
    CGPoint scrollViewContentOffset;
    NSMutableArray *allDingdan;
    int quxiaodays;
    NSMutableArray *dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor countLabelColor];
        self.visitorDate = [NSNumber numberWithInt:0];
        dataArray = [[NSMutableArray alloc] initWithCapacity:30];
        allDingdan = [[NSMutableArray alloc] init];
        self.labelArray = [[NSMutableArray alloc] init];
        self.lastweeknames = [[NSMutableArray alloc] init];
        self.anotherLabelArray = [[NSMutableArray alloc] init];
        [self createMaMaCenterView];
        [self createWeekDay];
        [self createButtons];
        [self createChart:dataArray];
    }
    return self;
}

+ (instancetype)enterHeaderView {
    JMMaMaCenterHeaderView *headView = [[JMMaMaCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 380)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (void)setMamaCenterModel:(JMMaMaCenterModel *)mamaCenterModel {
    _mamaCenterModel = mamaCenterModel;
    
    self.extraModel = [JMMaMaExtraModel mj_objectWithKeyValues:mamaCenterModel.extra_info];
    
    self.isMaMaVipLabel.text = self.mamaCenterModel.mama_level_display;
    
    self.mamaLeveLabel.text = self.extraModel.agencylevel_display;
    
    self.mamaIDLabel.text = [NSString stringWithFormat:@"ID: %@",mamaCenterModel.mama_id];
    
    NSString *limtStr = self.extraModel.surplus_days;
    
    NSInteger limtCount = [limtStr integerValue];
//    if (limtCount > 15) {
//        self.renewButton.hidden = YES;
//    }
    
    NSString *numStr = [NSString stringWithFormat:@"会员剩余期限%@天",limtStr];
    NSInteger count = limtStr.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:numStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6,count)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(count + 6,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(0, 6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0] range:NSMakeRange(6, count)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0] range:NSMakeRange(6+count, 1)];
    self.remainingTimeLabel.attributedText = str;

    [self.mamaIconImage sd_setImageWithURL:[NSURL URLWithString:[self.extraModel.thumbnail JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[mamaCenterModel.cash_value floatValue]];
    self.accumulatedEarningsLabel.text = [NSString stringWithFormat:@"%.2f",[mamaCenterModel.carry_value floatValue]];
    self.activenessLabel.text = mamaCenterModel.active_value_num;
    
}
- (void)createMaMaCenterView {
    // 妈妈个人信息视图 //
    self.topView = [UIImageView new];
    [self addSubview:self.topView];
    self.topView.image = [UIImage imageNamed:@"wodejingxuanback"];
    self.topView.userInteractionEnabled = YES;
    
    UIView *selfInfoView = [UIView new];
    [self.topView addSubview:selfInfoView];
    
    UIImageView *mamaIconBackImage = [UIImageView new]; //wodejingxuantouxiangicon -- > 妈妈头像底层图片
    [selfInfoView addSubview:mamaIconBackImage];
    mamaIconBackImage.image = [UIImage imageNamed:@"wodejingxuantouxiangicon"];
    
    UIImageView *mamaIconImage = [UIImageView new];
    [mamaIconBackImage addSubview:mamaIconImage];
    self.mamaIconImage = mamaIconImage;
    self.mamaIconImage.layer.masksToBounds = YES;
    self.mamaIconImage.layer.cornerRadius = 35.;
    self.mamaIconImage.layer.borderWidth = 1.;
    self.mamaIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UILabel *mamaIDLabel = [UILabel new];
    [selfInfoView addSubview:mamaIDLabel];
    self.mamaIDLabel = mamaIDLabel;
    self.mamaIDLabel.font = [UIFont boldSystemFontOfSize:18.];
    
    UIImageView *isMaMaVipImage = [UIImageView new];
    [selfInfoView addSubview:isMaMaVipImage];
    isMaMaVipImage.backgroundColor = [UIColor clearColor];
    isMaMaVipImage.image = [UIImage imageNamed:@"mamaUser_DiamondsIcon"];
    
    UILabel *isMaMaVipLabel = [UILabel new];
    [selfInfoView addSubview:isMaMaVipLabel];
    self.isMaMaVipLabel = isMaMaVipLabel;
    self.isMaMaVipLabel.font = [UIFont systemFontOfSize:14.];
    
    UIImageView *levelImage = [UIImageView new];
    [selfInfoView addSubview:levelImage];
    levelImage.image = [UIImage imageNamed:@"mamaCrown_orangeColor"];
    
    UILabel *mamaLeveLabel = [UILabel new];
    [selfInfoView addSubview:mamaLeveLabel];
    self.mamaLeveLabel = mamaLeveLabel;
    self.mamaLeveLabel.font = [UIFont boldSystemFontOfSize:12.];
    
    UIButton *vipExaminationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selfInfoView addSubview:vipExaminationButton];
    [vipExaminationButton setImage:[UIImage imageNamed:@"vipGrade_Examination"] forState:UIControlStateNormal];
    vipExaminationButton.tag = 106;
    [vipExaminationButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView *vipExamination = [UIImageView new];
//    [vipExaminationButton addSubview:vipExamination];
//    self.vipExamination = vipExamination;
//    self.vipExamination.userInteractionEnabled = YES;
//    self.vipExamination.image = [UIImage imageNamed:@"vipGrade_Examination"];
    
    UILabel *lineView = [UILabel new];
    [selfInfoView addSubview:lineView];
    lineView.backgroundColor = [UIColor mamaCenterBorderColor];

    // 会员剩余时间视图 //
    UIView *remainView = [UIView new];
    [selfInfoView addSubview:remainView];
    
    UILabel *remainingTimeLabel = [UILabel new];
    [remainView addSubview:remainingTimeLabel];
    self.remainingTimeLabel = remainingTimeLabel;
    self.remainingTimeLabel.font = [UIFont systemFontOfSize:14.];
    
    
    self.renewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [remainView addSubview:self.renewButton];
    [self.renewButton setImage:[UIImage imageNamed:@"MaMa_renew"] forState:UIControlStateNormal];
    self.renewButton.tag = 107;
    [self.renewButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *accountView = [UIView new];
    [self.topView addSubview:accountView];
    
    UILabel *currentView = [UILabel new];
    [accountView addSubview:currentView];
    currentView.backgroundColor = [UIColor whiteColor];
    
    // == 折线图视图 == //
    UIScrollView *foldLineScrollView = [UIScrollView new];
    [self addSubview:foldLineScrollView];
    self.foldLineScrollView = foldLineScrollView;
    
    UIImageView *mamaImage = [UIImageView new];
    [self.foldLineScrollView addSubview:mamaImage];
    self.mamaImage = mamaImage;
    self.mamaImage.image = [UIImage imageNamed:@"mamanodata"];
    
    // 个人收益视图 //
    UIView *toolView = [UIView new];
    [self addSubview:toolView];
    self.toolView = toolView;
    
//    self.todayEarningsLabel = [UILabel new];
//    [self.toolView addSubview:self.todayEarningsLabel];
//    self.todayEarningsLabel.textAlignment = NSTextAlignmentCenter;
//    self.todayEarningsLabel.attributedText = [self attributeStr:@"今日收益 123.23" Index:4];
//    
//    self.futureEarningsLabe = [UILabel new];
//    [self.toolView addSubview:self.futureEarningsLabe];
//    self.futureEarningsLabe.textAlignment = NSTextAlignmentCenter;
//    self.futureEarningsLabe.attributedText = [self attributeStr:@"潜在收益 123.45" Index:4];
//    
//    self.rankingLabel = [UILabel new];
//    [self.toolView addSubview:self.rankingLabel];
//    self.rankingLabel.textAlignment = NSTextAlignmentCenter;
//    self.rankingLabel.attributedText = [self attributeStr:@"排名 3" Index:2];
    
    kWeakSelf
    CGFloat toolW = SCREENWIDTH / 3;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(@170);
    }];
    
    [selfInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.topView);
        make.height.mas_equalTo(@120);
    }];
    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selfInfoView).offset(15);
        make.centerY.equalTo(selfInfoView.mas_centerY);
        make.width.height.mas_equalTo(@80);
    }];
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@70);
    }];
    
    [self.mamaIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mamaIconBackImage).offset(5);
        make.left.equalTo(mamaIconBackImage.mas_right).offset(20);
    }];
    
    [isMaMaVipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mamaIDLabel);
        make.top.equalTo(weakSelf.mamaIDLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@12);
    }];
    [self.isMaMaVipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isMaMaVipImage.mas_right).offset(2);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
    }];
    [levelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.isMaMaVipLabel.mas_right).offset(15);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
        make.width.mas_equalTo(@15);
        make.height.mas_equalTo(@12);
    }];
    [self.mamaLeveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelImage.mas_right).offset(2);
        make.centerY.equalTo(isMaMaVipImage.mas_centerY);
    }];
    
    [vipExaminationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selfInfoView).offset(-10);
        make.bottom.equalTo(lineView).offset(-15);
        make.width.mas_equalTo(@60);
        make.height.mas_equalTo(@45);
    }];
//    [self.vipExamination mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(vipExaminationButton.mas_centerX);
//        make.centerY.equalTo(vipExaminationButton.mas_centerY);
//        make.width.mas_equalTo(@60);
//        make.height.mas_equalTo(@45);
//    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mamaIDLabel);
        make.right.equalTo(selfInfoView);
        make.height.mas_equalTo(@1);
        make.top.equalTo(mamaIconBackImage.mas_centerY).offset(20);
    }];
    [currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(accountView);
        make.height.mas_equalTo(@1);
    }];
    [accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.topView);
        make.height.mas_equalTo(@50);
    }];
    NSInteger count = 3;
    CGFloat accountH = 50;
    NSArray *accountArr = @[@"账户余额",@"累计收益",@"活跃度"];
    for (int i = 0; i < count; i++) {
        UIButton *accountV = [UIButton buttonWithType:UIButtonTypeCustom];
        [accountView addSubview:accountV];
        [accountV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(toolW));
            make.height.mas_equalTo(@(accountH));
            make.centerY.equalTo(accountView.mas_centerY);
            make.centerX.equalTo(accountView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)count + 0));
        }];
        accountV.tag = 100 + i;
        [accountV addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *accountLabel = [UILabel new];
        [accountV addSubview:accountLabel];
        accountLabel.font = [UIFont systemFontOfSize:14.];
        accountLabel.textColor = [UIColor buttonTitleColor];
        accountLabel.text = accountArr[i];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountV).offset(5);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        UILabel *accountValueLabel = [UILabel new];
        [accountV addSubview:accountValueLabel];
        accountValueLabel.font = [UIFont boldSystemFontOfSize:18.];
        accountValueLabel.textColor = [UIColor buttonTitleColor];
        [accountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(accountLabel.mas_bottom).offset(5);
            make.centerX.equalTo(accountV.mas_centerX);
        }];
        accountValueLabel.tag = 200 + i;
        
    }
    self.balanceLabel = (UILabel *)[self viewWithTag:200];
    self.accumulatedEarningsLabel = (UILabel *)[self viewWithTag:201];
    self.activenessLabel = (UILabel *)[self viewWithTag:202];

    
    [remainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(lineView);
        make.right.bottom.equalTo(selfInfoView);
    }];
    
    [self.remainingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(remainView.mas_centerY);
        make.left.equalTo(remainView);
    }];
    [self.renewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.remainingTimeLabel.mas_right).offset(10);
        make.centerY.equalTo(remainView.mas_centerY).offset(2);
    }];

    [self.foldLineScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topView.mas_bottom);
        make.height.mas_equalTo(@150);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.foldLineScrollView.mas_bottom);
        make.height.mas_equalTo(@60);
    }];
    
    NSArray *earningsArr = @[@"访客",@"订单",@"收益"];
    NSInteger earningCount = 3;
    for (int i = 0 ; i < earningCount; i++) {
        UIButton *earningsV = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.toolView addSubview:earningsV];
        [earningsV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(toolW));
            make.height.mas_equalTo(@60);
            make.centerY.equalTo(weakSelf.toolView.mas_centerY);
            make.centerX.equalTo(weakSelf.toolView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)earningCount + 0));
        }];
        earningsV.tag = 103 + i;
        [earningsV addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *earningsLabel = [UILabel new];
        [earningsV addSubview:earningsLabel];
        earningsLabel.font = [UIFont systemFontOfSize:14.];
        earningsLabel.textColor = [UIColor buttonTitleColor];
        earningsLabel.text = earningsArr[i];
        [earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(earningsV).offset(10);
            make.centerX.equalTo(earningsV.mas_centerX);
        }];
        UILabel *earningsValueLabel = [UILabel new];
        [earningsV addSubview:earningsValueLabel];
        earningsValueLabel.font = [UIFont boldSystemFontOfSize:18.];
        earningsValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
        [earningsValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(earningsLabel.mas_bottom).offset(5);
            make.centerX.equalTo(earningsV.mas_centerX);
        }];
        earningsValueLabel.tag = 210 + i;
    }
    self.todayEarningsLabel = (UILabel *)[self viewWithTag:210];
    self.futureEarningsLabe = (UILabel *)[self viewWithTag:211];
    self.rankingLabel = (UILabel *)[self viewWithTag:212];
    
    
    
}
- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeMaMaCenterHeaderView:Index:)]) {
        [_delegate composeMaMaCenterHeaderView:self Index:button.tag];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x/SCREENWIDTH;
    
    scrollViewContentOffset = scrollView.contentOffset;
    NSInteger count = allDingdan.count;
    
    NSInteger days = (count - page - 1)*7;
    self.visitorDate = [NSNumber numberWithInteger:days];
    
    NSLog(@"days = %ld", (long)days);
    
    NSDictionary *dic = self.mamaOrderArray[days];
    // NSLog(@"dic = %@", dic);
    
    self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
    self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
    self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
    
    //改变竖线的位置。。。。
    [self createChart:allDingdan];
   
}


/**
 *  if (_delegate && [_delegate respondsToSelector:@selector(composeMaMaCenterFooterView:Index:)]) {
 [_delegate composeMaMaCenterFooterView:self Index:button.tag];
 }
 */


- (NSMutableAttributedString *)attributeStr:(NSString *)string Index:(NSInteger)index{
    NSInteger strLength = string.length;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(0,index)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(index,strLength - index)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0] range:NSMakeRange(0, index)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0] range:NSMakeRange(index, strLength - index)];

    return str;
}
- (void)setMamaResults:(NSArray *)mamaResults {
    _mamaResults = mamaResults;
    NSArray *data = [NSArray reverse:mamaResults];
    self.mamaOrderArray = data;
    NSDictionary *dic = data[0];
    data = mamaResults;
    
    self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
    self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
    self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
    
    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    int xingqiji = (int)[self.weekDay integerValue];
    switch (xingqiji) {
        case 1:
            quxiaodays = 0;
            break;
        case 2:
            quxiaodays = 6;
            break;
        case 3:
            quxiaodays = 5;
            break;
        case 4:
            quxiaodays = 4;
            break;
        case 5:
            quxiaodays = 3;
            break;
        case 6:
            quxiaodays = 2;
            break;
        case 7:
            quxiaodays = 1;
            break;
            
        default:
            break;
    }
    for (int i = quxiaodays; i < data.count + quxiaodays; i++) {
        if (i>data.count - 1) {
            [weekArray addObject:@0.01];
        } else {
            float number = [[data[i] objectForKey:@"carry"] floatValue] + 0.01;
            NSNumber *order_num = [NSNumber numberWithFloat:number];
            [weekArray addObject:order_num];
        }
        if ((i + 1 - quxiaodays)% 7 == 0) {
            float sum = [self sumofoneWeek:weekArray];
            if (sum == 0) {
                break;
            }
            [allDingdan addObject:[weekArray copy]];
            [weekArray removeAllObjects];
        }
    }
    if (allDingdan.count > 0) {
        self.mamaImage.hidden = YES;
    }
    scrollViewContentOffset = CGPointMake(SCREENWIDTH * allDingdan.count - SCREENWIDTH, 0);
    [self createChart:allDingdan];
}
// 返回一周的订单数。。。。
- (float)sumofoneWeek:(NSArray *)weekArray{
    float sum = 0.0;
    for (int i = 0; i < weekArray.count; i++) {
        sum += [weekArray[i] floatValue];
    }
    return sum;
}
- (void)createChart:(NSMutableArray *)chartData {
    NSInteger count = [chartData count];
    self.foldLineScrollView.contentSize = CGSizeMake(SCREENWIDTH * count, 120);
    self.foldLineScrollView.bounces = NO;
    self.foldLineScrollView.showsHorizontalScrollIndicator = NO;
    self.foldLineScrollView.delegate = self;
    self.foldLineScrollView.contentOffset = scrollViewContentOffset;
    self.foldLineScrollView.pagingEnabled = YES;
    
    NSArray *array = self.foldLineScrollView.subviews;
    for (UIView *view in array) {
        [view removeFromSuperview];
    }
    if (allDingdan.count == 0) {
        self.foldLineScrollView.scrollEnabled = NO;
        return;
    } else {
        self.foldLineScrollView.scrollEnabled = YES;
    }
    for (int i = 0; i < allDingdan.count; i++) {
        UIView *shartView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * i + 20, 30, SCREENWIDTH - 40, 150)];
        shartView.tag = 1001 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [shartView addGestureRecognizer:tap];
        
        NSMutableArray *mutabledingdan = [allDingdan[i] mutableCopy];
        
        FSLineChart *linechart = [self chart2:mutabledingdan];
        [shartView addSubview:linechart];
        
        UIView * circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        circleView.backgroundColor = [UIColor orangeThemeColor];
        circleView.layer.cornerRadius = 3;
        circleView.tag = 300;
        [shartView addSubview:circleView];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 80)];
        lineView.backgroundColor = [UIColor orangeThemeColor];
        lineView.tag = 400;
        [shartView addSubview:lineView];
        if (i == 0) {
            CGPoint point = [linechart getPointForIndex:6];
            circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
            lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
            
        } else {
            CGPoint point = [linechart getPointForIndex:(6 - quxiaodays)];
            circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
            lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
            if (6 - quxiaodays + 1 < 7) {
                point = [linechart getPointForIndex:(6 - quxiaodays + 1)];
                NSLog(@"%@", NSStringFromCGPoint(point));
                
                UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y - 1, SCREENWIDTH - point.x, 2)];
                whiteLine.backgroundColor = [UIColor whiteColor];
                [shartView addSubview:whiteLine];
            }
        }
        [self.foldLineScrollView addSubview:shartView];
        self.orongeCircleView = [[UIView alloc] init];
        self.orongeCircleView.layer.cornerRadius = 10;
        self.orongeCircleView.backgroundColor = [UIColor orangeThemeColor];
        [self.foldLineScrollView addSubview:self.orongeCircleView];
        
        self.anotherOrongeView = [[UIView alloc] init];
        self.anotherOrongeView.layer.cornerRadius = 10;
        self.anotherOrongeView.backgroundColor = [UIColor orangeThemeColor];
        [self.foldLineScrollView addSubview:self.anotherOrongeView];
        
        
        for (int j = 0; j < 7; j++) {
            CGPoint point2 = [linechart getPointForIndex:j];
            
            NSLog(@"%@", NSStringFromCGPoint(point2));
            UIColor *lineColor = [UIColor orangeColor];
            if (i == 1) {
                if ([self.weekDay integerValue] != 1 && [self.weekDay integerValue] < j+2  ) {
                    lineColor = [UIColor buttonDisabledBorderColor];
                }
            }
            DotLineView *line = [[DotLineView alloc] initWithFrame:CGRectMake(point2.x, 0 , 1, point2.y) andColor:lineColor];
            line.backgroundColor = [UIColor clearColor];
            
            [shartView addSubview:line];
        }
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, 148, SCREENWIDTH - 40, 0.5)];
    bottomLine.backgroundColor = [UIColor lineGrayColor];
    [self.foldLineScrollView addSubview:bottomLine];
    
    bottomLine = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH + 20, 148, SCREENWIDTH - 40, 0.5)];
    bottomLine.backgroundColor = [UIColor lineGrayColor];
    [self.foldLineScrollView addSubview:bottomLine];
    
    //本周日期
    NSArray *text = @[@"一", @"二", @"三", @"四",@"五",@"六",@"日"];
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(SCREENWIDTH + i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
        label.text = text[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeThemeColor];
        label.tag = 8000+ i;
        label.userInteractionEnabled = NO;
        [self.foldLineScrollView addSubview:label];
        [self.labelArray addObject:label];
    }
    //下周日期
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    
    NSLog(@"now = %@", now);
    comps = [calendar components:unitFlags fromDate:now];
    NSLog(@"comps = %@", comps);
    now = [calendar dateFromComponents:comps];
    
    NSLog(@"now = %@", now);
    self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
    
    //self.weekDay
    NSLog(@"%@", self.weekDay);
    int today = (int)[self.weekDay integerValue];
    int lastday = 0;
    switch (today) {
        case 1:
            lastday = 7;
            break;
        case 2:
            lastday = 1;
            break;
        case 3:
            lastday = 2;
            break;
        case 4:
            lastday = 3;
            break;
        case 5:
            lastday = 4;
            break;
        case 6:
            lastday = 5;
            break;
        case 7:
            lastday = 6;
            break;
            
        default:
            break;
    }
    lastday += 7;
    NSLog(@"lastDay = %d", lastday);
    
    int tag = (today + 6)%7;
    if (tag == 0) {
        tag = 7;
    }
    UILabel *label = [self.foldLineScrollView viewWithTag:8000 + tag - 1];
    // label.textColor = [UIColor redColor];
    [UIView animateWithDuration:0 animations:^{
        self.orongeCircleView.frame = label.frame;
    } completion:^(BOOL finished) {
        label.textColor = [UIColor whiteColor];
    }];
    
    [self.lastweeknames removeAllObjects];
    for (int i = 0; i < 7; i++) {
        NSTimeInterval timeInterval = -(lastday - i - 1) * 24 * 60 * 60;
        NSDate *lastDate = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
        
        comps = [calendar components:unitFlags fromDate:lastDate];
        
        NSLog(@"lastDate = %@", comps);
        
        NSString *string = [NSString stringWithFormat:@"%ld/%ld", (long)[comps month], (long)[comps day]];
        [self.lastweeknames addObject:string];
    }
    
    NSLog(@"%@", self.lastweeknames);
    for (int i = 0; i < 7; i++) {
        UILabel *label = [[UILabel alloc]  initWithFrame:CGRectMake(i * (SCREENWIDTH - 50)/6 + 5, 8, 40, 20)];
        label.text = self.lastweeknames[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeThemeColor];
        label.tag = 80+ i;
        label.userInteractionEnabled = NO;
        [self.foldLineScrollView addSubview:label];
        [self.anotherLabelArray addObject:label];
        if (i == 6) {
            label.textColor = [UIColor whiteColor];
            self.anotherOrongeView.frame = label.frame;
        }
    }
    [self createButtons];
}
- (void)createButtons{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(SCREENWIDTH - 20, 60, 20, 30);
    [btn1 addTarget:self action:@selector(btn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.foldLineScrollView addSubview:btn1];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"zhexianyou.png"] forState:UIControlStateNormal];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(SCREENWIDTH, 60, 20, 30);
    [btn2 addTarget:self action:@selector(btn2Clicked) forControlEvents:UIControlEventTouchUpInside];
    [self.foldLineScrollView addSubview:btn2];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.frame = CGRectMake(0, 60, 20, 30);
    [self.foldLineScrollView addSubview:btn4];
    [btn4 setBackgroundImage:[UIImage imageNamed:@"zhexianzuo.png"] forState:UIControlStateNormal];
    
}
- (void)btn2Clicked{
    NSLog(@"quxiazhou");
    
    [UIView animateWithDuration:0.3 animations:^{
        self.foldLineScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)btn1Clicked{
    NSLog(@"qubenzhou");
    [UIView animateWithDuration:0.3 animations:^{
        self.foldLineScrollView.contentOffset = CGPointMake(SCREENWIDTH, 0);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark 点击表格 更新数据
- (void)tapClicked:(UITapGestureRecognizer *)recognizer {
    UIView *weekView = [recognizer view];
    weekView.backgroundColor = [UIColor redColor];
    NSInteger week = weekView.tag - 1000;
    if (week == 2) {
        week =1;
    } else if (week == 1){
        week = 2;
    }
    NSLog(@"第 %ld 周订单数据", week);
    // NSLog(@"weekView subView = %@", [weekView subviews]);
    CGPoint location = [recognizer locationInView:recognizer.view];
    //  NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
    // NSLog(@"width = %f", width);
    CGFloat unitwidth = (SCREENWIDTH - 50)/6;
    //  NSLog(@"unit = %.0f", unitwidth);
    int index = (int)((width + unitwidth/2 - 5 ) /unitwidth);
    
    NSLog(@"index = %d", index);
    NSInteger days = (6 - index) + (week - 1)*7;
    if (days - quxiaodays < 0) {
        return;
    }
    FSLineChart *linechart = [weekView subviews][0];
    UIView *circleView = [weekView viewWithTag:300];
    UIView *lineView = [weekView viewWithTag:400];
    
    CGPoint point = [linechart getPointForIndex:index];
    // NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    circleView.frame = CGRectMake(point.x - 3, point.y - 3, 6, 6);
    lineView.frame = CGRectMake(point.x - 1, point.y, 2, 115- point.y);
    
    self.visitorDate = [NSNumber numberWithInteger:days - quxiaodays];
    NSLog(@"days = %ld", days - quxiaodays);
    // NSLog(@"array = %@", self.mamaOrderArray);
    // NSLog(@"%ld", quxiaodays);
    NSDictionary *dic = self.mamaOrderArray[days - quxiaodays];
    
    self.todayEarningsLabel.text = [dic[@"visitor_num"] stringValue];                         // 访客
    self.futureEarningsLabe.text = [dic[@"order_num"] stringValue];                           // 订单
    self.rankingLabel.text = [NSString stringWithFormat:@"%.2f", [dic[@"carry"] floatValue]]; // 收益
    
    if (week == 1) {
        
        __block UILabel *label = (UILabel *)self.labelArray[index];
        CGRect rect = label.frame;
        
        label = [self.foldLineScrollView viewWithTag:(8000 + index)];
        NSLog(@"label = %@", label);
        
        for (int i = 0; i < 7; i++) {
            UILabel *theLabel = [self.foldLineScrollView viewWithTag:(8000 + i)];
            theLabel.textColor = [UIColor orangeThemeColor];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.orongeCircleView.frame = rect;
        } completion:^(BOOL finished) {
            label.textColor = [UIColor whiteColor];
        }];
    } else if(week == 2) {
        NSLog(@"index = %ld", (long)index);
        
        __block UILabel *label = (UILabel *)self.anotherLabelArray[index];
        CGRect rect = label.frame;
        
        label = [self.foldLineScrollView viewWithTag:(80 + index)];
        NSLog(@"label = %@", label);
        
        for (int i = 0; i < 7; i++) {
            UILabel *theLabel = [self.foldLineScrollView viewWithTag:(80 + i)];
            theLabel.textColor = [UIColor orangeThemeColor];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.anotherOrongeView.frame = rect;
        } completion:^(BOOL finished) {
            label.textColor = [UIColor whiteColor];
        }];
    }
}
#pragma mark 制作表格
-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH - 40, 120)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 6;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 1;
    self.lineChart.drawInnerGrid = NO;
    [self.lineChart setChartData:chartData];
    [self.lineChart showLineViewAfterDelay:self.lineChart.animationDuration];
    return self.lineChart;
}
#pragma mark 获得星期数
- (void)createWeekDay{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    self.weekDay = [NSNumber numberWithInteger:[comps weekday]];
}
@end




































































