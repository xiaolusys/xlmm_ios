//
//  WuliuViewController.m
//  XLMM
//
//  Created by younishijie on 15/11/17.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "WuliuViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "UIColor+RGBColor.h"
#import "SVProgressHUD.h"
#import "LogisticsCollectionViewCell.h"
#import "AFNetworking.h"
#import "JMOrderGoodsModel.h"
#import "MJExtension.h"


@interface WuliuViewController ()

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic,strong) UICollectionView *wuliuInfoChainView;
@property (nonatomic,assign) BOOL islogisInfo;

@property (nonatomic,strong) JMOrderGoodsModel *orderModel;

@end

@implementation WuliuViewController

static NSString * const reuseIdentifier = @"LogisticsCell";

- (NSMutableArray *)infoArray {
    if (_infoArray == nil) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(goback)];
//    self.wuliuInfoChainView.backgroundColor = [UIColor backgroundlightGrayColor];
//    self.wuliuInfoChainView.delegate = self;
//    self.wuliuInfoChainView.dataSource = self;
//    self.wuliuInfoChainView.showsVerticalScrollIndicator = FALSE;
//    [self.wuliuInfoChainView registerClass:[LogisticsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self createCollectionView];
    [self getWuliuInfoFromServer];
}

- (void)createCollectionView {
    NSInteger count = self.infoArray.count;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(SCREENWIDTH, 60);
    self.wuliuInfoChainView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 180, SCREENWIDTH, 60 * count) collectionViewLayout:layout];
    self.wuliuInfoChainView.dataSource = self;
    self.wuliuInfoChainView.delegate = self;
    self.wuliuInfoChainView.showsVerticalScrollIndicator = FALSE;
    self.wuliuInfoChainView.backgroundColor = [UIColor backgroundlightGrayColor];
    [self.view addSubview:self.wuliuInfoChainView];
    [self.wuliuInfoChainView registerClass:[LogisticsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getWuliuInfoFromServer{
//    self.packetId = @"3101040539131";  http://m.xiaolumeimei.com/rest/v1/wuliu/get_wuliu_by_packetid?packetid=3101040539131&company_code=YUNDA_QR
    BOOL islogisInfo = ((self.packetId == nil) || ([self.packetId isEqualToString:@""])
    || (self.companyCode == nil || ([self.companyCode isEqualToString:@""])));
    self.islogisInfo = islogisInfo;
    if(self.islogisInfo){
//        [SVProgressHUD showErrorWithStatus:@"快递单号信息不全"];
        [self createFalse];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/wuliu/get_wuliu_by_packetid?packetid=%@&company_code=%@", Root_URL, self.packetId, self.companyCode];
    NSLog(@"%@", urlString);
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
//        [self performSelectorOnMainThread:@selector(fetchedWuliuData:)withObject:data waitUntilDone:YES];
//    });
    
    [SVProgressHUD showWithStatus:@"获取物流信息"];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if(responseObject == nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        NSDictionary *info = responseObject;
        [self fetchedWuliuData:info];
        [self.wuliuInfoChainView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"wuliu info get failed.");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }];

    
  }
#pragma mark --- 添加静态视图
- (void)createFalse {
    [self.infoArray addObject:self.orderModel];
    
}
- (void)setOrderDic:(NSDictionary *)orderDic {
    _orderDic = orderDic;
    JMOrderGoodsModel *orderModel = [JMOrderGoodsModel mj_objectWithKeyValues:_orderDic];
    self.orderModel = orderModel;
    
}
- (void)fetchedWuliuData:(NSDictionary *)responseData{
   // NSLog(@"%@",responseData);
    if (responseData == nil) {
        return;
    }
    
    
    NSDictionary *dicJson = responseData;
    NSLog(@"json = %@", dicJson);
    
    
    self.wuliuCompanyName.text = [dicJson objectForKey:@"name"];
    self.wuliuMiandanId.text = [dicJson objectForKey:@"order"];
    
 
    self.infoArray = [dicJson objectForKey:@"data"];
    NSInteger length = self.infoArray.count;
    if (length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，可能快递公司数据还未更新，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }

}

-(NSString*) spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}

-(void)displayLastWuliuInfoWithTime:(UICollectionViewCell *)cell time:(NSString*)timeText andInfo:(NSString*)infoText{
    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, 9, 9)];
    [view addSubview:circleView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 260, 35)];
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


-(void)displayWuliuInfoWithOrder:(UICollectionViewCell *)cell andTime:(NSString*)timeText andInfo:(NSString*)infoText{

    cell.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0, SCREENWIDTH, 80)];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 1, 80)];
    [view addSubview:lineView];
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, 9, 9)];
    [view addSubview:circleView];

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, 200, 17)];
    [view addSubview:timeLabel];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 20, 260, 35)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //    return 0;
    return self.infoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    if(cell != nil){
        [self removeAllSubviews:cell];
    }
    if (!self.islogisInfo) {
        NSDictionary *wuliuInfo =  [self.infoArray objectAtIndex:indexPath.row];
        NSString *timeText = [wuliuInfo objectForKey:@"time"];
        timeText = [self spaceFormatTimeString:timeText];
        
        NSString *infoText = [wuliuInfo objectForKey:@"content"];
        if(0 == indexPath.row){
            [self displayLastWuliuInfoWithTime:cell time:timeText andInfo:infoText];
        }
        else{
            [self displayWuliuInfoWithOrder:cell andTime:timeText andInfo:infoText];
        }

    }
    JMOrderGoodsModel *goodsModel = self.infoArray[indexPath.row];
    [cell configData:goodsModel];
//    [cell fillCellWithData:[self.infoArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(SCREENWIDTH, 60);
}


- (void)removeAllSubviews:(UIView *)v{
    while (v.subviews.count) {
        UIView* child = v.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end






















