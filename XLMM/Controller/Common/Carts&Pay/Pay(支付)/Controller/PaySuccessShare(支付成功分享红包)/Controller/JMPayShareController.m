//
//  JMPayShareController.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayShareController.h"
#import "JMPaySucTitleView.h"
#import "JMSelecterButton.h"
#import "JMSharePackView.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMOrderListController.h"

@interface JMPayShareController ()<UITableViewDelegate,UITableViewDataSource,JMPaySucTitleViewDelegate>

/**
 *  分享数据字典
 */
@property (nonatomic, strong) NSDictionary *shareDic;

@property (nonatomic,strong) JMShareModel *share_model;

@property (nonatomic,strong) JMShareViewController *shareView;

@property (nonatomic,strong) JMPaySucTitleView *paySuccessView;

@property (nonatomic,strong) JMSharePackView *sharePackView;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation JMPayShareController {
    NSString *_orderNum;
    NSString *_limitStr;
}
- (JMShareViewController *)shareView {
    if (!_shareView) {
        _shareView = [[JMShareViewController alloc] init];
    }
    return _shareView;
}
- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self loadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShareApinPayGo) name:@"isShareApinPayGo" object:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lineGrayColor];
    [self createNavigationBarWithTitle:@"支付成功" selecotr:@selector(backClick:)];
    
    [self createTableView];
    [self topShowTitle];
    
}
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (void)topShowTitle {
    
    JMPaySucTitleView *paySuccessView = [JMPaySucTitleView enterHeaderView];
    self.paySuccessView = paySuccessView;
    self.paySuccessView.delegate = self;
    
    JMSharePackView *sharePackView = [JMSharePackView enterFooterView];
    self.sharePackView = sharePackView;
    
    
    self.tableView.tableHeaderView = self.paySuccessView;
    self.tableView.tableFooterView = self.sharePackView;
    
}

- (void)setOrdNum:(NSString *)ordNum {
    _ordNum = ordNum;
}
- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/sharecoupon/create_order_share?uniq_id=%@", Root_URL,_ordNum];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return;
        [self resolveActivityShareParam:responseObject];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)resolveActivityShareParam:(NSDictionary *)dic {
    //    NSDictionary *dic = _model.mj_keyValues;
    NSLog(@"Share para=%@",dic);
    
    self.share_model.share_type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"code"]];
    
    self.share_model.share_img = [dic objectForKey:@"post_img"]; //图片
    self.share_model.desc = [dic objectForKey:@"description"]; // 文字详情
    
    self.share_model.title = [dic objectForKey:@"title"]; //标题
    self.share_model.share_link = [dic objectForKey:@"share_link"];
    _limitStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"share_times_limit"]];
    self.sharePackView.limitStr = _limitStr;
    self.shareView.model = self.share_model;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)composeGetRedpackBtn:(JMSharePackView *)renPack didClick:(UIButton *)button {
//    [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 240) ViewController:self.shareView WithBlock:^(UIView *maskView) {
//    }];
    [self jumpToWaitReceipt];
}
- (void)backClick:(UIButton *)sender {
    [self jumpToWaitReceipt];
    
}
- (void)jumpToWaitReceipt {
    // 支付成功后,跳转到待收货页面
    JMOrderListController *orderVC = [[JMOrderListController alloc] init];
    orderVC.currentIndex = 2;
    [self.navigationController pushViewController:orderVC animated:YES];
}

@end

/**
 *  {
 code = 0;
 description = "\U5206\U4eab\U4f18\U60e0\U5238\U6d4b\U8bd5";   分享优惠券测试
 msg = "\U5206\U4eab\U6210\U529f";  分享成功
 "post_img" = "http://image.xiaolu.so/nine_pic1466477598077";
 "share_link" = "http://staging.xiaolumeimei.com/mall/order/redpacket?uniq_id=xd160622576a567d440f6&ufrom=";
 "share_times_limit" = 15;
 title = "\U5206\U4eab\U4f18\U60e0\U5238\U6d4b\U8bd5";  分享优惠券测试
 }
 */












































