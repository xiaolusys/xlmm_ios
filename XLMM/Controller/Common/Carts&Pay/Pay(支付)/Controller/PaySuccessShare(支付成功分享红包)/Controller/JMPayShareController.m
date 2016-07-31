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
#import "MMClass.h"
#import "JMSharePackView.h"
#import "JMShareView.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMPopView.h"

@interface JMPayShareController ()<UITableViewDelegate,UITableViewDataSource,JMShareViewDelegate,JMSharePackViewDelegate>

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
- (JMShareModel*)share_model {
    if (!_share_model) {
        _share_model = [[JMShareModel alloc] init];
    }
    return _share_model;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self loadData];
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
    
    JMSharePackView *sharePackView = [JMSharePackView enterFooterView];
    self.sharePackView = sharePackView;
    self.sharePackView.delegate = self;
    
    self.tableView.tableHeaderView = self.paySuccessView;
    self.tableView.tableFooterView = self.sharePackView;
    
}

- (void)setOrdNum:(NSString *)ordNum {
    _ordNum = ordNum;
}
- (void)loadData {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/sharecoupon/create_order_share?uniq_id=%@", Root_URL,_ordNum];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:string parameters:nil
         progress:^(NSProgress * _Nonnull downloadProgress) {
             //数据请求的进度
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        if (!responseObject) return;
        
        [self resolveActivityShareParam:responseObject];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    self.shareView = shareView;
    _shareDic = nil;
    self.shareView.model = self.share_model;
    JMShareView *cover = [JMShareView show];
    cover.delegate = self;
    //弹出视图
    JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
    menu.contentView = self.shareView.view;
}
- (void)coverDidClickCover:(JMShareView *)cover {
    //隐藏pop菜单
    [JMPopView hide];
    [SVProgressHUD dismiss];
}
- (void)backClick:(UIButton *)sender {
    NSInteger count = 0;
    count = [[self.navigationController viewControllers] indexOfObject:self];
    if (count >= 2) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void)isShareApinPayGo {
//    NSInteger count = 0;
//    
//    count = [[self.navigationController viewControllers] indexOfObject:self];
//    if (count >= 2) {
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(count - 2)] animated:YES];
//    }else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
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












































