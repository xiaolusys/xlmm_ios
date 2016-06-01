//
//  JMPopLogistcsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPopLogistcsController.h"
#import "JMSelecterButton.h"
#import "UIColor+RGBColor.h"
#import "JMShareView.h"
#import "JMPopView.h"
#import "SVProgressHUD.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "JMPopLogistcsCell.h"
#import "JMPopLogistcsModel.h"
#import "MJExtension.h"

@interface JMPopLogistcsController ()<UITableViewDelegate,UITableViewDataSource,JMPopLogistcsCellDelegate>

@property (nonatomic,strong) JMSelecterButton *canelButton;

@property (nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation JMPopLogistcsController

//- (NSMutableArray *)dataSource {
//    if (_dataSource) {
//        _dataSource = [NSMutableArray array];
//    }
//    return _dataSource;
//}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
    [self loadData];
    
    self.imageView = [[UIImageView alloc] init];

    
}

//- (void)setDataSource:(NSMutableArray *)dataSource {
//    _dataSource = dataSource;
//}

- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/address/get_logistic_companys",Root_URL];
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    
    [manage GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /**
         *  {
         code = "YUNDA_QR";
         id = "-2";
         name = "\U97f5\U8fbe\U70ed\U654f";
         }
         */
        
//        JMPopLogistcsModel *model = [[JMPopLogistcsModel alloc] init];
        self.dataSource = [NSMutableArray array];
        
        NSMutableArray *dataSourceArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in responseObject) {
//            self.imageStr = @"circle_wallet_Normal";

            JMPopLogistcsModel *model = [JMPopLogistcsModel mj_objectWithKeyValues:dic];
            
            [dataSourceArr addObject:model];
        }

        
        
        [self.dataSource addObjectsFromArray:dataSourceArr];
        //        [self.dataSource addObjectsFromArray:dataSourceArr];
        
        //        self.dataSource = [NSMutableArray arrayWithArray:responseObject];
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, 180) style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = NO;
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

- (void)createUI {
    
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
    [cell configWithModel:model];
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        cell.accessoryView = self.imageView;
//        self.imageView.image = [UIImage imageNamed:@"selected_icon"];
    }
    
//    cell.textLabel.text = self.dataSource[indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"circle_wallet_Normal"];//selected_icon   circle_wallet_Normal
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
    
    
    return cell;
}
- (void)setGoodsID:(NSString *)goodsID {
    _goodsID = goodsID;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    JMPopLogistcsCell *cell = [[JMPopLogistcsCell alloc] init];
//    JMPopLogistcsModel *model = self.dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        self.imageView.image = [UIImage imageNamed:@"selected_icon"];

    }
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_company_code",Root_URL,self.goodsID];//?referal_trade_id=%@

    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    
    
    
    [manage POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
    
//    [self cancelBtnClick];
    
    
    
    
    
}
- (void)composeWith:(UIImageView *)imageView {
    self.imageView = imageView;
    
}

- (void)cancelBtnClick {
    
    [JMShareView hide];
    
    [JMPopView hide];
    
    [SVProgressHUD dismiss];
}
@end































































