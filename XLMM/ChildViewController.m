//
//  ChildViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "ChildViewController.h"
#import "LogInViewController.h"
#import "PeopleCollectionCell.h"
#import "MMClass.h"
#import "PeopleModel.h"
#import "DetailViewController.h"
#import "PurchaseViewController.h"
#import "CollectionModel.h"
#import "CollectionViewController.h"
#import "DetailsModel.h"
#import "PersonCenterViewController.h"
#import "EmptyCartViewController.h"
#import "EnterViewController.h"
#import "CartViewController.h"

#define ksimpleCell @"simpleCell"

@interface ChildViewController (){
    
    NSMutableArray *_ModelListArray;
    UIActivityIndicatorView *activityIndicator;
    BOOL isOrder;
    NSInteger goodsCount;
    UILabel *countLabel;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;

@end

@implementation ChildViewController

- (void)viewWillAppear:(BOOL)animated{
    //  NSLog(@"appear");
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSLog(@"%@", dic);
            
            
            if ([dic objectForKey:@"result"] != nil) {
                goodsCount = [[dic objectForKey:@"result"] integerValue];
                NSLog(@"%ld", (long)goodsCount);
                NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
                countLabel.text = strNum;
            }
            
        }
    }else{
        countLabel.text = @"0";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isOrder = NO;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];

    [self setInfo];
    [self setLayout];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.backgroundColor = [UIColor clearColor];
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2);
    [self.childCollectionView addSubview:activityIndicator];
    
    [self.childCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    
   
    [self downloadData];
   
 
}

- (void)setLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 30)/2, (SCREENWIDTH - 30)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 50, 10);
    [self.childCollectionView setCollectionViewLayout:flowLayout];
}

- (void)createShoppingCart{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, SCREENHEIGHT - 60 - 8, 60, 60)];
    button.layer.cornerRadius = 30;
    [button setBackgroundImage:[UIImage imageNamed:@"icon-gouwuche.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cartClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.alpha = 0.5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 8, 22, 22)];
    view.backgroundColor = [UIColor colorWithR:232 G:79 B:136 alpha:1];
    view.userInteractionEnabled = NO;
    view.layer.cornerRadius = 10;
   countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    countLabel.layer.cornerRadius = 10;
    countLabel.userInteractionEnabled = NO;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@", dic);
        if ([dic objectForKey:@"result"] != nil) {
            
       
        goodsCount = [[dic objectForKey:@"result"] integerValue];
        NSLog(@"%ld", (long)goodsCount);
        NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
        countLabel.text = strNum;
        }
    }
    countLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:countLabel];
    [button addSubview:view];
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];

}
- (void)cartClicked:(UIButton *)btn{
    NSLog(@"进入购物车");
    
    NSLog(@"gouguche ");
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        if (goodsCount > 0) {
            CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
            [self.navigationController pushViewController:cartVC animated:YES];
        } else{
            NSLog(@"购物车为空");
            EmptyCartViewController *emptyVC = [[EmptyCartViewController alloc] initWithNibName:@"EmptyCartViewController" bundle:nil];
            [self.navigationController pushViewController:emptyVC animated:YES];
            
        }
        
    } else{
        NSLog(@"请您先登录");
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }


}

- (void)createGotoTopView{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 68, SCREENHEIGHT - 60 - 8, 60, 60)];
    button.alpha = 0.5;
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-fanhuidingbu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoTopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
    
}
- (void)gotoTopClicked:(UIButton *)btn{
    NSLog(@"返回页面首部");
    [UIView animateWithDuration:0 animations:^{
        self.childCollectionView.contentOffset = CGPointMake(0, 0);
        
    }];
}

