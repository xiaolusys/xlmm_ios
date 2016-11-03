//
//  JMRewardsController.m
//  XLMM
//
//  Created by zhang on 16/8/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMRewardsController.h"
#import "JMRewardsCell.h"

@interface JMRewardsController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *weekRewardValueLabel;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, strong) UILabel *segmentTitleLabel;

@property (nonatomic, strong)UIScrollView *bottomScrollView;

//存储旧的位置
@property (nonatomic, strong)NSMutableDictionary *oldDic;
@property (nonatomic, strong)NSMutableDictionary *contentOffsetYDic;

@end

static NSString *JMRewardsCellIdfier = @"JMRewardsCellIdfier";


@implementation JMRewardsController {
    NSMutableArray *_buttonArr;
    NSMutableArray *_tableArr;
    NSInteger _currentIndex;
    
    NSArray *_personArray;
    NSArray *_teamArray;
    
    NSString *_personStr;
    NSString *_teamStr;
    
    CGFloat _awardValue;
}
- (NSMutableDictionary *)oldDic {
    if (!_oldDic) {
        self.oldDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _oldDic;
}
- (NSMutableDictionary *)contentOffsetYDic {
    if (!_contentOffsetYDic) {
        self.contentOffsetYDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _contentOffsetYDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"周激励" selecotr:@selector(backClick:)];
    
    [self createHeaderView];
    [self loadDataSource];
    _currentIndex = 0;
    for (UIButton *btn in self.btnView.subviews) {
        if (btn.tag == 100) {
            [self titleBtnClickAction:btn];
        }
    }

}
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/mama/mission/weeklist",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self fetchData:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
    }];
}
- (void)fetchData:(NSDictionary *)dic {
//    _personStr = dic[@"staging_award_amount"];
//    _teamStr = dic[@"staging_award_count"];
    _awardValue = [dic[@"staging_award_amount"] floatValue] / 100.00;
    
    
    _personArray = dic[@"personal_missions"];
    _teamArray = dic[@"group_missions"];
    
    self.weekRewardValueLabel.text = [NSString stringWithFormat:@"¥ %.2f",_awardValue];
    
    UITableView *table = _tableArr[_currentIndex];
    [table reloadData];
}


- (void)createHeaderView {
    _buttonArr = [NSMutableArray array];
    _tableArr = [NSMutableArray array];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 160)];
    [self.view addSubview:self.topView];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *weekRewardsDescTitle = [UILabel new];
    [self.topView addSubview:weekRewardsDescTitle];
    weekRewardsDescTitle.font = [UIFont systemFontOfSize:14.];
    weekRewardsDescTitle.textColor = [UIColor buttonTitleColor];
    weekRewardsDescTitle.text = @"本周可获得额外销售奖励";
    
    self.weekRewardValueLabel = [UILabel new];
    [self.topView addSubview:self.weekRewardValueLabel];
    self.weekRewardValueLabel.font = [UIFont systemFontOfSize:36.];
    self.weekRewardValueLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    self.weekRewardValueLabel.text = @"¥ 0.00";
    
    kWeakSelf
    [weekRewardsDescTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView.mas_centerX);
        make.top.equalTo(weakSelf.topView).offset(30);
    }];
    [self.weekRewardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.topView.mas_centerX);
        make.top.equalTo(weekRewardsDescTitle.mas_bottom).offset(20);
    }];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 224, SCREENWIDTH, SCREENHEIGHT - 224)];
    [self.view addSubview:self.contentView];
    
    NSArray *nameArr = @[@"个人奖励", @"团队奖励"];
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    self.btnView.layer.masksToBounds = YES;
    self.btnView.layer.borderWidth = 1.;
    self.btnView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    [self.contentView addSubview:self.btnView];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * SCREENWIDTH / 2, 0, SCREENWIDTH / 2, 35);
        button.titleLabel.font =  [UIFont systemFontOfSize: 14];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor textDarkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateSelected];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(titleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnView addSubview:button];
        [_buttonArr addObject:button];
    }
    self.segmentTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, SCREENWIDTH, 30)];
    [self. btnView addSubview:self.segmentTitleLabel];
    self.segmentTitleLabel.backgroundColor = [UIColor lineGrayColor];
    self.segmentTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.segmentTitleLabel.font = [UIFont systemFontOfSize:13.];
    self.segmentTitleLabel.text = @"每周任务,多多益善.做任务还可以获得奖励哦~!";
//    NSString *limtString = @"当前距离获得奖金任务还差  20%";
    
