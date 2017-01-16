//
//  JMReturnProgressController.m
//  XLMM
//
//  Created by zhang on 16/8/12.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMReturnProgressController.h"
#import "JMReGoodsAddView.h"
#import "JMRefundModel.h"
#import "JMTimeInfoModel.h"
#import "JMRichTextTool.h"

@interface JMReturnProgressController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) JMReGoodsAddView *reGoodsV;

@property (nonatomic, strong) NSMutableArray *dataSource;



@end

@implementation JMReturnProgressController {
    NSDictionary *_logisticsDic;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _logisticsDic = [NSDictionary dictionary];
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(backClicked:)];
    [self createTableView];
    [self loadDataSource];
 

}
- (void)loadDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/rtnwuliu/get_wuliu_by_packetid?rid=%@&packetid=%@&company_name=%@",Root_URL,self.refundModelr.refund_no,self.refundModelr.sid,self.refundModelr.company_name];
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/kdn?rid=%@&out_sid=%@&logistics_company=%@",Root_URL,self.refundModelr.refund_no,self.refundModelr.sid,self.refundModelr.company_name];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self fetchData:responseObject];
    } WithFail:^(NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"erro = %@\n%@", error.userInfo, error.description);
        [MBProgressHUD showError:@"提交退货快递信息失败，请检查网络后重试！"];
    } Progress:^(float progress) {
        
    }];
    
    
}
- (void)fetchData:(NSDictionary *)dataDic {
    NSArray *dataArr = dataDic[@"data"];
    if (dataArr.count == 0) {
        NSString *logStr;
        NSString *companyName;
        NSString *sid;
        NSInteger statusCode = [self.refundModelr.status integerValue];
        if (statusCode < REFUND_STATUS_BUYER_RETURNED_GOODS){
            logStr = @"暂无";
        }else if (statusCode < REFUND_STATUS_REFUND_SUCCESS && statusCode >= REFUND_STATUS_BUYER_RETURNED_GOODS) {
            logStr = @"运输中";
        }else {
            logStr = @"已验收";
        }
        companyName = [NSString isStringEmpty:self.refundModelr.company_name] ? @"请核对承运来源" : self.refundModelr.company_name;
        sid = [NSString isStringEmpty:self.refundModelr.sid] ? @"请核对运单编号" : self.refundModelr.sid;
        _logisticsDic = @{@"name":companyName,@"order":sid,@"status":logStr};
    }else {
        _logisticsDic = dataDic;
        
        for (NSDictionary *dic in dataArr) {
            JMTimeInfoModel *timeModel = [JMTimeInfoModel mj_objectWithKeyValues:dic];
            [self.dataSource addObject:timeModel];
        }
    }
    [self.tableView reloadData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 90.;
    self.tableView.backgroundColor = [UIColor countLabelColor];
    
    JMReGoodsAddView *reGoodsV = [JMReGoodsAddView new];
    self.reGoodsV =reGoodsV;
    self.reGoodsV.frame = CGRectMake(0, 0, SCREENWIDTH, 420);
    NSString *nameStr = self.refundModelr.buyer_nick;
    NSString *phoneStr = self.refundModelr.mobile;
    NSString *addStr = self.refundModelr.return_address;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:nameStr forKey:@"buyer_nick"];
    [dict setValue:phoneStr forKey:@"mobile"];
    [dict setValue:addStr forKey:@"return_address"];
    self.reGoodsV.reGoodsDic = dict;
    self.tableView.tableHeaderView = self.reGoodsV;
    self.reGoodsV.backgroundColor = [UIColor countLabelColor];
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 110)];
    UIView *currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, SCREENWIDTH, 20)];
    [maskView addSubview:currentView];
    currentView.backgroundColor = [UIColor lineGrayColor];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    [maskView addSubview:baseView];
    baseView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [UIImageView new];
    [baseView addSubview:iconImage];
    if ([self.refundModelr.pic_path isKindOfClass:[NSString class]] ) {
        [iconImage sd_setImageWithURL:[NSURL URLWithString:[self.refundModelr.pic_path JMUrlEncodedString]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        iconImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    iconImage.layer.masksToBounds = YES;
    iconImage.layer.cornerRadius = 5;
    iconImage.layer.borderWidth = 0.5;
    iconImage.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    iconImage.layer.cornerRadius = 5;
    
    UILabel *nameLabel = [UILabel new];
    [baseView addSubview:nameLabel];
    nameLabel.font = [UIFont systemFontOfSize:14.];
    nameLabel.textColor = [UIColor dingfanxiangqingColor];
    
    UILabel *statusLabel = [UILabel new];
    [baseView addSubview:statusLabel];
    statusLabel.font = [UIFont systemFontOfSize:14.];
    statusLabel.textColor = [UIColor buttonTitleColor];
    
    UILabel *numLabe = [UILabel new];
    [baseView addSubview:numLabe];
    numLabe.font = [UIFont systemFontOfSize:14.];
    numLabe.textColor = [UIColor dingfanxiangqingColor];
    
    NSString *nameStr = @"";
    NSString *logStr = @"";
    NSString *numStr = @"";
//    if (_logisticsDic.count == 0) {
//        NSInteger statusCode = [self.refundModelr.status integerValue];
//        if (statusCode < REFUND_STATUS_BUYER_RETURNED_GOODS){
//            logStr = @"暂无";
//        }else if (statusCode < REFUND_STATUS_REFUND_SUCCESS && statusCode >= REFUND_STATUS_BUYER_RETURNED_GOODS) {
//            logStr = @"运输中";
//        }else {
//            logStr = @"已验收";
//        }
//        nameStr = self.refundModelr.company_name;
//        numStr = self.refundModelr.sid;
//    }else {
    nameStr = _logisticsDic[@"name"];
    logStr = _logisticsDic[@"status"];
    numStr = _logisticsDic[@"order"];
//    }
    nameStr = IF_NULL_TO_STRING(nameStr);
    nameLabel.text = [NSString stringWithFormat:@"承运来源: %@",nameStr];
    
    logStr = IF_NULL_TO_STRING(logStr);
    NSString *string = [NSString stringWithFormat:@"物流状态: %@",logStr];
    statusLabel.attributedText = [JMRichTextTool cs_changeColorWithColor:[UIColor buttonEnabledBackgroundColor] AllString:string SubStringArray:@[logStr]];
    
    numStr = IF_NULL_TO_STRING(numStr);
    numLabe.text = [NSString stringWithFormat:@"运单编号: %@",numStr];
    
    
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseView).offset(10);
        make.width.height.mas_equalTo(@70);
        make.centerY.equalTo(baseView.mas_centerY);
    }];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baseView).offset(10);
        make.left.equalTo(iconImage.mas_right).offset(10);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusLabel);
        make.top.equalTo(statusLabel.mas_bottom).offset(10);
    }];
    [numLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
    }];
    
    
    return maskView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *refundProgressIndefire = @"refundProgressIndefire";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:refundProgressIndefire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:refundProgressIndefire];
    }
    JMTimeInfoModel *timeModel = self.dataSource[indexPath.row];
    NSString *timeText = timeModel.time;
    timeText = [NSString jm_deleteTimeWithT:timeText];
    NSString *infoText = timeModel.content;
    if(0 == indexPath.row){
        [self displayLastWuliuInfoWithTime:cell time:timeText andInfo:infoText];
    }
    else{
        [self displayWuliuInfoWithOrder:cell andTime:timeText andInfo:infoText];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)displayLastWuliuInfoWithTime:(UITableViewCell *)cell time:(NSString*)timeText andInfo:(NSString*)infoText{
    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 9, 9, 9)];
    [view addSubview:circleView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 30, 260, 35)];
    [view addSubview:infoLabel];
    
    timeLabel.text = timeText;
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    infoLabel.text = infoText;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 2;
    
    UIColor *color = [UIColor orangeThemeColor];
    timeLabel.textColor = color;
    infoLabel.textColor = color;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = color;
    
    lineView.backgroundColor = color;
    [cell addSubview:view];
}


-(void)displayWuliuInfoWithOrder:(UITableViewCell *)cell andTime:(NSString*)timeText andInfo:(NSString*)infoText{
    
    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 9, 9, 9)];
    [view addSubview:circleView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 30, 260, 35)];
    [view addSubview:infoLabel];
    
    timeLabel.text = timeText;
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    infoLabel.text = infoText;
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    infoLabel.numberOfLines = 2;
    
    UIColor *normalColor = [UIColor textDarkGrayColor];
    timeLabel.textColor = normalColor;
    infoLabel.textColor = normalColor;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = normalColor;
    
    lineView.backgroundColor = normalColor;
    
    [cell addSubview:view];
    
    
}


- (void)backClicked:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMReturnProgressController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMReturnProgressController"];
}





@end






































































