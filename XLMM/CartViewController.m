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
#import "NewCartsModel.h"
#import "PurchaseViewController1.h"
#import "HistoryCartsView.h"
#import "NSString+URL.h"
#import "ReBuyTableViewCell.h"



@interface CartViewController ()<CartViewDelegate, ReBuyCartViewDelegate, UIAlertViewDelegate>{
    float allPrice;
    NewCartsModel *deleteModel;
    BOOL download1;
    BOOL download2;
    BOOL isEmpty;
}
@property (nonatomic, strong)NSMutableArray *historyCarts;
@property (strong, nonatomic)NSMutableArray *dataArray;



@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    // This design has logical problem:
    // downloadData & downloadHisoryData should be returned with on request.
    isEmpty = YES;
    download1 = NO;
    download2 = NO;
    [self downloadData];
    [self downloadHistoryData];
    
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
    label2.text = @"亲，您的购物车空空的呢～快去装满它吧！";
    imageView.image = [UIImage imageNamed:@"gouwucheemptyimage.png"];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.historyCarts = [[NSMutableArray alloc] init];
    
    allPrice = 0.0f;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createNavigationBarWithTitle:@"购物车" selecotr:@selector(backBtnClicked:)];
    self.buyButton.backgroundColor = [UIColor colorWithR:245 G:177 B:35 alpha:1];
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor colorWithR:217 G:140 B:13 alpha:1].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    self.totalPricelabel.text =[NSString stringWithFormat:@" "];
    
    [self.myTableView registerClass:[CartTableCellTableViewCell1 class] forCellReuseIdentifier:@"simpleCellID"];
    [self.myTableView registerClass:[ReBuyTableViewCell class] forCellReuseIdentifier:@"ReBuyTableCell"];
}



