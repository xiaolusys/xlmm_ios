//
//  JMMaMaEarningsRankController.m
//  XLMM
//
//  Created by zhang on 16/7/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMMaMaEarningsRankController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "JMEarningsRankModel.h"
#import "JMEarningsRankCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "JMMaMaTeamModel.h"

@interface JMMaMaEarningsRankController ()

<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIImageView *mamaIconImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UILabel *earningsLabel;

@property (nonatomic, strong) UILabel *teamEarningsRankLabel;

@end

@implementation JMMaMaEarningsRankController {
    NSDictionary *_selfInfoDic;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isTeamEarningsRank) {
        [self createNavigationBarWithTitle:@"团队妈妈收益排名" selecotr:@selector(backClick:)];
    }else {
        [self createNavigationBarWithTitle:@"收益信息排名" selecotr:@selector(backClick:)];
    }
    [self createTableView];
    [self createHeaderView];
    [self loadDataSource];
    [self loadSelfInfoDataSource];
    
}
- (void)loadDataSource {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.rankInfoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}
- (void)fetchData:(NSArray *)teamArr {
    if (self.isTeamEarningsRank == YES) {
        for (NSDictionary *dic in teamArr) {
            JMMaMaTeamModel *earningModel = [JMMaMaTeamModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:earningModel];
        }
    }else {
        for (NSDictionary *dic in teamArr) {
            JMEarningsRankModel *earningModel = [JMEarningsRankModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:earningModel];
        }
    }
    [self.tableView reloadData];
}
- (void)loadSelfInfoDataSource {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.selfInfoUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchSelfInfoData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)fetchSelfInfoData:(NSDictionary *)selfInfoDic {
    _selfInfoDic = selfInfoDic;
    self.nameLabel.text = selfInfoDic[@"mama_nick"];
    [self.mamaIconImage sd_setImageWithURL:[NSURL URLWithString:[selfInfoDic[@"thumbnail"] JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"profiles"]];
    if ([selfInfoDic[@"rank"] integerValue] == 0) {
    }else {
        self.rankLabel.text = [NSString stringWithFormat:@"第%@名",selfInfoDic[@"rank"]];
    }
    
    if (self.isTeamEarningsRank == YES) {
        self.earningsLabel.text = [NSString stringWithFormat:@"总收益额%@元",selfInfoDic[@"duration_total"]];
        NSInteger rankChange = [selfInfoDic[@"rank"] integerValue];
        NSInteger rankAdd = labs(rankChange);
        self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"团队妈妈第%ld名",rankAdd];

    }else {
        self.earningsLabel.text = [NSString stringWithFormat:@"收益%@元",selfInfoDic[@"total"]];
        NSInteger rankChange = [selfInfoDic[@"rank_add"] integerValue];
        NSInteger rankAdd = labs(rankChange);
        if (rankChange > 0) {
            self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"比上周上升%ld名",rankAdd];
        }else {
            self.teamEarningsRankLabel.text = [NSString stringWithFormat:@"比上周下降%ld名",rankAdd];
        }
    }

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"mamaTeamCell";
    JMEarningsRankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMEarningsRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.isTeamEarningsRank == YES) {
        JMMaMaTeamModel *model = self.dataSource[indexPath.row];
        [cell configTeamModel:model Index:indexPath.row];
    }else {
        JMEarningsRankModel *model = self.dataSource[indexPath.row];
        [cell config:model Index:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor countLabelColor];
    [sectionView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(sectionView);
        make.height.mas_equalTo(@1);
    }];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mamaGoldCup"]];
    UILabel *label = [UILabel new];
    if (self.isTeamEarningsRank == YES) {
        label.text = @"团队收益排行榜TOP10";
    }else {
        label.text = @"个人收益排行榜TOP10";
    }
    
    [sectionView addSubview:image];
    [sectionView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sectionView.mas_centerX);
        make.centerY.equalTo(sectionView.mas_centerY);
    }];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.right.equalTo(label.mas_left).offset(-10);
    }];
    
    return sectionView;
}
- (void)createHeaderView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    self.tableView.tableHeaderView = topView;
    topView.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    UIImageView *mamaIconBackImage = [UIImageView new]; //wodejingxuantouxiangicon -- > 妈妈头像底层图片
    [topView addSubview:mamaIconBackImage];
    mamaIconBackImage.image = [UIImage imageNamed:@"wodejingxuantouxiangicon"];
    
    UIImageView *mamaIconImage = [UIImageView new];
    [mamaIconBackImage addSubview:mamaIconImage];
    self.mamaIconImage = mamaIconImage;
    self.mamaIconImage.layer.masksToBounds = YES;
    self.mamaIconImage.layer.cornerRadius = 25.;
    self.mamaIconImage.layer.borderWidth = 1.;
    self.mamaIconImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.nameLabel = [UILabel new];
    [topView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:12.];
    self.nameLabel.textColor = [UIColor buttonTitleColor];
    
    self.rankLabel = [UILabel new];
    [topView addSubview:self.rankLabel];
    self.rankLabel.font = [UIFont systemFontOfSize:24.];
    self.rankLabel.textColor = [UIColor whiteColor];
    
    
    self.earningsLabel = [UILabel new];
    [topView addSubview:self.earningsLabel];
    self.earningsLabel.textColor = [UIColor buttonTitleColor];
    self.earningsLabel.font = [UIFont systemFontOfSize:14.];
    
    self.teamEarningsRankLabel = [UILabel new];
    [topView addSubview:self.teamEarningsRankLabel];
    self.teamEarningsRankLabel.textColor = [UIColor buttonTitleColor];
    self.teamEarningsRankLabel.font = [UIFont systemFontOfSize:14.];
    
    kWeakSelf
    
    
    [mamaIconBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(30);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.height.mas_equalTo(@60);
    }];
    
    [self.mamaIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
        make.centerY.equalTo(mamaIconBackImage.mas_centerY);
        make.width.height.mas_equalTo(@50);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mamaIconBackImage.mas_bottom).offset(5);
        make.centerX.equalTo(mamaIconBackImage.mas_centerX);
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(30);
        make.top.equalTo(mamaIconBackImage).offset(5);
    }];
    
    [self.earningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mamaIconBackImage.mas_right).offset(15);
        make.bottom.equalTo(mamaIconBackImage);
    }];
    
    [self.teamEarningsRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.earningsLabel.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.earningsLabel.mas_centerY);
    }];
    
    
    
}

- (void)backClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

@end


































































































































