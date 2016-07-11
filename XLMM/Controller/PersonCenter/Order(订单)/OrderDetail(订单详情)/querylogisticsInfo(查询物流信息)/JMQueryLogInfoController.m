//
//  JMQueryLogInfoController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMQueryLogInfoController.h"
#import "Masonry.h"
#import "MMClass.h"
#import "JMPopView.h"
#import "JMGoodsListController.h"
#import "JMLogTimeListController.h"
#import "UIViewController+NavigationBar.h"
#import "JMOrderGoodsModel.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "UIColor+RGBColor.h"
#import "JMCleanView.h"
#import "JMPackAgeModel.h"

#define cellHeitht 90

@interface JMQueryLogInfoController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *masBackScrollView;

@property (nonatomic,strong) UILabel *logNameLabel;

@property (nonatomic,strong) UILabel *logNumLabel;
/**
 *  商品展示
 */
@property (nonatomic,strong) JMGoodsListController *goodsListVC;
/**
 *  物流时间展示
 */
@property (nonatomic,strong) JMLogTimeListController *timeListVC;

@property (nonatomic,assign) BOOL islogisInfo;

@property (nonatomic,strong) NSMutableArray *infoArray;

@property (nonatomic,strong) NSMutableArray *orderListDataSource;

@property (nonatomic,strong) JMPackAgeModel *packageModel;

@end

@implementation JMQueryLogInfoController{
    NSInteger _count;
    NSString *_urlStr;
}
- (NSMutableArray *)infoArray {
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}
- (JMGoodsListController *)goodsListVC {
    if (_goodsListVC == nil) {
        _goodsListVC = [[JMGoodsListController alloc] init];
    }
    return _goodsListVC;
}
- (JMLogTimeListController *)timeListVC {
    if (_timeListVC == nil) {
        _timeListVC = [[JMLogTimeListController alloc] init];
    }
    return _timeListVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"物流状态" selecotr:@selector(backClick)];
    
    [self createtopUI];
    [self getWuliuInfoFromServer];
    [self createGoodsListView];
    
    
    
}
- (void)setOrderDataSource:(NSArray *)orderDataSource {
    _orderDataSource = orderDataSource;
    _count = orderDataSource.count;
//    self.infoArray = [NSMutableArray arrayWithArray:orderDataSource];
}
- (void)setLogisDataSource:(NSArray *)logisDataSource {
    _logisDataSource = logisDataSource;
    JMPackAgeModel *packageModel = [[JMPackAgeModel alloc] init];
    packageModel = logisDataSource[self.index];
    self.packetId = packageModel.out_sid;
    NSDictionary *logisticsDic = packageModel.logistics_company;
    self.companyCode = logisticsDic[@"id"];
    self.packageModel = packageModel;
}


- (void)getWuliuInfoFromServer {
    BOOL islogisInfo = ((self.packetId == nil) || ([self.packetId isEqualToString:@""])
                        || (self.companyCode == nil));
    self.islogisInfo = islogisInfo;
    if(self.islogisInfo){
        //        [SVProgressHUD showErrorWithStatus:@"快递单号信息不全"];
        [self createNomalView];

        return;
    }else {
        [self loadData];

    }
    
    
    
}
/**
 *  数据请求  http://m.xiaolumeimei.com/rest/v1/wuliu/get_wuliu_by_packetid?packetid=3101040539131&company_code=YUNDA_QR
 */
