//
//  PersonCenterViewController2.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController2.h"
#import "MMClass.h"
#import "XiangQingViewController.h"
#import "UIViewController+NavigationBar.h"
#define kSimpleCellIdentifier @"simpleCell"

#import "SingleOrderViewCell.h"
#import "MoreOrdersViewCell.h"


@interface PersonCenterViewController2 ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation PersonCenterViewController2

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self downlaodData];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

//待收货订单。。。。。。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待收货订单";
     [self.collectionView registerClass:[ShouHuoCollectionViewCell class] forCellWithReuseIdentifier:kSimpleCellIdentifier];
    [self createNavigationBarWithTitle:@"待收货订单" selecotr:@selector(btnClicked:)];
    [self.view addSubview:[[UIView alloc] init]];
    
    self.collectionView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
    
    [self.collectionView registerClass:[SingleOrderViewCell class] forCellWithReuseIdentifier:@"SingleOrderCell"];
    [self.collectionView registerClass:[MoreOrdersViewCell class] forCellWithReuseIdentifier:@"MoreOrdersCell"];

}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downlaodData{
    
    
//   http://192.168.1.79:8000/rest/v1/trades
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"wait send = %@", kWaitsend_List_URL);
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kWaitsend_List_URL]];
        
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedWaipayData:(NSData *)data{
    if (data == nil) {
        NSLog(@"下载失败");
        return;
    }
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"解析出错");
    }
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无待支付列表");
        return;
    }
    
    self.dataArray = [json objectForKey:@"results"];
    
    
    NSLog(@"dataArray = %@", self.dataArray);
   
    [self.collectionView reloadData];
    
    
    
}


#pragma mark -----CollectionViewDelegate-----

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

//定义Cell 的高度。。。。。

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 117);
}