- (void)downloadData{
    NSLog(@"cart Url = %@", kCart_URL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_URL]];
        if (data == nil) {
            NSLog(@"下载失败");
            return ;
        }

        [self performSelectorOnMainThread:@selector(fetchedCartData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedCartData:(NSData *)responseData{
   
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (error != nil) {
        NSLog(@"解析失败");
        NSLog(@"error = %@", error);
        return;
    }
    
    download1 = YES;
    if (json.count > 0) {
        isEmpty = NO;
    }
    if (json.count <= 0 && download2 && isEmpty) {
        [self displayDefaultView];
    }
    
    [self.dataArray removeAllObjects];

        
    
    allPrice = 0.0f;
    for (NSDictionary *dic in json) {
        NewCartsModel *model = [NewCartsModel new];
        model.status = [[dic objectForKey:@"status"] intValue];
        model.sku_id = [dic objectForKey:@"sku_id"];
        model.title = [dic objectForKey:@"title"];
        model.price = [[dic objectForKey:@"price"] floatValue];
        model.buyer_nick = [dic objectForKey:@"buyer_nick"];
        model.num = [[dic objectForKey:@"num"] intValue];
        model.remain_time = [dic objectForKey:@"remain_time"];
        model.std_sale_price = [[dic objectForKey:@"std_sale_price"] floatValue];
        model.total_fee = [[dic objectForKey:@"total_fee"] floatValue];
        model.item_id = [dic objectForKey:@"item_id"];
        model.pic_path = [dic objectForKey:@"pic_path"];
        model.sku_name = [dic objectForKey:@"sku_name"];
        model.ID = [[dic objectForKey:@"id"] intValue];
        model.buyer_id = [[dic objectForKey:@"buyer_id"] intValue];
        allPrice += model.total_fee;
        [self.dataArray addObject:model];
    }

    self.totalPricelabel.text = [NSString stringWithFormat:@"¥%.1f", allPrice];
    [self.cartTableView reloadData];
}

- (void)downloadHistoryData{
    NSLog(@"cart Url = %@", kCart_History_URL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_History_URL]];
        if (data == nil) {
            NSLog(@"下载失败");
            return ;
        }
        
        [self performSelectorOnMainThread:@selector(fetchedHistoryCartData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedHistoryCartData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    download2 = YES;
    if (array.count > 0) {
        isEmpty = NO;
    }
    if (array.count <= 0 && download1 && isEmpty) {
        [self displayDefaultView];
    }
    
    [self.historyCarts removeAllObjects];
    for (NSDictionary *dic in array) {
        NewCartsModel *model = [NewCartsModel new];
        model.pic_path = [dic objectForKey:@"pic_path"];
        model.title = [dic objectForKey:@"title"];
        model.sku_name = [dic objectForKey:@"sku_name"];
        model.price = [[dic objectForKey:@"price"] floatValue];
        model.std_sale_price = [[dic objectForKey:@"std_sale_price"] floatValue];
        model.is_sale_out = [[dic objectForKey:@"is_sale_out"] boolValue];
        model.ID = [[dic objectForKey:@"id"] intValue];
        model.sku_id = [dic objectForKey:@"sku_id"];
        model.item_id = [dic objectForKey:@"item_id"];
        [self.historyCarts addObject:model];
    }
    
    [self.myTableView reloadData];
}


- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            NewCartsModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.cartModel= model;
            cell.delegate = self;
            cell.myImageView.layer.borderWidth = 0.5;
            cell.myImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
            cell.myImageView.layer.cornerRadius = 5;
            cell.myImageView.layer.masksToBounds = YES;
            [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[model.pic_path URLEncodedString]]];
            cell.myImageView.contentMode = UIViewContentModeScaleAspectFill;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.nameLabel.text = model.title;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", model.price];
            
            //    cell.contentView.backgroundColor = [UIColor redColor];
            cell.numberLabel.text = [NSString stringWithFormat:@"%d", model.num];
            cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", model.std_sale_price];
            
            cell.sizeLabel.text = model.sku_name;
        }
        
        
        return cell;
    } else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"ReBuyTableCell";
        
        
        ReBuyTableViewCell *cell = (ReBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (self.historyCarts.count == 0) {
            
        } else{
            
            NewCartsModel *model = [self.historyCarts objectAtIndex:indexPath.row];
            cell.cartModel= model;
            cell.delegate = self;
            cell.headImageView.layer.borderWidth = 0.5;
            cell.headImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.headImageView.layer.cornerRadius = 5;
            cell.headImageView.layer.masksToBounds = YES;
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[model.pic_path URLEncodedString]]];
            cell.headImageView.contentMode = UIViewContentModeScaleAspectFill;

            cell.delegate = self;
            cell.cartModel = model;
            cell.nameLabel.text = model.title;
            cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", model.price];
            
            cell.allPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", model.std_sale_price];
            
            cell.sizeLabel.text = model.sku_name;
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
        
//        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"BlueView" owner:nil options:nil];
//        self.blueView = views[0];
        if (self.dataArray.count == 0) {
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
            pricelabel.text = [NSString stringWithFormat:@"¥%.1f", allPrice];
            
            if (allPrice >= 150) {
                nameLabel.text = @"可使用优惠券";
            }  else {
                nameLabel.text = [NSString stringWithFormat:@"还差%.1f元可用优惠券", 150 - allPrice];
                
            }
            imageView.hidden = NO;
            
            footerView.frame = CGRectMake(0, 0, SCREENWIDTH, 50);
            footerView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
            
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
        headerView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
        
        
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 160, 34)];
        label.textColor = [UIColor colorWithR:38 G:38 B:46 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"可重新购买的商品";
       
        [headerView addSubview:label];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, SCREENWIDTH, 1)];
        lineView.backgroundColor= [UIColor colorWithR:218 G:218 B:218 alpha:1];
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
    NSLog(@"确认删除");