- (void)loadData {
    
    _urlStr = [NSString stringWithFormat:@"%@/rest/v1/wuliu/get_wuliu_by_packetid?packetid=%@&company_code=%@", Root_URL, self.packetId, self.companyCode];
    NSLog(@"%@", _urlStr);
    
    [SVProgressHUD showWithStatus:@"获取物流信息"];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:_urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if(responseObject == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSDictionary *info = responseObject;
        [self fetchedWuliuData:info];
        
        //        [self.wuliuInfoChainView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"wuliu info get failed.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"查询失败,您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];
    

}
- (void)fetchedWuliuData:(NSDictionary *)responseData{
    // NSLog(@"%@",responseData);
    if (responseData == nil) {
        return;
    }
    
    
    NSDictionary *dicJson = responseData;
    NSLog(@"json = %@", dicJson);
    
    
    self.logNameLabel.text = [dicJson objectForKey:@"name"];
    self.logNumLabel.text = [dicJson objectForKey:@"order"];
    
    
    self.infoArray = [dicJson objectForKey:@"data"];
    NSInteger length = self.infoArray.count;
    
    [self createTimeListView];
    
    if (length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}
/**
 *  商品详情的展示列表  3101063787725,3101063787976,3101064389806,
 */
- (void)createGoodsListView {
    self.goodsListVC.count = _count;
    self.goodsListVC.goodsListArr = [NSMutableArray arrayWithArray:self.orderDataSource];
    
    JMCleanView *menu = [[JMCleanView alloc] initWithFrame:CGRectMake(0, 136, SCREENWIDTH, _count * cellHeitht)];
    [self.masBackScrollView addSubview:menu];
    menu.contentView = self.goodsListVC.view;
    menu.contentView.backgroundColor = [UIColor lineGrayColor];
//    self.goodsListVC.goodsModel = self.orderGoodsArr[0];
//    self.goodsListVC.goodsModel = self.goodsModel;
    self.logNameLabel.text = self.logName;
    self.logNameLabel.font = [UIFont systemFontOfSize:13.];
    if (self.packageModel.assign_status_display.length == 0) {
        self.logNumLabel.text = @"未揽件";
    }else {
        self.logNumLabel.text = self.packageModel.assign_status_display;
    }
    
    self.logNumLabel.font = [UIFont systemFontOfSize:13.];
    self.logNumLabel.textColor = [UIColor buttonEnabledBackgroundColor];
}
/**
 *  物流信息展示列表
 */
- (void)createTimeListView {

    NSInteger count = self.infoArray.count;
    self.timeListVC.count = count;
    JMCleanView *timeMenu = [[JMCleanView alloc] initWithFrame:CGRectMake(0, 136 + _count * cellHeitht, SCREENWIDTH, count * cellHeitht)];
    [self.masBackScrollView addSubview:timeMenu];
    timeMenu.contentView = self.timeListVC.view;
    timeMenu.contentView.backgroundColor = [UIColor lineGrayColor];
    self.timeListVC.timeListArr = self.infoArray;
    
    self.masBackScrollView.contentSize = CGSizeMake(SCREENWIDTH, count * cellHeitht + _count * cellHeitht + 136);
}

/**
 *  显示当没有物流信息 - > 展示的视图
 */
- (void)createNomalView {
    
    UIView *timeView = [UIView new];
    [self.masBackScrollView addSubview:timeView];
    timeView.backgroundColor = [UIColor lineGrayColor];
    timeView.frame = CGRectMake(0, _count * cellHeitht + 136, SCREENWIDTH, cellHeitht);
    
    UILabel *timeLabel = [UILabel new];
    [timeView addSubview:timeLabel];
    NSString *timeStr = [self dealVisitorTime:self.packageModel.pay_time];
    timeLabel.text = [NSString stringWithFormat:@"%@",timeStr];
    timeLabel.textColor = [UIColor titleDarkGrayColor];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView).offset(10);
        make.left.equalTo(timeView).offset(40);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [timeView addSubview:titleLabel];
    NSString *titleStr = self.packageModel.assign_status_display;
    if (titleStr != nil) {
        titleLabel.text = titleStr;
        self.logNumLabel.text = titleStr;
    }else {
        titleLabel.text = @"订单创建成功";
    }
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13.];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(15);
        make.left.equalTo(timeView).offset(40);
    }];
    
    UILabel *lineL = [UILabel new];
    [timeView addSubview:lineL];
    lineL.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView);
        make.left.equalTo(timeView).offset(20);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(cellHeitht);
    }];
    
    //confirm -- 创建成功显示图片
    UIImageView *successImage = [UIImageView new];
    [timeView addSubview:successImage];
    successImage.image = [UIImage imageNamed:@"confirm"];
    
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(timeView).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    
    
    
    UIView *timeViewTwo = [UIView new];
    [self.masBackScrollView addSubview:timeViewTwo];
    timeViewTwo.backgroundColor = [UIColor lineGrayColor];
    timeViewTwo.frame = CGRectMake(0, _count * cellHeitht + 226, SCREENWIDTH, cellHeitht);

    UILabel *timeLabelTwo = [UILabel new];
    [timeViewTwo addSubview:timeLabelTwo];
    NSString *timeStr2 = [self dealVisitorTime:self.packageModel.process_time];
    timeLabelTwo.text = [NSString stringWithFormat:@"%@",timeStr2];
    timeLabelTwo.textColor = [UIColor titleDarkGrayColor];
    [timeLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeViewTwo).offset(10);
        make.left.equalTo(timeViewTwo).offset(40);
    }];
    
    UILabel *titleLabelTwo = [UILabel new];
    [timeViewTwo addSubview:titleLabelTwo];
    titleLabelTwo.text = @"订单创建成功";
    titleLabelTwo.numberOfLines = 0;
    titleLabelTwo.font = [UIFont systemFontOfSize:13.];
    
    [titleLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabelTwo.mas_bottom).offset(15);
        make.left.equalTo(timeViewTwo).offset(40);
    }];
    
    UILabel *lineLTwo = [UILabel new];
    [timeViewTwo addSubview:lineLTwo];
    lineLTwo.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    
    [lineLTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeViewTwo);
        make.left.equalTo(timeViewTwo).offset(20);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(cellHeitht);
    }];

    UIImageView *successImageTwo = [UIImageView new];
    [timeViewTwo addSubview:successImageTwo];
    successImageTwo.image = [UIImage imageNamed:@"confirm"];
    
    [successImageTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(timeViewTwo).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    
    self.masBackScrollView.contentSize = CGSizeMake(SCREENWIDTH, _count * cellHeitht + 136 + cellHeitht * 2);
    
}
-(NSString*)spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}
- (NSString *)dealVisitorTime:(NSString *)str {
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSString *time = [arr componentsJoinedByString:@" "];
    return time;
}
/**
 *  显示顶部视图 -- > 物流公司与快递单号
 */