//返回列表的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *diction = [self.dataArray objectAtIndex:indexPath.row];
    NSArray *orderArray = [diction objectForKey:@"orders"];
    
    if (orderArray.count == 1) {
        SingleOrderViewCell *cell = (SingleOrderViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SingleOrderCell" forIndexPath:indexPath];
        
        NSDictionary *details = [orderArray objectAtIndex:0];
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[details objectForKey:@"pic_path"]]];
        
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"payment"] floatValue]];
        NSString *string = [details objectForKey:@"status_display"];
        if ([string isEqualToString:@"已付款"]) {
             cell.statusLabel.text = @"商品准备中";
        } else if ([string isEqualToString:@"已发货"]){
            cell.statusLabel.text = @"配送中";
        } else if ([string isEqualToString:@"确认签收"]){
            cell.statusLabel.text = @"已签收";
        }
       
        
        
        
        for (int i = 0; i < self.dataArray.count; i++) {
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
            [btn removeFromSuperview];
        }
        
        
        if ([string isEqualToString:@"已付款"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
            button.tag = indexPath.row +100;
            
            [button setTitle:@"申请退款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
            button.layer.cornerRadius = 12.5;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
            [cell.contentView addSubview:button];
            button.userInteractionEnabled = NO;
        }  else if ([string isEqualToString:@"已发货"]) {
            NSLog(@"已经发货");
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
            button.tag = indexPath.row +100;
            
            [button setTitle:@"确认收货" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
            button.layer.cornerRadius = 12.5;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
            [cell.contentView addSubview:button];
        }
        return cell;
    }
    else{
        MoreOrdersViewCell *cell = (MoreOrdersViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoreOrdersCell" forIndexPath:indexPath];
        //  cell.paymentLabel.text = [[NSString stringWithFormat:@"¥%.1f", [[diction objectForKey:@"payment"]floatValue]];
        
        cell.paymentLabel.text = [NSString stringWithFormat:@"%.1f", [[diction objectForKey:@"payment"] floatValue]];
        for (int i = 1101; i <= 1106; i++) {
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            imageView.hidden = YES;
        }
        for (int i = 1101; i < orderArray.count + 1101; i++) {
            NSDictionary *details = [orderArray objectAtIndex:i - 1101];
            UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:i];
            NSLog(@"imageView = %@", imageView);
            [imageView sd_setImageWithURL:[NSURL URLWithString:[details objectForKey:@"pic_path"]]];
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor;
            imageView.hidden = NO;
            
        }
        for (int i = 0; i < self.dataArray.count; i++) {
            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
            [btn removeFromSuperview];
        }
       
         NSString *string = [diction objectForKey:@"status_display"];
        if ([string isEqualToString:@"已付款"]) {
            cell.statusLabel.text = @"商品准备中";
        } else if ([string isEqualToString:@"已发货"]){
            cell.statusLabel.text = @"配送中";
        }
        
        
       
        
        if ([string isEqualToString:@"已付款"]) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
            button.tag = indexPath.row +100;
            
            [button setTitle:@"申请退款" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
            button.layer.cornerRadius = 12.5;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
            
            button.userInteractionEnabled = NO;
            [cell.contentView addSubview:button];
        }else if ([string isEqualToString:@"已发货"]){
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
            button.tag = indexPath.row +100;
            
            [button setTitle:@"确认签收" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
            button.layer.cornerRadius = 12.5;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
            [cell.contentView addSubview:button];
        }
        return cell;
    }

    
//    ShouHuoCollectionViewCell *cell = (ShouHuoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCellIdentifier forIndexPath:indexPath];
//    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
//    [cell.myimageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"order_pic"]]];
//    cell.myimageView.layer.masksToBounds = YES;
//    cell.myimageView.layer.cornerRadius = 5;
//    cell.myimageView.layer.borderWidth = 1;
//    cell.myimageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
//    
//    
//    
//    NSString *status = [dic objectForKey:@"status_display"];
//    
//    NSMutableString *string = [[NSMutableString alloc]initWithString:[dic objectForKey:@"created"]];
//    NSRange range = [string rangeOfString:@"T"];
//    //    [string deleteCharactersInRange:range];
//    //    [string insertString:@" " atIndex:range.location];
//    [string replaceCharactersInRange:range withString:@" "];
//    range = [string rangeOfString:@"-"];
//    [string replaceCharactersInRange:range withString:@"/"];
//    range = [string rangeOfString:@"-"];
//    [string replaceCharactersInRange:range withString:@"/"];
//    
//    cell.xiadanshijianLabel.text = string;
//    cell.zhuangtaiLabel.text = [dic objectForKey:@"status_display"];
//    cell.jineLabel.text = [NSString stringWithFormat:@"¥%.1f",[[dic objectForKey:@"payment"] floatValue]];
//    cell.biaohaoLabel.text = [dic objectForKey:@"tid"];
//    
//    for (int i = 0; i < self.dataArray.count; i++) {
//        UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//        [btn removeFromSuperview];
//    }
//    
//    if ([status isEqualToString:@"已发货"]) {
//        NSLog(@"已经发货");
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//        button.tag = indexPath.row +100;
//        
//        [button setTitle:@"确认收货" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(querenQianshou:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
//        button.layer.cornerRadius = 12.5;
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        button.layer.borderWidth = 0.5;
//        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//        button.userInteractionEnabled = NO;
//        [cell.contentView addSubview:button];
//    } else if ([status isEqualToString:@"已付款"]){
//        NSLog(@"没有发货");
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
//        button.tag = indexPath.row +100;
//        
//        [button setTitle:@"申请退款" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(shenqingtuikuan:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
//        button.layer.cornerRadius = 12.5;
//        button.titleLabel.font = [UIFont systemFontOfSize:12];
//        button.layer.borderWidth = 0.5;
//        button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
//        button.userInteractionEnabled = NO;
//        [cell.contentView addSubview:button];
//    }
//    
//    NSLog(@"%ld", (long)cell.contentView.subviews.count);
//    
//    return cell;
}

- (void)shenqingtuikuan:(UIButton *)button{
    NSLog(@"申请退货");
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld : %ld", (long)indexPath.section, (long)indexPath.row);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *ID = [dic objectForKey:@"id"];
    NSLog(@"id = %@", ID);
    
    //      http://m.xiaolu.so/rest/v1/trades/86412/details
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/trades/%@/details", Root_URL, ID];
    NSLog(@"urlString = %@", urlString);
    xiangqingVC.urlString = urlString;
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    
    
    
    
    
    
    
}

- (void)querenQianshou:(UIButton *)button{
    
    NSLog(@"确认收货");
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"111 : %@", response);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"222 : %@", dic);
    
    
    NSLog(@"string = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"3333 : %@", connection);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