- (void)setInfo{
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = @"潮男童装";
    navLabel.textColor = [UIColor colorWithR:105 G:59 B:29 alpha:1];
    navLabel.font = [UIFont fontWithName:@"LiHei Pro" size:28];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 29, 33);
    [rightButton setBackgroundImage:LOADIMAGE(@"icon-gerenzhongxin.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 42, 39);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-shouye2.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

- (void)downloadData{
    [self downLoadWithURLString:kCHILD_LIST_URL andSelector:@selector(fatchedChildListData:)];
}

- (void)fatchedChildListData:(NSData *)responseData{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
   // NSLog(@"ChildList Data-->%@", json);
    if (json == nil) {
        NSLog(@"数据解析失败");
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"数据解析失败");
        return;
    }
  //  NSLog(@"childList Array = %@", array);
    
    [self.dataArray removeAllObjects];
      for (NSDictionary *dic in array) {
          PeopleModel *model = [[PeopleModel alloc] init];
          model.imageURL = [dic objectForKey:@"pic_path"];
          model.name = [dic objectForKey:@"name"];
          model.price = [dic objectForKey:@"agent_price"];
          model.oldPrice = [dic objectForKey:@"std_sale_price"];
          model.url = [dic objectForKey:@"url"];
          
          model.isSaleOpen = [[dic objectForKey:@"is_saleopen"] boolValue];
          model.isSaleOut = [[dic objectForKey:@"is_saleout"]boolValue];
          model.isNewGood = [[dic objectForKey:@"is_newgood"]boolValue];
          model.remainNumber = [[dic objectForKey:@"remain_num"]integerValue];
          
    //      NSLog(@"is_saleOpen = %d, is_saleOUt = %d, is_newGood = %d, remainNumber = %ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
          
          NSDictionary *dic2 = [dic objectForKey:@"product_model"];
          NSLog(@"procust_model = %@", dic);
          
          if ([dic2 class] == [NSNull class]) {
              model.productModel = nil;
          } else{
              model.productModel = dic2;
              model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
              model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
          }
          [_dataArray addObject:model];
    }
   // NSLog(@"dataArray = %@\n\n\n", _dataArray);
    //[activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    
    [self.childCollectionView reloadData];
    //[self.view sendSubviewToBack:self.childCollectionView];
    
    [self createGotoTopView];
    [self createShoppingCart];
}

#pragma mark  -----CollectionViewDelete----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isOrder) {
        return self.orderDataArray.count;
        
    }else{
        return self.dataArray.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (isOrder) {
        PeopleModel *orderModel = [_orderDataArray objectAtIndex:indexPath.row];
        [cell fillData:orderModel];
       
    }else{
        PeopleModel *model = [_dataArray objectAtIndex:indexPath.row];
        [cell fillData:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  if (_dataArray.count == 0) {
        return;
    }
    if (isOrder) {
        PeopleModel *model = [_orderDataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            [self downloadDetailsDataWithModel:model];
        } else {
            [self downloadCollectionDataWithProductModel:model.productModel];
        }
    } else {
        PeopleModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            [self downloadDetailsDataWithModel:model];
        } else {
            [self downloadCollectionDataWithProductModel:model.productModel];
        }
    }
    
}

- (void)downloadCollectionDataWithProductModel:(NSDictionary *)productModel{
    NSString *urlString = [NSString stringWithFormat:@"http://youni.huyi.so/rest/v1/products/modellist/%@", [productModel objectForKey:@"id"]];
    MMLOG(urlString);
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedModelListData:)];
}
- (void)fetchedModelListData:(NSData *)responseDate{
    
    NSError *error = nil;
    NSArray *modelListArray = [NSJSONSerialization JSONObjectWithData:responseDate options:kNilOptions error:&error];
    // MMLOG(modelListArray);
    [_ModelListArray removeAllObjects];
    for (NSDictionary *dic in modelListArray) {
        CollectionModel *model = [[CollectionModel alloc] init];
        model.productID = [dic objectForKey:@"id"];
        model.urlStirng = [dic objectForKey:@"url"];
        model.outerID = [dic objectForKey:@"outer_id"];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"name"];
        model.price = [dic objectForKey:@"agent_price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
        
        NSDictionary *dic2 = [dic objectForKey:@"product_model"];
        model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
        model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
        
        
        [_ModelListArray addObject:model];
    }
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    collectionVC.collectionArray = _ModelListArray;
    [self.navigationController pushViewController:collectionVC animated:YES];
    
}

- (void)downloadDetailsDataWithModel:(PeopleModel *)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/details", model.url];
    
    MMLOG(urlString);
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDetailsData:)];
}

