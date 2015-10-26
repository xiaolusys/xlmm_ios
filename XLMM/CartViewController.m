//
//  CartViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableCellTableViewCell.h"
#import "MMClass.h"
#import "ShoppingCartModel.h"
#import "AFNetworking.h"
#import "EmptyCartViewController.h"
#import "PurchaseViewController.h"
#import "UIViewController+NavigationBar.h"
#import "NewCartsModel.h"
#import "PurchaseViewController1.h"


@interface CartViewController ()<CartViewDelegate>{
    float allPrice;
    NewCartsModel *deleteModel;
}



@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self downloadData];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"购物车";
    self.dataArray = [[NSMutableArray alloc] init];
    allPrice = 0.0f;
    [self.view addSubview:self.myTableView];
    //[self createInfo];
    
    
    
    
    [self createNavigationBarWithTitle:@"购物袋" selecotr:@selector(backBtnClicked:)];
    self.buyButton.backgroundColor = [UIColor colorWithR:245 G:166 B:35 alpha:1];
    self.buyButton.layer.borderWidth = 1;
    self.buyButton.layer.borderColor = [UIColor colorWithR:217 G:140 B:13 alpha:1].CGColor;
    self.buyButton.layer.cornerRadius = 20;
    
    NSLog(@"url = %@", kCart_Number_URL);
    NSURL *url = [NSURL URLWithString:kCart_Number_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
  
    if ([[json objectForKey:@"result"] integerValue] == 0) {
        EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
        [self.navigationController pushViewController:emptyVC animated:YES];
        return;
    }
    
    
    self.totalPricelabel.text =[NSString stringWithFormat:@" "] ;

    
    // Do any additional setup after loading the view from its nib.
}

//- (void)createInfo{
//    
//    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    navLabel.text = @"购物车";
//    navLabel.textColor = [UIColor blackColor];
//    navLabel.font = [UIFont boldSystemFontOfSize:20];
//    navLabel.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = navLabel;
//    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 12, 18);
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhui.png"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    
//    
//}

- (void)downloadData{
    NSLog(@"cart Url = %@", kCart_URL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_URL]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedCartData:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)fetchedCartData:(NSData *)responseData{
    if (responseData == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    [self.dataArray removeAllObjects];
    if (error != nil) {
        NSLog(@"error = %@", error);
        return;
    }
    NSLog(@"json = %@", json);
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
       // model.is_sale_out = [[dic objectForKey:@"is_sale_out"] boolValue];
        model.ID = [[dic objectForKey:@"id"] intValue];
        model.buyer_id = [[dic objectForKey:@"buyer_id"] intValue];
        allPrice += model.total_fee;
        [self.dataArray addObject:model];
    }
    NSLog(@"%@", self.dataArray);
    self.totalPricelabel.text = [NSString stringWithFormat:@"¥%.1f", allPrice];
    
    
    
    if (allPrice >= 150) {
        self.discountLabel.text = @"有可用优惠券";
    } else{
        self.discountLabel.text = [NSString stringWithFormat:@"差%.1f元可用优惠券", 150.0 - allPrice];
        
    }
    
    
    

    [self.cartTableView reloadData];
    
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.dataArray count] == 0) {
        return 0;
    }
    return [self.dataArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"simpleCellID";
    if (self.dataArray.count == indexPath.row) {
        NSLog(@"最后一个");
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
        
        cell.layer.borderWidth = 1;
        cell.layer.borderColor = [UIColor colorWithR:151 G:151 B:151 alpha:1].CGColor;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 120, 24)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"总金额￥%.1f",allPrice];
        [cell.contentView addSubview:label];
        
        if (allPrice - 150 >= 0) {
            
        } else {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(130, 8, 150, 24)];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = [NSString stringWithFormat:@"还差%.1f元,可用优惠券", 150 - allPrice];
            [cell.contentView addSubview:label];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 8, 35, 20)];
        imageView.image = [UIImage imageNamed:@"shopping_coupon.png"];
        [cell.contentView addSubview:imageView];
        
        
        return cell;
    }
    NSLog(@"self.dataArray.count = %ld", (long)self.dataArray.count);
    
  
    CartTableCellTableViewCell *cell = (CartTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CartTableCellTableViewCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NewCartsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.cartModel= model;
    cell.delegate = self;
    cell.myImageView.layer.borderWidth = 1;
    cell.myImageView.layer.borderColor = [UIColor colorWithR:155 G:155 B:155 alpha:1].CGColor;
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_path]];
    
    cell.nameLabel.text = model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", model.price];

    
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", model.num];
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", model.std_sale_price];
    cell.sizeLabel.text = model.sku_name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        return 300;
    }
    return 110;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        return 0;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.myTableView setEditing:editing animated:animated];
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
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str1);
    
    
    
    [self downloadData];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    NSLog(@"data = %@", data);
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"dic = %@", dic);
        
        NSInteger count = [[dic objectForKey:@"result"] integerValue];
        NSLog(@"count = %ld", (long)count);
        if (count == 0) {
            EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
            [self.navigationController pushViewController:emptyVC animated:YES];
        }
    } else{
        EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
        [self.navigationController pushViewController:emptyVC animated:YES];
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
              NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              NSLog(@"data = %@", str);
              
              [self downloadData];
        }
     ];
    
}
- (void)deleteCartView:(NewCartsModel *)cartModel{
    NSLog(@"id = %d", cartModel.ID);

    NSLog(@"删除购物车");
    self.frontView.hidden = NO;
    NSArray *arrayViews = [[NSBundle mainBundle]loadNibNamed:@"ConfirmView" owner:self options:nil];
    self.myView = [arrayViews objectAtIndex:0];
    NSLog(@"%@",_myView );
  
    UIButton *btn1 = self.retainBtn;
    UIButton *btn2 = self.deleteBtn;
     NSLog(@"%@", btn1);
     NSLog(@"%@", btn2);
    deleteModel = cartModel;
    self.myView.frame = CGRectMake(10, 120, SCREENWIDTH - 20, 188);
        
   
    [btn1 addTarget:self action:@selector(retainClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myView];
    
}
- (void)retainClicked{
    [self.myView removeFromSuperview];
    self.frontView.hidden = YES;
    
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
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str1);
    [self downloadData];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    NSLog(@"data = %@", data);
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"dic = %@", dic);
        
        NSInteger count = [[dic objectForKey:@"result"] integerValue];
        NSLog(@"count = %ld", (long)count);
        if (count == 0) {
            EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
            [self.navigationController pushViewController:emptyVC animated:YES];
        }
    } else{
        EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
        [self.navigationController pushViewController:emptyVC animated:YES];
    }
}


//
//- (void)updateYouhuiquanLabel{
//    
//}

- (IBAction)purchaseClicked:(id)sender {
    NSLog(@"购买商品");
    
    
    PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:nil];
    
    purchaseVC.cartsArray = self.dataArray;
    
    NSLog(@"purchase.array = %@", purchaseVC.cartsArray);
    
    [self.navigationController pushViewController:purchaseVC animated:YES];
}



@end
