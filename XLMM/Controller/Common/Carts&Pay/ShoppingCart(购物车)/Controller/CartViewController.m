//
//  CartViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableCellTableViewCell1.h"
#import "MMClass.h"
#import "ShoppingCartModel.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"
#import "CartListModel.h"
#import "NSString+URL.h"
#import "ReBuyTableViewCell.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import "MJExtension.h"
#import "CartListModel.h"
#import "JMPurchaseController.h"

@interface CartViewController ()<CartViewDelegate, ReBuyCartViewDelegate, UIAlertViewDelegate>{
    float allPrice;
    CartListModel *deleteModel;
    BOOL download1;
    BOOL download2;
    BOOL isEmpty;
}
@property (nonatomic, strong)NSMutableArray *historyCarts;
@property (strong, nonatomic)NSMutableArray *dataArray;



@end

@implementation CartViewController{
    NSInteger youhuiquanValud;
    NSDictionary *_carsGoodsDic;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;

    isEmpty = YES;
    download1 = NO;
    download2 = NO;
    [SVProgressHUD showWithStatus:@"加载中..."];
    [self downloadData];
    [self downloadHistoryData];
    
    [MobClick beginLogPageView:@"ShoppingCart"];
}

-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    UILabel *label1 = [defaultView viewWithTag:200];
    UILabel *label2 = [defaultView viewWithTag:300];
    UIImageView *imageView = [defaultView viewWithTag:400];
    
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor orangeThemeColor].CGColor;
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    label1.text = @"抢几件喜欢的就好～";
    label2.text = @"亲，您的购物车空空的呢～快去装满它吧!";
    imageView.image = [UIImage imageNamed:@"gouwucheemptyimage.png"];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    [MobClick endLogPageView:@"ShoppingCart"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.dataArray = [[NSMutableArray alloc] init];
    self.historyCarts = [[NSMutableArray alloc] init];
    
    allPrice = 0.0f;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [UIColor backgroundlightGrayColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createNavigationBarWithTitle:@"购物车" selecotr:@selector(backBtnClicked:)];
    self.buyButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    self.totalPricelabel.text =[NSString stringWithFormat:@" "];
    
    [self.myTableView registerClass:[CartTableCellTableViewCell1 class] forCellReuseIdentifier:@"simpleCellID"];
    [self.myTableView registerClass:[ReBuyTableViewCell class] forCellReuseIdentifier:@"ReBuyTableCell"];
    youhuiquanValud = 0;
}
- (void)downloadData {
    [SVProgressHUD dismiss];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kCart_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchedCartData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)fetchedCartData:(NSArray *)careArr {

    download1 = YES;
    if (careArr.count > 0) {
        isEmpty = NO;
    }
    if (careArr.count <= 0 && download2 && isEmpty) {
        [self displayDefaultView];
    }
    [self.dataArray removeAllObjects];
    allPrice = 0.0f;
    for (NSDictionary *dic in careArr) {
        CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
        allPrice += [model.total_fee floatValue];
        [self.dataArray addObject:model];
        _carsGoodsDic = dic;
    }
    self.totalPricelabel.text = [NSString stringWithFormat:@"¥%.2f", allPrice];
    [self.cartTableView reloadData];
}
- (void)downloadHistoryData{
    [SVProgressHUD dismiss];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kCart_History_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) return ;
        [self fetchedHistoryCartData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)fetchedHistoryCartData:(NSArray *)array {
    download2 = YES;
    if (array.count > 0) {
        isEmpty = NO;
    }
    if (array.count <= 0 && download1 && isEmpty) {
        [self displayDefaultView];
    }
    [self.historyCarts removeAllObjects];
    for (NSDictionary *dic in array) {
        CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
        [self.historyCarts addObject:model];
    }
    [self.myTableView reloadData];
}

