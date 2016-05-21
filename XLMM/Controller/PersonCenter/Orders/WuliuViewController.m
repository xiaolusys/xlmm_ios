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

@interface WuliuViewController ()
@property (nonatomic, strong) NSArray *infoArray;
@end

@implementation WuliuViewController

static NSString * const reuseIdentifier = @"LogisticsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigationBarWithTitle:@"物流信息" selecotr:@selector(goback)];
    self.wuliuInfoChainView.backgroundColor = [UIColor backgroundlightGrayColor];
    self.wuliuInfoChainView.delegate = self;
    self.wuliuInfoChainView.dataSource = self;
    self.wuliuInfoChainView.showsVerticalScrollIndicator = FALSE;
    [self.wuliuInfoChainView registerClass:[LogisticsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self getWuliuInfoFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) getWuliuInfoFromServer{
    //self.tradeId = @"xd15081955d45da07263e";
    if((self.packetId == nil) || ([self.packetId isEqualToString:@""])
       || (self.companyCode == nil || ([self.companyCode isEqualToString:@""]))){
        [SVProgressHUD showErrorWithStatus:@"快递单号信息不全"];
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
        if(responseObject == nil) return;
        NSDictionary *info = responseObject;
        [self fetchedWuliuData:info];
        [self.wuliuInfoChainView reloadData ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"wuliu info get failed.");
    }];

    
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的订单暂未查询到物流信息，请稍候查询或到快递公司网站查询" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
        
//        if (length > 0) {
//                NSDictionary *lastWuliuInfo = [self.infoArray firstObject];
//                NSString *timeText = [lastWuliuInfo objectForKey:@"time"];
//                timeText = [self spaceFormatTimeString:timeText];
//                
//                NSString *infoText = [lastWuliuInfo objectForKey:@"content"];
//                [self displayLastWuliuInfoWithTime: timeText andInfo:infoText];
//        }
//        NSInteger MAX = 4; // we only display at most 3 wuliu info.
//        if (length < MAX) {
//            MAX = length;
//        }
//        for (int i=1; i<MAX; ++i) {
//            NSDictionary *wuliuInfo =  self.infoArray[i];
//            NSString *timeText = [wuliuInfo objectForKey:@"time"];
//            timeText = [self spaceFormatTimeString:timeText];
//            
//            NSString *infoText = [wuliuInfo objectForKey:@"content"];
//            [self displayWuliuInfoWithOrder:i andTime:timeText andInfo:infoText];
//        }
   
    

}

-(NSString*) spaceFormatTimeString:(NSString*)timeString{
    NSMutableString *ms = [NSMutableString stringWithString:timeString];
    NSRange range = {10,1};
    [ms replaceCharactersInRange:range withString:@" "];
    return ms;
}

-(void)displayLastWuliuInfoWithTime:(NSString*)timeText andInfo:(NSString*)infoText{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WuliuInfoView" owner:nil options:nil];
    UIView *view = views[0];
    UIView *circleView = [view viewWithTag:100];
    UILabel *timeLabel = [view viewWithTag:200];
    UILabel *infoLabel = [view viewWithTag:300];
    
    timeLabel.text = timeText;
    infoLabel.text = infoText;
    UIColor *color = [UIColor orangeThemeColor];
    timeLabel.textColor = color;
    infoLabel.textColor = color;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = color;
    
    view.frame = CGRectMake(0, 17, SCREENWIDTH, 80);
    [self.wuliuInfoChainView addSubview:view];
}


-(void)displayWuliuInfoWithOrder:(UICollectionViewCell *)cell andTime:(NSString*)timeText andInfo:(NSString*)infoText{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WuliuInfoView" owner:nil options:nil];
    UIView *view = views[0];
    UIView *circleView = [view viewWithTag:100];
    UILabel *timeLabel = [view viewWithTag:200];
    UILabel *infoLabel = [view viewWithTag:300];
    
    timeLabel.text = timeText;
    infoLabel.text = infoText;
    
    UIColor *normalColor = [UIColor textDarkGrayColor];
    timeLabel.textColor = normalColor;
    infoLabel.textColor = normalColor;
    
    circleView.layer.cornerRadius = 4.5;
    circleView.backgroundColor = normalColor;
    
    view.frame = CGRectMake(0, 0, SCREENWIDTH, 80);
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
    
    NSDictionary *wuliuInfo =  [self.infoArray objectAtIndex:indexPath.row];
    NSString *timeText = [wuliuInfo objectForKey:@"time"];
    timeText = [self spaceFormatTimeString:timeText];
    
    NSString *infoText = [wuliuInfo objectForKey:@"content"];
    [self displayWuliuInfoWithOrder:cell andTime:timeText andInfo:infoText];
    
//    [cell fillCellWithData:[self.infoArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
