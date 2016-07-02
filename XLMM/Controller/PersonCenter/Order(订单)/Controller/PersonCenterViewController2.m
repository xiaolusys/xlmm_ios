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

#import "NSString+URL.h"
#import "MJRefresh.h"
#import "SingleOrderViewCell.h"
#import "MoreOrdersViewCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "MJExtension.h"
#import "DingdanModel.h"


#define kSimpleCellIdentifier @"simpleCell"

@interface PersonCenterViewController2 ()<NSURLConnectionDataDelegate>

@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation PersonCenterViewController2{
        NSDictionary *diciontary;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
    

    [self downlaodData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

//待收货订单。。。。。。

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"待收货订单" selecotr:@selector(btnClicked:)];
    [self.view addSubview:[[UIView alloc] init]];
    
    self.collectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    
    [self createButton];
    
    [self.collectionView registerClass:[SingleOrderViewCell class] forCellWithReuseIdentifier:@"SingleOrderCell"];
    [self.collectionView registerClass:[MoreOrdersViewCell class] forCellWithReuseIdentifier:@"MoreOrdersCell"];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    footer.hidden = YES;
    
    self.collectionView.mj_footer = footer;
    
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
    NSString *urlString = [diciontary objectForKey:@"next"];
    if ([urlString class] == [NSNull class]) {
        NSLog(@"no more");
        
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        
        return;
    }
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.collectionView.mj_footer endRefreshing];
        if (!responseObject) return;
        
        [self fetchedWaisendData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"%@获取数据失败",urlString);
    }];
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downlaodData{

    [SVProgressHUD showWithStatus:@"加载中..."];
    
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:kWaitsend_List_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        
        if (!responseObject) return;
        
        [self fetchedWaisendData:responseObject ];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
    }];

}

- (void)fetchedWaisendData:(NSDictionary *)data{
    if (data == nil) {
        NSLog(@"下载失败");
        return;
    }

    diciontary = data;


    if ([[diciontary objectForKey:@"count"] integerValue] == 0) {
        [self displayDefaultView];
        return;
    }
    
    self.dataArray = [diciontary objectForKey:@"results"];
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
        
        [cell.orderImageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
        
        cell.nameLabel.text = [details objectForKey:@"title"];
        cell.sizeLabel.text = [details objectForKey:@"sku_name"];
        cell.numberLabel.text = [NSString stringWithFormat:@"x%@", [details objectForKey:@"num"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"total_fee"] floatValue]];
        cell.paymentLabel.text = [NSString stringWithFormat:@"¥%.1f", [[details objectForKey:@"payment"] floatValue]];
        cell.orderImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSString *string = [diction objectForKey:@"status_display"];
        cell.statusLabel.text = string;

//       for (int i = 0; i < self.dataArray.count; i++) {
//            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//            NSLog(@"btn ->%@", btn);
//            [btn removeFromSuperview];
//        }
//        if ([string isEqualToString:@"已付款"]) {
//            UIButton *button = [self buttonWithTitle:@"申请退款" andTag:indexPath.row + 100];
//
//            [cell.contentView addSubview:button];
//        }  else if ([string isEqualToString:@"已发货"]) {
//            NSLog(@"已经发货");
//            UIButton *button = [self buttonWithTitle:@"确认签收" andTag:indexPath.row + 100];
//
//            [cell.contentView addSubview:button];
//        } else if ([string isEqualToString:@"确认签收"]) {
//            NSLog(@"已签收");
//            UIButton *button = [self buttonWithTitle:@"退货退款" andTag:indexPath.row + 100];
//
//            [cell.contentView addSubview:button];
//        }
        
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
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[details objectForKey:@"pic_path"] URLEncodedString]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.cornerRadius = 5;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
            imageView.hidden = NO;
            
        }
//        for (int i = 0; i < self.dataArray.count; i++) {
//            UIButton * btn = (UIButton *)[cell.contentView viewWithTag:i + 100];
//            [btn removeFromSuperview];
//        }
       
         NSString *string = [diction objectForKey:@"status_display"];
        cell.statusLabel.text = string;

//        if ([string isEqualToString:@"已付款"]) {
//            UIButton *button = [self buttonWithTitle:@"申请退款" andTag:indexPath.row + 100];
//
//            [cell.contentView addSubview:button];
//        }else if ([string isEqualToString:@"已发货"]){
//            UIButton *button = [self buttonWithTitle:@"确认签收" andTag:indexPath.row + 100];
//
//            [cell.contentView addSubview:button];
//         
//        } else if ([string isEqualToString:@"确认签收"]) {
//            NSLog(@"已签收");
//            UIButton *button = [self buttonWithTitle:@"退货退款" andTag:indexPath.row + 100];
//            
//            [cell.contentView addSubview:button];
//        }
        
        return cell;
    }

    

}

- (UIButton *)buttonWithTitle:(NSString *)title andTag:(NSInteger)tag{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 70, 6, 80, 25)];
    button.tag = tag;
    
    [button setTitle:title forState:UIControlStateNormal];
    button.enabled = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    button.layer.cornerRadius = 12.5;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    return button;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%ld : %ld", (long)indexPath.section, (long)indexPath.row);
    XiangQingViewController *xiangqingVC = [[XiangQingViewController alloc] initWithNibName:@"XiangQingViewController" bundle:nil];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *ID = [dic objectForKey:@"id"];
//    NSLog(@"id = %@", ID);
    DingdanModel *dingdanModel = [DingdanModel mj_objectWithKeyValues:dic];
    xiangqingVC.dingdanModel = dingdanModel;
    xiangqingVC.goodsArr = dic[@"orders"];
    //      http://m.xiaolu.so/rest/v1/trades/86412/details
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/trades/%@", Root_URL, ID];
//    NSLog(@"urlString = %@", urlString);
    xiangqingVC.urlString = urlString;
    [self.navigationController pushViewController:xiangqingVC animated:YES];
}

-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有待收货订单哦～快去看看吧!";
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 添加返回顶部按钮

- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];

    self.topButton.hidden = YES;
}

//- (void)hiddenBackTopBtn {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topButton.hidden = YES;
//    }];
//}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.dataArray.count == 0) {
            self.topButton.hidden = YES;
        }else {
            self.topButton.hidden = NO;
        }
    }];
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenBackTopBtn) userInfo:nil repeats:NO];
//}




@end




































