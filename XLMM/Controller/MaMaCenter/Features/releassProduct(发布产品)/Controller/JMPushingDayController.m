//
//  JMPushingDayController.m
//  XLMM
//
//  Created by zhang on 16/11/18.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDayController.h"
#import "NSArray+Reverse.h"
#import "SharePicModel.h"
#import "JMPushingDayCell.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface JMPushingDayController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *picDataSource;


@end

@implementation JMPushingDayController
- (NSMutableArray *)picDataSource {
    if (!_picDataSource) {
        _picDataSource = [NSMutableArray array];
    }
    return _picDataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClick)];
    [self createTableView];
    
}
- (void)loadPicData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic?ordering=-save_times",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSArray *arrPic = responseObject;
        [self requestData:arrPic];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"获取信息失败"];
    } Progress:^(float progress) {
    }];
}
- (void)requestData:(NSArray *)data {
    if (data.count == 0) {
        [MBProgressHUD hideHUDForView:self.view];
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
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    //    qrCodeUrlString = @"http://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQH_7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL01rTXVsUHJsT09aQklkd1R1MjFfAAIEeybmVwMEAI0nAA==";
    for (NSDictionary *oneTurns in data) {
        NSMutableArray *muArray = [NSMutableArray array];
        NSArray *picArr = oneTurns[@"pic_arry"];
        if ([NSArray isEmptyForArray:picArr]) {
        }else {
            [muArray addObjectsFromArray:picArr];
        }
        
//        NSInteger countNum = muArray.count;
//        if (![NSString isStringEmpty:_qrCodeUrlString]) {
//            if (countNum < 9) {
//                [muArray addObject:_qrCodeUrlString];
//            }else {
//                [muArray replaceObjectAtIndex:4 withObject:_qrCodeUrlString];
//            }
//        }
        SharePicModel *sharePic = [SharePicModel mj_objectWithKeyValues:oneTurns];
        sharePic.pic_arry = muArray;
        [self.picDataSource addObject:sharePic];
    }
    [self.tableView reloadData];
//    [MBProgressHUD hideHUDForView:self.view];
    
}



- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[JMPushingDayCell class] forCellReuseIdentifier:@"JMPushingDayCellIdentifier"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.picDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMPushingDayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMPushingDayCellIdentifier"];
    if (!cell) {
        cell = [[JMPushingDayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JMPushingDayCellIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(JMPushingDayCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.picModel = self.picDataSource[indexPath.row];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"JMPushingDayCellIdentifier" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}





































@end
























































































































































































































































