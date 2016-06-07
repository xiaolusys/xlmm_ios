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

@interface JMQueryLogInfoController ()

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

//@property (nonatomic,strong) JMOrderGoodsModel *goodsModel;
@property (nonatomic,assign) BOOL islogisInfo;

@property (nonatomic,strong) NSMutableArray *infoArray;


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
//- (void)setGoodsListDic:(NSDictionary *)goodsListDic {
//    _goodsListDic = goodsListDic;
//    JMOrderGoodsModel *goodsModel = [JMOrderGoodsModel mj_objectWithKeyValues:goodsListDic];
//    self.goodsModel = goodsModel;
//    
//}
- (void)setGoodsModel:(JMOrderGoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:goodsModel];
    _count = arr.count;
}

- (void)getWuliuInfoFromServer {
    BOOL islogisInfo = ((self.packetId == nil) || ([self.packetId isEqualToString:@""])
                        || (self.companyCode == nil || ([self.companyCode isEqualToString:@""])));
    self.islogisInfo = islogisInfo;
    if(self.islogisInfo){
        //        [SVProgressHUD showErrorWithStatus:@"快递单号信息不全"];
        [self createNomalView];

        return;
    }
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
        [self createTimeListView];
//        [self.wuliuInfoChainView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"wuliu info get failed.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    if (length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)createGoodsListView {
    
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, 200, SCREENWIDTH, _count * 80)];
    menu.contentView = self.goodsListVC.view;
    self.goodsListVC.goodsModel = self.goodsModel;
    
    self.logNameLabel.text = self.logName;
    self.logNumLabel.text = @"订单创建成功";
    
}
- (void)createTimeListView {
    JMPopView *timeMenu = [JMPopView showInRect:CGRectMake(0, 200 + _count * 80, SCREENWIDTH, SCREENHEIGHT)];
    timeMenu.contentView = self.timeListVC.view;
    self.timeListVC.timeListArr = self.infoArray;
}

- (void)createNomalView {
    
    UIView *timeView = [UIView new];
    [self.view addSubview:timeView];
    timeView.backgroundColor = [UIColor lineGrayColor];
    timeView.frame = CGRectMake(0, _count * 80 + 200, SCREENWIDTH, 80);
    
    UILabel *timeLabel = [UILabel new];
    [timeView addSubview:timeLabel];
    self.logTime = [self spaceFormatTimeString:self.logTime];
    timeLabel.text = self.logTime;
    timeLabel.textColor = [UIColor buttonDisabledBorderColor];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView).offset(10);
        make.left.equalTo(timeView).offset(40);
    }];
    
    UILabel *titleLabel = [UILabel new];
    [timeView addSubview:titleLabel];
    titleLabel.text = self.titleStr;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel).offset(20);
        make.left.equalTo(timeView).offset(40);
    }];
    
    //confirm -- 创建成功显示图片
    UIImageView *successImage = [UIImageView new];
    [timeView addSubview:successImage];
    successImage.image = [UIImage imageNamed:@"confirm"];
    
    [successImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(timeView).offset(10);
        make.width.height.mas_equalTo(@20);
    }];
    
    UILabel *lineL = [UILabel new];
    [timeView addSubview:lineL];
    lineL.backgroundColor = [UIColor orangeColor];
    
    [lineL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView);
        make.left.equalTo(timeView).offset(20);
        make.width.mas_equalTo(@1);
        make.height.mas_equalTo(@80);
    }];
    
}
-(NSString*) spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}

- (void)createtopUI {
    kWeakSelf
    UIView *topBackView = [UIView new];
    [self.view addSubview:topBackView];
    
    UILabel *logNameL = [UILabel new];
    [topBackView addSubview:logNameL];
    logNameL.text = @"物流配送";
    
    UILabel *lineView = [UILabel new];
    [topBackView addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *lineViews = [UILabel new];
    [topBackView addSubview:lineViews];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *logNumL = [UILabel new];
    [topBackView addSubview:logNumL];
    logNumL.text = @"快递单号";
    
    UILabel *logNameLabel = [UILabel new];
    [topBackView addSubview:logNameLabel];
    self.logNameLabel = logNameLabel;
    
    UILabel *logNumLabel = [UILabel new];
    [topBackView addSubview:logNumLabel];
    self.logNumLabel = logNumLabel;
    self.logNumLabel.textColor = [UIColor orangeColor];
    
    [topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(64);
        make.left.equalTo(weakSelf.view);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@121);
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
        make.right.equalTo(weakSelf.view).offset(-10);
        make.centerY.equalTo(logNameL.mas_centerY);
    }];
    
    [self.logNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.centerY.equalTo(logNumL.mas_centerY);
    }];
    
    [lineViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logNumL.mas_bottom).offset(20);
        make.left.right.equalTo(topBackView);
        make.height.mas_equalTo(@1);
    }];
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
    [JMPopView hide];
}

@end


