#pragma mark --UITableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count;
    } else if (section == 1){
        return self.historyCarts.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"simpleCellID";
        NSLog(@"self.dataArray.count = %ld", (long)self.dataArray.count);
        
        CartTableCellTableViewCell1 *cell = (CartTableCellTableViewCell1 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.dataArray.count == 0) {
            
        } else{
            
            CartListModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.cartModel= model;
            cell.myImageView.layer.borderWidth = 0.5;
            cell.myImageView.layer.borderColor = [UIColor lineGrayColor].CGColor;
            cell.myImageView.layer.cornerRadius = 5;
            cell.myImageView.layer.masksToBounds = YES;
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[model.pic_path JMUrlEncodedString]]];
            cell.myImageView.contentMode = UIViewContentModeScaleAspectFill;

            cell.nameLabel.text = model.title;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
            
            //    cell.contentView.backgroundColor = [UIColor redColor];
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld", [model.num integerValue]];
            cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.std_sale_price floatValue]];
            
            cell.sizeLabel.text = model.sku_name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        
        return cell;
    } else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"ReBuyTableCell";
        
        
        ReBuyTableViewCell *cell = (ReBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.historyCarts.count == 0) {
            
        } else{
            
            CartListModel *model = [self.historyCarts objectAtIndex:indexPath.row];
            cell.cartModel= model;
            cell.headImageView.layer.borderWidth = 0.5;
            cell.headImageView.layer.borderColor = [UIColor lineGrayColor].CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.headImageView.layer.cornerRadius = 5;
            cell.headImageView.layer.masksToBounds = YES;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[model.pic_path JMUrlEncodedString]]];
            cell.headImageView.contentMode = UIViewContentModeScaleAspectFill;

            
            cell.cartModel = model;
            cell.nameLabel.text = model.title;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
            
            cell.allPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", [model.std_sale_price floatValue]];
            
            cell.sizeLabel.text = model.sku_name;

            cell.delegate = self;
            
        
        }
        
        return cell;
        
    }
    return nil;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 110;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        return 0;
    }
    if (indexPath.section == 1) {
        return 0;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataArray.count == 0) {
            self.bottomHeight.constant = 0;
            return 240;
            
        } else {
            self.bottomHeight.constant = 90;
            return 50;
        }
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 0.1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.dataArray.count == 0 && download1) {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyCartView" owner:nil options:nil];
            
            UIView *footerView = views[0];
            footerView.frame = CGRectMake(0, 0, SCREENHEIGHT, 240);
            UIButton *button = [footerView viewWithTag:123];
            button.layer.cornerRadius = 15;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
            [button addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
            return footerView;
        } else {
            NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:nil options:nil];
            
            UIView *footerView = views[0];
            UILabel *pricelabel = (UILabel *)[footerView viewWithTag:100];
            UILabel *nameLabel = (UILabel *)[footerView viewWithTag:200];
            UIImageView *imageView = (UIImageView *)[footerView viewWithTag:300];
            UILabel *youhuiquanLabel = (UILabel *)[footerView viewWithTag:400];
            
            youhuiquanLabel.text = [NSString stringWithFormat:@"¥%ld", youhuiquanValud];
            pricelabel.text = [NSString stringWithFormat:@"¥%.2f", allPrice];
            nameLabel.text = @"可使用优惠券";
            imageView.hidden = NO;
            footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
            footerView.backgroundColor = [UIColor backgroundlightGrayColor];
            return footerView;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)backClicked:(UIButton *)button{
    NSLog(@"逛逛");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
        headerView.backgroundColor = [UIColor backgroundlightGrayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 160, 34)];
        label.textColor = [UIColor settingBackgroundColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"可重新购买的商品";
       
        [headerView addSubview:label];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
        lineView.backgroundColor= [UIColor lineGrayColor];
        [headerView addSubview:lineView];
       
        if (self.historyCarts.count == 0) {
            label.hidden = YES;
            lineView.hidden = YES;
        } else{
            label.hidden = NO;
            lineView.hidden = NO;
        }
        return headerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == indexPath.row) {
        return;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteModel = [self.dataArray objectAtIndex:indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
//        NSLog(@"indexpath . row ", )
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //调用删除接口。。。。。。
        [self deleteCatr];
        
    }
}
- (void)deleteCatr{
    self.frontView.hidden = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/delete_carts", Root_URL,deleteModel.cartID];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self downloadData];
        [self downloadHistoryData];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
        NSLog(@"data = %@", data);
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"dic = %@", dic);
            __unused NSInteger count = [[dic objectForKey:@"result"] integerValue];
            NSLog(@"count = %ld", (long)count);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}
- (void)buyOneGood{
    UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-120, 200, 240, 60)];
    myview.backgroundColor = [UIColor blackColor];
    myview.alpha = 0.7;
    myview.layer.cornerRadius = 8;
    UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
    mylabel.text = @"客官至少买一件嘛";
    mylabel.textColor = [UIColor whiteColor];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.font = [UIFont systemFontOfSize:24];
    [myview addSubview:mylabel];
    [self.view addSubview:myview];

    [UIView animateWithDuration:1.5 animations:^{
        myview.alpha = 0;
    } completion:^(BOOL finished) {
        [myview removeFromSuperview];
    }];
}
/**
 *  减少一件商品
 */
- (void)reduceNumber:(CartListModel *)cartModel{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/minus_product_carts", Root_URL,cartModel.cartID];
    NSLog(@"url = %@", urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self downloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          }
     ];
}
/**
 *  添加一件商品
 */
- (void)addNumber:(CartListModel *)cartModel{
   [SVProgressHUD showWithStatus:@"加载中..."];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/plus_product_carts", Root_URL,cartModel.cartID];
    NSLog(@"url = %@", urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              [self downloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD showErrorWithStatus:@"商品库存不足"];
              [self downloadData];
        }
     ];
}
- (void)deleteCartView:(CartListModel *)cartModel{
    deleteModel = cartModel;
    self.myView.frame = CGRectMake(10, 120, SCREENWIDTH - 20, 188);
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
    
}
- (void)retainClicked{
    [self.myView removeFromSuperview];
    self.frontView.hidden = YES;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteClicked];
    }
}
/**
 *  删除购物车操作
 */
