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


@interface CartViewController ()<CartViewDelegate>{
    int allPrice;
    ShoppingCartModel *deleteModel;
}



@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self downloadData];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"购物车";
    self.dataArray = [[NSMutableArray alloc] init];
    allPrice= 0;
    [self.view addSubview:self.myTableView];
    [self createInfo];
    
    
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
    
    
    self.totalPricelabel.text =[NSString stringWithFormat:@"￥"] ;

    
    // Do any additional setup after loading the view from its nib.
}

- (void)createInfo{
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    navLabel.text = @"购物车";
    navLabel.textColor = [UIColor blackColor];
    navLabel.font = [UIFont boldSystemFontOfSize:20];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 12, 18);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhui.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}

- (void)downloadData{
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
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    [self.dataArray removeAllObjects];
    NSLog(@"json = %@", json);
    allPrice = 0;
    for (NSDictionary *dic in json) {
        ShoppingCartModel *model = [ShoppingCartModel new];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"title"];
        model.price = [dic objectForKey:@"price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
        model.sizeName = [dic objectForKey:@"sku_name"];
        model.cartID = [dic objectForKey:@"id"];
        model.number = [[dic objectForKey:@"num"] integerValue];
        allPrice += model.number * [model.price integerValue];
        model.buyerID = [dic objectForKey:@"buyer_id"];
        
        [self.dataArray addObject:model];
    }
    NSLog(@"%@", self.dataArray);
    self.totalPricelabel.text = [NSString stringWithFormat:@"¥%d", allPrice];

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
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"simpleCellID";
    CartTableCellTableViewCell *cell = (CartTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CartTableCellTableViewCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    ShoppingCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.cartModel= model;
    cell.delegate = self;
    
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    
    cell.nameLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)model.number];
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
    cell.sizeLabel.text = model.sizeName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
- (void)reduceNumber:(ShoppingCartModel *)cartModel{
  
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%@/minus_product_carts", Root_URL, cartModel.cartID];
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
- (void)addNumber:(ShoppingCartModel *)cartModel{
   
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%@/plus_product_carts", Root_URL,cartModel.cartID];
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
              
              
              //7b226465 7461696c 223a22e5 9586e593 81e5ba93 e5ad98e4 b88de8b6 b3227d
             
          }
     ];
    
}
- (void)deleteCartView:(ShoppingCartModel *)cartModel{
    NSLog(@"id = %@", cartModel.cartID);

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
    self.myView.frame = CGRectMake(10, 120, SCREENWIDTH - 20, 220);
        
   
    [btn1 addTarget:self action:@selector(retainClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myView];
    
}
- (void)retainClicked{

    
    
        [self.myView removeFromSuperview];

        self.frontView.hidden = YES;
    
}
- (void)deleteClicked:(UIButton *)btn{
    NSLog(@"确认删除");
        [self.myView removeFromSuperview];
        self.frontView.hidden = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/carts/%@/delete_carts", Root_URL,deleteModel.cartID];
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

- (IBAction)purchaseClicked:(id)sender {
    NSLog(@"购买商品");
    PurchaseViewController *purchaseVC = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:nil];
    
    purchaseVC.cartsArray = self.dataArray;
    
    NSLog(@"purchase.array = %@", purchaseVC.cartsArray);
    
    [self.navigationController pushViewController:purchaseVC animated:YES];
}



@end