- (void)createtopUI {
    kWeakSelf
    
    self.masBackScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.masBackScrollView];
    
    UIView *topBackView = [UIView new];
    [self.masBackScrollView addSubview:topBackView];
    
    UILabel *logNameL = [UILabel new];
    [topBackView addSubview:logNameL];
    logNameL.text = @"物流配送";
    logNameL.font = [UIFont systemFontOfSize:13.];
    
    UILabel *lineView = [UILabel new];
    [topBackView addSubview:lineView];
    lineView.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    
    UILabel *lineViews = [UILabel new];
    [topBackView addSubview:lineViews];
    lineViews.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    
    UILabel *logNumL = [UILabel new];
    [topBackView addSubview:logNumL];
    logNumL.text = @"快递单号";
    logNumL.font = [UIFont systemFontOfSize:13.];
    
    UILabel *logNameLabel = [UILabel new];
    [topBackView addSubview:logNameLabel];
    self.logNameLabel = logNameLabel;
    self.logNameLabel.text = self.logName;
    
    UILabel *logNumLabel = [UILabel new];
    [topBackView addSubview:logNumLabel];
    self.logNumLabel = logNumLabel;
    self.logNumLabel.textColor = [UIColor buttonEnabledBackgroundColor];
    
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.masBackScrollView).offset(0);
        make.left.equalTo(weakSelf.masBackScrollView);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@136);
    }];
    
    [logNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(topBackView).offset(20);
        make.height.mas_equalTo(@20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logNameL.mas_bottom).offset(20);
        make.left.right.equalTo(topBackView);
        make.height.mas_equalTo(@1);
    }];
    
    [logNumL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(lineView).offset(20);
        make.height.mas_equalTo(@20);
    }];
    
    [self.logNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBackView).offset(-10);
        make.centerY.equalTo(logNameL.mas_centerY);
    }];
    
    [self.logNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBackView).offset(-10);
        make.centerY.equalTo(logNumL.mas_centerY);
    }];
    
    [lineViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logNumL.mas_bottom).offset(20);
        make.left.right.equalTo(topBackView);
        make.height.mas_equalTo(@16);
    }];
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"QueryLogInfo"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"QueryLogInfo"];
}

@end


