//    NSInteger count1 = limtString.length;
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:limtString];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonTitleColor] range:NSMakeRange(0,12)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12,count1 - 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0] range:NSMakeRange(0, 12)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0] range:NSMakeRange(12, count1 - 12)];
//    self.segmentTitleLabel.attributedText = str;

    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREENWIDTH, 35)];
    [self.btnView addSubview:sectionView];
    UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [sectionView addSubview:oneLabel];
    oneLabel.textAlignment = NSTextAlignmentCenter;
    oneLabel.font = [UIFont systemFontOfSize:12.];
    oneLabel.text = @"奖励项目";
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, SCREENWIDTH - 100, 35)];
    [sectionView addSubview:rightView];
    
    NSArray *accountArr = @[@"目标数",@"完成数",@"奖金",@"状态"];
    NSInteger count = accountArr.count;
    for (int i = 0; i < count; i++) {
        UILabel *accountLabel = [UILabel new];
        [rightView addSubview:accountLabel];
        accountLabel.textAlignment = NSTextAlignmentCenter;
        accountLabel.font = [UIFont systemFontOfSize:12.];
        accountLabel.tag = 100 + i;
        accountLabel.text = accountArr[i];
        accountLabel.textColor = [UIColor buttonTitleColor];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@((SCREENWIDTH - 100) / 4));
            make.height.mas_equalTo(@(35));
            make.centerY.equalTo(rightView.mas_centerY);
            make.centerX.equalTo(rightView.mas_right).multipliedBy(((CGFloat)i + 0.5) / ((CGFloat)count + 0));
        }];
    }
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT - 100)];
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.contentSize = CGSizeMake(2 * SCREENWIDTH, SCREENHEIGHT - 100);
    [self.contentView addSubview:self.bottomScrollView];
    
    
    for (int i = 0; i < 2; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, self.bottomScrollView.frame.size.height - 100) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 60.;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //注册cell
        [tableView registerClass:[JMRewardsCell class] forCellReuseIdentifier:JMRewardsCellIdfier];
        [self.bottomScrollView addSubview:tableView];
        [_tableArr addObject:tableView];
    }

    
}


- (void)titleBtnClickAction:(UIButton *)button {
    if (button.selected) {
        return ;
    }else {
        NSInteger btnTag = button.tag - 100;
        self.bottomScrollView.contentOffset = CGPointMake(SCREENWIDTH * btnTag, 0);
        [self changeBtnSelect:btnTag];
        _currentIndex = btnTag;
        self.weekRewardValueLabel.text = [NSString stringWithFormat:@"¥ %.2f",_awardValue];
        UITableView *table = _tableArr[btnTag];
        [table reloadData];
    }
    
}

- (void)changeBtnSelect:(NSInteger)btnTag {
    for (UIButton *button in _buttonArr) {
        if ((button.tag - 100) == btnTag) {
            button.selected = YES;
            continue;
        }
        button.selected = NO;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableArr[0]) {
        return _personArray.count;
    }else {
        return _teamArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMRewardsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[JMRewardsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMRewardsCellIdfier];
    }
    if (tableView == _tableArr[0]) {
        cell.personDic = _personArray[indexPath.row];
    }else {
       cell.teamDic = _teamArray[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark --scrollView的代理方法w
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger count = scrollView.contentOffset.x / SCREENWIDTH;
        _currentIndex = count;
        self.weekRewardValueLabel.text = [NSString stringWithFormat:@"¥ %.2f",_awardValue];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView != self.bottomScrollView) {
        NSNumber *number = [NSNumber numberWithInteger:_currentIndex];
        NSNumber *contentOffY = [NSNumber numberWithInteger:scrollView.contentOffset.y];
        [self.contentOffsetYDic setObject:contentOffY forKey:number];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger offX = scrollView.contentOffset.x / SCREENWIDTH;
        [self changeBtnSelect:offX];
    }else {
        CGFloat contentOffY = [[self.contentOffsetYDic objectForKey:[NSNumber numberWithInteger:_currentIndex]] floatValue];
        if (scrollView.dragging) {
            if ((scrollView.contentOffset.y - contentOffY) > 5.0f) {
                //隐藏
                [UIView animateWithDuration:0.5 animations:^{
                    self.topView.frame = CGRectMake(0, 64, SCREENWIDTH, 160);
                    self.topView.alpha = 0.0;
                    self.contentView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 100);
                }];
            }else if((contentOffY - scrollView.contentOffset.y) > 5.0f){
                //显示
                [UIView animateWithDuration:0.5 animations:^{
                    self.topView.frame = CGRectMake(0, 64, SCREENWIDTH, 160);
                    self.topView.alpha = 1.0;
                    self.contentView.frame = CGRectMake(0, 64 + 160, SCREENWIDTH, SCREENHEIGHT - 100);
                }];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMRewardsController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMRewardsController"];
}
- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}


@end








































































