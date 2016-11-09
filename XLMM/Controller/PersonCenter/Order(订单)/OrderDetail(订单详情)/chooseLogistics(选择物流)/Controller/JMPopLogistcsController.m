//
//  JMPopLogistcsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopLogistcsController.h"
#import "JMSelecterButton.h"
#import "JMPopLogistcsCell.h"
#import "JMPopLogistcsModel.h"

@interface JMPopLogistcsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) JMSelecterButton *canelButton;

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation JMPopLogistcsController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self createUI];
    [self loadData];
    
    self.imageView = [[UIImageView alloc] init];

    
}


- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/address/get_logistic_companys",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlStr WithParaments:nil WithSuccess:^(id responseObject) {
        self.dataSource = [NSMutableArray array];
        
        NSMutableArray *dataSourceArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in responseObject) {
            JMPopLogistcsModel *model = [JMPopLogistcsModel mj_objectWithKeyValues:dic];
            [dataSourceArr addObject:model];
        }
        [self.dataSource addObjectsFromArray:dataSourceArr];
        [self.tableView reloadData];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

- (void)createUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 180) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.canelButton = cancelButton;
    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:13. CornerRadius:15];
    self.canelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.canelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.canelButton.frame = CGRectMake(10, 190, SCREENWIDTH - 20, 40);
    [self.view addSubview:self.canelButton];
 
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMPopLogistcsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMPopLogistcsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    JMPopLogistcsModel *model = self.dataSource[indexPath.row];
    [cell configWithModel:model Index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
    return cell;
}
- (void)setGoodsID:(NSString *)goodsID {
    _goodsID = goodsID;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JMPopLogistcsModel *model = self.dataSource[indexPath.row];

//    self.logisticsStr = model.name;
    if (_delegate && [_delegate respondsToSelector:@selector(ClickLogistics:Title:)]) {
        [_delegate ClickLogistics:self Title:model.name];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_company_code",Root_URL,self.goodsID];//?referal_trade_id=%@

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.logisticsStr forKey:@"referal_trade_id"];
    [dic setObject:model.code forKey:@"logistic_company_code"];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlStr WithParaments:dic WithSuccess:^(id responseObject) {
        
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
    [self cancelBtnClick];

}

//- (void)ClickLogistics:(JMPopLogistcsCell *)click Title:(NSString *)title {
//    
//    self.logisticsStr = title;
//    
//}

- (void)cancelBtnClick {
    
    [JMShareView hide];
    
    [JMPopView hide];
    
    
    [MBProgressHUD hideHUD];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"PopLogistics"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PopLogistics"];
}
@end































