- (void)fetchedDetailsData:(NSData *)responseData{
    NSError *error = nil;
    NSDictionary *detailsInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    MMLOG(detailsInfo);
    DetailsModel *model = [[DetailsModel alloc] init];
    model.name = [detailsInfo objectForKey:@"name"];
    model.productID = [detailsInfo objectForKey:@"outer_id"];
    model.isSaleOpen = [[detailsInfo objectForKey:@"is_saleopen"] boolValue];
    model.isSaleOut = [[detailsInfo objectForKey:@"is_saleout"] boolValue];
    model.isNewGood = [[detailsInfo objectForKey:@"is_newgood"] boolValue];
    model.remainNumber = [[detailsInfo objectForKey:@"remain_num"] integerValue];
    model.price = [NSString stringWithFormat:@"￥%@",[detailsInfo objectForKey:@"agent_price"]];
    model.oldPrice= [NSString stringWithFormat:@"￥%@", [detailsInfo objectForKey:@"std_sale_price"]];
    NSArray *goodsArray = [detailsInfo objectForKey:@"normal_skus"];
    NSMutableArray *arrayData = [[NSMutableArray alloc] init];
    NSMutableArray *skuArray = [[NSMutableArray alloc] init];
    NSMutableArray *saleOutArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in goodsArray) {
        NSString *size = [dic objectForKey:@"name"];
        [arrayData addObject:size];
        NSString *sku = [dic objectForKey:@"id"];
        [skuArray addObject:sku];
        NSString *sale = [dic objectForKey:@"is_saleout"];
        [saleOutArray addObject:sale];
    }
    model.sizeArray = arrayData;
    model.skuIDArray = skuArray;
    model.skuIsSaleOutArray = saleOutArray;
    model.itemID = [detailsInfo objectForKey:@"id"];
    MMLOG(model.sizeArray);
    MMLOG(model.skuIDArray);
    MMLOG(model.skuIsSaleOutArray);
    NSDictionary *dic2 = [detailsInfo objectForKey:@"details"];
    model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
    model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
    
    
    DetailViewController *detailsVC = [[DetailViewController alloc] init];
    detailsVC.detailsModel = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


#pragma mark ----btnClicked:----

- (void)login:(UIButton *)button{
    NSLog(@"登录");
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:kIsLogin];
    if (islogin) {
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:personVC animated:YES];
        NSLog(@"您已经登录，可以购买");
    } else{
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
        [self.navigationController pushViewController:personVC animated:YES];
        NSLog(@"您现在是游客身份，请先登录");
    }

    
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        NSLog(@"推荐排序");
        isOrder = NO;
        [self.childCollectionView reloadData];
    } else if (sender.tag == 2){
        NSLog(@"价格排序");
        isOrder = YES;
        
        [self downloadOrderData];
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.backgroundColor = [UIColor clearColor];
        [activityIndicator startAnimating];
        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2);
        [self.childCollectionView addSubview:activityIndicator];
        
        [self.childCollectionView reloadData];
    }

}

- (void)fatchedOrderLadyListData:(NSData *)responseData{
    NSError *error;
    self.orderDataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
   // MMLOG(json);
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *dic in array) {
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"name"];
        model.price = [dic objectForKey:@"agent_price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
        
        model.url = [dic objectForKey:@"url"];
        
        model.isSaleOpen = [[dic objectForKey:@"is_saleopen"] boolValue];
        model.isSaleOut = [[dic objectForKey:@"is_saleout"]boolValue];
        model.isNewGood = [[dic objectForKey:@"is_newgood"]boolValue];
        model.remainNumber = [[dic objectForKey:@"remain_num"]integerValue];
        
//        NSLog(@"childlist = %d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        
        NSDictionary *dic2 = [dic objectForKey:@"product_model"];
        if ([dic2 class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic2;
            model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
        }
        [self.orderDataArray addObject:model];
    }
     [activityIndicator removeFromSuperview];
    [self.childCollectionView reloadData];
}


- (void)downloadOrderData{
    [self downLoadWithURLString:kCHILD_LIST_ORDER_URL andSelector:@selector(fatchedOrderLadyListData:)];
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
