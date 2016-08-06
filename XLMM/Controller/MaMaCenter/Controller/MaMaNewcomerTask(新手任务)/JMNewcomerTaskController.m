//
//  JMNewcomerTaskController.m
//  XLMM
//
//  Created by zhang on 16/8/3.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMNewcomerTaskController.h"
#import "MMClass.h"
#import "JMNewcomerTaskModel.h"
#import "JMNewcomerTaskCell.h"

@interface JMNewcomerTaskController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *backImage;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JMNewcomerTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];

}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setNewsTaskArr:(NSArray *)newsTaskArr {
    _newsTaskArr = newsTaskArr;
    [self.dataSource removeAllObjects];
    for (NSDictionary *dic in newsTaskArr) {
        BOOL isShow = dic[@"show"];
        if (isShow) {
            JMNewcomerTaskModel *model = [JMNewcomerTaskModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:model];
        }else {}
    }
    [self.tableView reloadData];
}

- (void)createTableView {
    
    self.backImage = [UIImageView new];
    self.backImage.image = [UIImage imageNamed:@"mamaMessagePopBackImage"];
//    self.backImage.frame = CGRectMake(0, 0, SCREENWIDTH * 0.8, SCREENWIDTH * 1.2);
    [self.view addSubview:self.backImage];
    self.backImage.userInteractionEnabled = YES;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backImage addSubview:closeButton];
    [closeButton setImage:[UIImage imageNamed:@"mamaTaskPopclose"] forState:UIControlStateNormal];
    closeButton.tag = 100;
    [closeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.backImage.bounds style:UITableViewStylePlain];
    [self.backImage addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 30.;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    CGFloat backImageW = self.backImage.frame.size.width;
    kWeakSelf
    
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.view);
        make.width.mas_equalTo(@(SCREENWIDTH * 0.9));
        make.height.mas_equalTo(@(SCREENWIDTH * 1.35));
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.backImage).offset(-10);
        make.right.equalTo(weakSelf.backImage).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backImage).offset(30);
        make.top.equalTo(weakSelf.backImage).offset(SCREENWIDTH * 0.25);
        make.right.equalTo(weakSelf.backImage).offset(-30);
        make.bottom.equalTo(weakSelf.backImage).offset(-30);
    }];
    
    
    
    UIView *headerView = [UIView new];
    headerView.frame = CGRectMake(0, 0, backImageW, 100);
    
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, backImageW, 60);
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    
    UILabel *xinshourenwu = [UILabel new];
    xinshourenwu.font = [UIFont systemFontOfSize:18.];
    xinshourenwu.textColor = [UIColor buttonEnabledBackgroundColor];
    xinshourenwu.text = @"新手任务";
    [headerView addSubview:xinshourenwu];
    
    
    UILabel *descLabel = [UILabel new];
    descLabel.numberOfLines = 0;
    [headerView addSubview:descLabel];
    NSString *descString = @"根据以下步骤开启你的生意事业88%的小鹿妈妈15天后能够每天赚100元月入3000元";
    descLabel.attributedText = [self attributedString:descString];
    
    UILabel *descDownLabel = [UILabel new];
    descDownLabel.textColor = [UIColor dingfanxiangqingColor];
    descDownLabel.text = @"首单奖励5元 完成新手任务 再奖5元";
    descDownLabel.font = [UIFont systemFontOfSize:12.];
    [footerView addSubview:descDownLabel];
    
    UIButton *seeCourse = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerView addSubview:seeCourse];
    [seeCourse setImage:[UIImage imageNamed:@"mamaTaskseeCourseImage"] forState:UIControlStateNormal];
    seeCourse.tag = 101;
    [seeCourse addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [xinshourenwu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(5);
        make.centerX.equalTo(headerView.mas_centerX);
    }];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xinshourenwu.mas_bottom).offset(5);
        make.centerX.equalTo(headerView.mas_centerX);
        make.left.equalTo(headerView).offset(10);
        make.right.equalTo(headerView).offset(-10);
    }];
    
    [descDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(footerView);
        make.centerX.equalTo(footerView.mas_centerX);
    }];
    [seeCourse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(5);
        make.centerX.equalTo(footerView.mas_centerX);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
    
    
    
    
    
}

- (void)buttonClick:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(composeNewcomerTask:Index:)]) {
        [_delegate composeNewcomerTask:self Index:button.tag];
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMNewcomerTaskCell";
    JMNewcomerTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMNewcomerTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMNewcomerTaskModel *model = self.dataSource[indexPath.row];
    [cell configModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}








- (NSMutableAttributedString *)attributedString:(NSString *)descString {
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:descString];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(0,14)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(14,3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(17,5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(22,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(24,7)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(31,3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(34,3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor buttonEnabledBackgroundColor] range:NSMakeRange(37,4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor dingfanxiangqingColor] range:NSMakeRange(41,1)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(0,14)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.] range:NSMakeRange(14,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(17,5)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.] range:NSMakeRange(22,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(24,7)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.] range:NSMakeRange(31,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(34,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.] range:NSMakeRange(37,4)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.] range:NSMakeRange(41,1)];
    
    return str;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMNewcomerTask"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMNewcomerTask"];
}

@end


























































































