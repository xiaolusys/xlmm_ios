//
//  JMPayShareController.m
//  XLMM
//
//  Created by zhang on 16/6/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPayShareController.h"
#import "JMPaySucTitleView.h"
#import "UIColor+RGBColor.h"
#import "JMSelecterButton.h"
#import "Masonry.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "JMSharePackView.h"
#import "JMShareView.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMPopView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

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
//    self.tableView.tableFooterView = nil;
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 90;
    
}

- (void)topShowTitle {
    
    JMPaySucTitleView *paySuccessView = [JMPaySucTitleView enterHeaderView];
    self.paySuccessView = paySuccessView;
    
    JMSharePackView *sharePackView = [JMSharePackView enterHeaderView];
    self.sharePackView = sharePackView;
    self.sharePackView.limitStr = self.limitStr;
    self.sharePackView.delegate = self;
    
    self.tableView.tableHeaderView = self.paySuccessView;
    self.tableView.tableFooterView = self.sharePackView;
    
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

- (void)setShareModel:(JMShareModel *)shareModel {
    _shareModel = shareModel;
}

- (void)composeGetRedpackBtn:(JMSharePackView *)renPack didClick:(UIButton *)button {
    
    JMShareViewController *shareView = [[JMShareViewController alloc] init];
    self.shareView = shareView;
    _shareDic = nil;
    
    self.shareView.model = _shareModel;
    
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
        //        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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












