//    [self.myView removeFromSuperview];
//    self.frontView.hidden = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%d/delete_carts", Root_URL,deleteModel.ID];
    NSLog(@"url = %@", urlString);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    __unused NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str1);
    
    
    
    [self downloadData];
    [self downloadHistoryData];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    NSLog(@"data = %@", data);
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"dic = %@", dic);
        
       __unused NSInteger count = [[dic objectForKey:@"result"] integerValue];
        NSLog(@"count = %ld", (long)count);
       
    } else{
     
    }
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)buyOneGood{
    
    NSLog(@"至少买一个啊");
    UIView *myview = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2-120, 200, 240, 60)];
    myview.backgroundColor = [UIColor blackColor];
    myview.alpha = 0.7;
    myview.layer.cornerRadius = 8;
    UILabel *mylabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 60)];
    mylabel.text = @"客观至少买一件嘛";
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
- (void)reduceNumber:(NewCartsModel *)cartModel{
  
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%d/minus_product_carts", Root_URL, cartModel.ID];
    NSLog(@"url = %@", urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              [self downloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }
     ];

    
    
    
}
- (void)addNumber:(NewCartsModel *)cartModel{
   
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%d/plus_product_carts", Root_URL,cartModel.ID];
    NSLog(@"url = %@", urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              [self downloadData];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              //
              NSLog(@"库存不足");
              UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 80, 200, 160, 60)];
              view.backgroundColor = [UIColor blackColor];
              view.layer.cornerRadius = 8;
              UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
              label.text = @"商品库存不足";
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
              
              NSLog(@"%@", operation);
              NSLog(@"Error: %@", error.userInfo);
              NSDictionary *dic = error.userInfo;
              NSData *data = [dic objectForKey:@"com.alamofire.serialization.response.error.data"];
              __unused NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              NSLog(@"data = %@", str);
              
              [self downloadData];
        }
     ];
    
}
- (void)deleteCartView:(NewCartsModel *)cartModel{
    NSLog(@"id = %d", cartModel.ID);

    NSLog(@"删除购物车");
  //  self.frontView.hidden = NO;
//    NSArray *arrayViews = [[NSBundle mainBundle]loadNibNamed:@"ConfirmView" owner:self options:nil];
//    self.myView = [arrayViews objectAtIndex:0];
//    NSLog(@"%@",_myView );
  
//    UIButton *btn1 = self.retainBtn;
//    UIButton *btn2 = self.deleteBtn;
 
    deleteModel = cartModel;
    self.myView.frame = CGRectMake(10, 120, SCREENWIDTH - 20, 188);
        
   
//    [btn1 addTarget:self action:@selector(retainClicked) forControlEvents:UIControlEventTouchUpInside];
//    [btn2 addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
   // [self.view addSubview:_myView];
    
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
- (void)deleteClicked{
    NSLog(@"确认删除");
    [self.myView removeFromSuperview];
    self.frontView.hidden = YES;
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%d/delete_carts", Root_URL,deleteModel.ID];
    NSLog(@"url = %@", urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    __unused NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str1);
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
    } else{
     
    }
}


//
//- (void)updateYouhuiquanLabel{
//    
//}

- (IBAction)purchaseClicked:(id)sender {
    NSLog(@"购买商品");
    
    
    PurchaseViewController1 *purchaseVC = [[PurchaseViewController1 alloc] initWithNibName:@"PurchaseViewController1" bundle:nil];
    
    purchaseVC.cartsArray = self.dataArray;
    
    NSLog(@"purchase.array = %@", purchaseVC.cartsArray);
    
    [self.navigationController pushViewController:purchaseVC animated:YES];
}


- (void)reBuyAddCarts:(NewCartsModel *)model{
    NSLog(@"%d", (int)model.ID);
 
    
 
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"item_id": model.item_id,
                                 @"sku_id":model.sku_id,
                                 @"cart_id":[NSNumber numberWithInt:model.ID]                                 };
    //            self.detailsModel.skuID = selectskuID;
    NSLog(@"skuID = %@, itemID = %@", model.sku_id, model.item_id);
    
    [manager POST:kCart_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              //[self myAnimation];
              [self downloadData];
              [self downloadHistoryData];
              if (self.dataArray.count >= 18) {
                  NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
                  
                  [self.myTableView scrollToRowAtIndexPath:(indexpath) atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
              }
            
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
              label.text = @"商品库存不足";
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
          }];




    NSLog(@"重新购买了");
}


@end