- (void)deleteClicked{
    [self.myView removeFromSuperview];
    self.frontView.hidden = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/delete_carts", Root_URL,deleteModel.cartID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self downloadData];
        [self downloadHistoryData];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
        NSLog(@"data = %@", data);
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"dic = %@", dic);
            
            NSInteger count = [[dic objectForKey:@"result"] integerValue];
            NSLog(@"count = %ld", (long)count);
            if (count == 0) {
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
/**
 *  购买按钮
 */
- (IBAction)purchaseClicked:(id)sender {
    [MobClick event:@"purchase"];
    
//    PurchaseViewController1 *purchaseVC = [[PurchaseViewController1 alloc] initWithNibName:@"PurchaseViewController1" bundle:nil];
//    purchaseVC.cartsArray = self.dataArray;
    JMPurchaseController *purchaseVC = [[JMPurchaseController alloc] init];
    purchaseVC.purchaseGoodsArr = self.dataArray;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}
#pragma mark ---- 重新购买按钮点击
- (void)reBuyAddCarts:(CartListModel *)model{
    [MobClick event:@"buy_again_click"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"item_id": model.item_id,
                                 @"sku_id":model.sku_id,
                                 @"cart_id":[NSString stringWithFormat:@"%ld",model.cartID]
                                 };

    [manager POST:kCart_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //[self myAnimation];
              NSInteger codeNum = [responseObject[@"code"] integerValue];
              if (codeNum == 0) {
                  [self downloadData];
                  [self downloadHistoryData];
                  if (self.dataArray.count >= 18) {
                      NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
                      [self.myTableView scrollToRowAtIndexPath:(indexpath) atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                  }
              }else {
                  [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [SVProgressHUD showErrorWithStatus:@"加入购物车失败，请检查网络或者注销后重新登录。"];
              
          }];
}
#pragma mark == 点击进入商品详情
- (void)composeImageTap:(CartListModel *)model {
    NSString *weiUrl = model.item_weburl;
    if (weiUrl == nil) {
        return ;
    }else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:weiUrl forKey:@"web_url"];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.webDiction = dic;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)tapClick:(CartListModel *)model {
    NSString *weiUrl = model.item_weburl;
    if (weiUrl == nil) {
        return ;
    }else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:weiUrl forKey:@"web_url"];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.webDiction = dic;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}
- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
/**
 *  //- (void)downloadData{
 //    [SVProgressHUD dismiss];
 //    NSLog(@"cart Url = %@", kCart_URL);
 //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
 //        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_URL]];
 //        if (data == nil) {
 //            NSLog(@"下载失败");
 //            return ;
 //        }
 //
 //        [self performSelectorOnMainThread:@selector(fetchedCartData:) withObject:data waitUntilDone:YES];
 //    });
 //}
 //// 获取可用优惠券金额 。。。
 //- (void)createYhqValue{
 //    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/usercoupons", Root_URL];
 //    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
 //    if (data == nil) {
 //        return;
 //    }
 //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
 //    NSLog(@"dic = %@", dic);
 //    NSArray *array = [dic objectForKey:@"results"];
 //    for (NSDictionary *info in array) {
 //        NSInteger value = [[info objectForKey:@"coupon_value"] integerValue];
 //        if (value > youhuiquanValud && value < 200) {
 //            youhuiquanValud = value;
 //        }
 //    }
 //    NSLog(@"value = %ld", youhuiquanValud);
 //    
 //}
 NSLog(@"Error: %@", error);
 NSLog(@"error:, --.>>>%@", error.description);
 NSDictionary *dic = [error userInfo];
 NSLog(@"dic = %@", dic);
 NSLog(@"error = %@", [dic objectForKey:@"com.alamofire.serialization.response.error.data"]);
 
 __unused NSString *str = [[NSString alloc] initWithData:[dic objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
 NSLog(@"%@",str);
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 80, 200, 160, 60)];
 view.backgroundColor = [UIColor blackColor];
 view.layer.cornerRadius = 8;
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
 label.text = @"加入购物车失败，请检查网络或者注销后重新登录。";
 label.textAlignment = NSTextAlignmentCenter;
 label.textColor = [UIColor whiteColor];
 label.font = [UIFont systemFontOfSize:24];
 [view addSubview:label];
 [self.view addSubview:view];
 
 [UIView animateWithDuration:1.0 animations:^{
 view.alpha = 0;
 } completion:^(BOOL finished) {
 [view removeFromSuperview];
 }];
 //
 NSLog(@"库存不足");
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 80, 200, 160, 30)];
 view.backgroundColor = [UIColor darkGrayColor];
 view.layer.cornerRadius = 4;
 UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
 label.text = @"商品库存不足";
 label.textAlignment = NSTextAlignmentCenter;
 label.textColor = [UIColor imageViewBorderColor];
 label.font = [UIFont systemFontOfSize:14];
 [view addSubview:label];
 [self.view addSubview:view];
 
 
 [UIView animateWithDuration:1.0 animations:^{
 view.alpha = 0;
 } completion:^(BOOL finished) {
 [view removeFromSuperview];
 }];
 
 NSLog(@"%@", operation);
 NSLog(@"Error: %@", error.userInfo);
 NSDictionary *dic = error.userInfo;
 NSData *data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
 __unused NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"data = %@", str);
 

 */
