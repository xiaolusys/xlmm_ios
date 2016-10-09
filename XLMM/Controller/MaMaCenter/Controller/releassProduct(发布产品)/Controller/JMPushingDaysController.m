//
//  JMPushingDaysController.m
//  XLMM
//
//  Created by zhang on 16/10/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDaysController.h"
#import "MMClass.h"
#import "JMPushingDaysCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JMPushingDaysModel.h"
#import "PhotoView.h"
#import "SharePicModel.h"

@interface JMPushingDaysController ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) PhotoView *photoView;


@end

static NSString *JMPushingDaysCellIdentifier = @"JMPushingDaysCellIdentifier";

@implementation JMPushingDaysController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"PublishNewPdtViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;

    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"PublishNewPdtViewController"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClickAction)];
    _qrCodeRequestDataIndex = 0;
    [self createTableView];
    if ([NSString isStringEmpty:self.qrCodeUrlString]) {
        [self loaderweimaData];
    }else {
        [self loadPicData];
    }
    
}
- (void)loadPicData {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v1/pmt/ninepic");
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSArray *arrPic = responseObject;
        [self requestData:arrPic];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取信息失败"];
    } Progress:^(float progress) {
        
    }];
}
- (void)loaderweimaData {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/qrcode/get_wxpub_qrcode");
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        [self fetchErweimaData:responseObject];
        [self loadPicData];
    } WithFail:^(NSError *error) {
        _qrCodeRequestDataIndex ++;
        if (_qrCodeRequestDataIndex <= 3) {
            [self performSelector:@selector(loaderweimaData) withObject:nil afterDelay:0.5];
        }else {
            [self loadPicData];
        }
    } Progress:^(float progress) {
        
    }];
    
}
- (void)fetchErweimaData:(NSDictionary *)dict {
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 0) {
        self.qrCodeUrlString = dict[@"qrcode_link"];
    }else {
        [MBProgressHUD showWarning:dict[@"info"]];
    }
    
}
- (void)requestData:(NSArray *)data {
    if (data.count == 0) {
        [self emptyView];
    }
    //    qrCodeUrlString = @"http://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQH_7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL01rTXVsUHJsT09aQklkd1R1MjFfAAIEeybmVwMEAI0nAA==";
    for (NSMutableDictionary *oneTurns in data) {
        NSMutableArray *muArray = [NSMutableArray arrayWithArray:oneTurns[@"pic_arry"]];
        NSInteger countNum = muArray.count;
        if (![NSString isStringEmpty:self.qrCodeUrlString]) {
            if (countNum < 9) {
                [muArray addObject:self.qrCodeUrlString];
            }else {
                [muArray replaceObjectAtIndex:4 withObject:self.qrCodeUrlString];
            }
        }
        SharePicModel *sharePic = [SharePicModel mj_objectWithKeyValues:oneTurns];
        sharePic.pic_arry = muArray;
        [self.dataSource addObject:sharePic];
    }
    
    
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view];
    
    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
//    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.dataSource = self;
    [self.tableView registerClass:[JMPushingDaysCell class] forCellReuseIdentifier:JMPushingDaysCellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.fd_debugLogEnabled = YES;
    [self.view addSubview:self.tableView];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMPushingDaysCell *cell = [tableView dequeueReusableCellWithIdentifier:JMPushingDaysCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)configureCell:(JMPushingDaysCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//    [cell sizeThatFits:CGSizeMake(SCREENWIDTH, 0)];
    cell.model = self.dataSource[indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:JMPushingDaysCellIdentifier cacheByIndexPath:indexPath configuration:^(JMPushingDaysCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)emptyView {
    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 90, SCREENHEIGHT * 0.5 - 90, 180, 180)];
    [self.view addSubview:timeView];
    
    UIImageView *timeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    timeImageV.image = [UIImage imageNamed:@"shizhong.png"];
    [timeView addSubview:timeImageV];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 120, 120)];
    title.text = @"休假中...";
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor lightGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    [timeView addSubview:title];
    
}







@end

















































































/*
 //    NSDictionary *dic = @{
 //                          @"title": @"有道词典——每日一句",
 //                          @"content": @"人纵有万般能耐，终也敌不过天命。去到你能看到的最远之处吧！到了那里，你便能看到更远。不要说机会从未出现；它曾经来过，只是你舍不得放下已拥有的.不必遗憾。若是美好，叫做精彩。若是糟糕，叫做经历。不见得每天都是好日子，但是每天总会有些好事发生的。不要放弃你的幻想。",
 //                          @"username": @"我就叫海贼王怎么了",
 //                          @"time": @"2016 - 10 - 9",
 //                          @"imageName": @"xxx",
 //                          @"imageArr" : @[@"http://img.xiaolumeimei.com/nine_pic1475892448055",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448210",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448251",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448299",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448358",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448411",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448462",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448542",
 //                                          @"http://img.xiaolumeimei.com/nine_pic1475892448592"
 //                                          ]
 //                          };
 //    for (int i = 0 ; i < 10 ; i++) {
 //        JMPushingDaysModel *model = [JMPushingDaysModel mj_objectWithKeyValues:dic];
 //        [self.dataSource addObject:model];
 //    }
 //
 //    [self.tableView reloadData];

 */




























