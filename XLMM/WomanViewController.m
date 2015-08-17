//
//  WomanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "WomanViewController.h"
#import "LogInViewController.h"
#import "MMClass.h"
#import "PeopleCollectionCell.h"
#import "PeopleModel.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "PurchaseViewController.h"
#import "CollectionModel.h"
#import "CollectionViewController.h"
#import "DetailsModel.h"
#define kSimpleCell @"simpleCell"

@interface WomanViewController (){
    
    NSMutableArray *_ModelListArray;
    
    
    UIActivityIndicatorView *activityIndicator;
    
    BOOL isOrder;
}

//

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *orderDataArray;


@end

@implementation WomanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _ModelListArray = [[NSMutableArray alloc] init];
    
    
    [self setInfo];
    isOrder = NO;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.backgroundColor = [UIColor clearColor];
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2);
    [self.womanCollectionView addSubview:activityIndicator];
    
   //注册信息。。。
    [self.womanCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:kSimpleCell];
    [self setLayout];
    [self downloadData];
    
}

- (void)createShoppingCart{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, SCREENHEIGHT - 60 - 8, 60, 60)];
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-gouwuche.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
    button.alpha = 0.5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 8, 22, 22)];
    view.backgroundColor = [UIColor colorWithR:232 G:79 B:136 alpha:1];
    view.userInteractionEnabled = NO;
    view.layer.cornerRadius = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    label.layer.cornerRadius = 10;
    label.userInteractionEnabled = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"55";
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [button addSubview:view];
}
- (void)cartClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
}

- (void)createGotoTopView{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 68, SCREENHEIGHT - 60 - 8, 60, 60)];
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-fanhuidingbu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoTopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
    button.alpha = 0.5;
    
}
- (void)gotoTopClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    [UIView animateWithDuration:0 animations:^{
        self.womanCollectionView.contentOffset = CGPointMake(0, 0);

    }];
}

- (void)setLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 30)/2, (SCREENWIDTH - 30)/2 + 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(8, 10, 50, 10);
    [self.womanCollectionView setCollectionViewLayout:flowLayout];
}

- (void)setInfo{

    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = @"时尚女装";
    navLabel.textColor = [UIColor colorWithR:105 G:59 B:29 alpha:1];
    navLabel.font = [UIFont boldSystemFontOfSize:30];
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
    [self downLoadWithURLString:kLADY_LIST_URL andSelector:@selector(fatchedLadyListData:)];
}

- (void)fatchedLadyListData:(NSData *)responseData{
    NSError *error;
    self.dataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
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
        
        NSLog(@"childlist = %d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        
        NSDictionary *dic2 = [dic objectForKey:@"product_model"];
        if ([dic2 class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic2;
            model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
        }
        [self.dataArray addObject:model];
    }
    [activityIndicator removeFromSuperview];
    [self.womanCollectionView reloadData];
    
    [self createShoppingCart];
    [self createGotoTopView];
}

#pragma mark -----CollectionViewDelegate----

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isOrder) {
        return self.orderDataArray.count;
    } else{
        return self.dataArray.count;
        
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCell forIndexPath:indexPath];
    if (isOrder) {
        [cell fillData:[self.orderDataArray objectAtIndex:indexPath.row]];

    } else {
        [cell fillData:[self.dataArray objectAtIndex:indexPath.row]];

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
        } else{
            [self downloadCollectionDataWithProductModel:model.productModel];
        }
    } else {
        PeopleModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            [self downloadDetailsDataWithModel:model];
        } else{
            [self downloadCollectionDataWithProductModel:model.productModel];
        }
    }
   
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
    
    MMLOG(collectionVC.collectionArray);
    [self.navigationController pushViewController:collectionVC animated:YES];
    
}


- (void)downloadCollectionDataWithProductModel:(NSDictionary *)productModel{
    NSString *urlString = [NSString stringWithFormat:@"http://youni.huyi.so/rest/v1/products/modellist/%@", [productModel objectForKey:@"id"]];
    
    MMLOG(urlString);
    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(urlString)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedModelListData:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)downloadDetailsDataWithModel:(PeopleModel *)model{
    NSString *urlString = [NSString stringWithFormat:@"%@/details", model.url];
    
    MMLOG(urlString);
    
    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(urlString)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedDetailsData:) withObject:data waitUntilDone:YES];
        
    });
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
    for (NSDictionary *dic in goodsArray) {
        NSString *size = [dic objectForKey:@"name"];
        NSString *sku = [dic objectForKey:@"id"];
        [arrayData addObject:size];
        [skuArray addObject:sku];
    }
    model.sizeArray = arrayData;
    model.skuIDArray = skuArray;
    model.itemID = [detailsInfo objectForKey:@"id"];
    MMLOG(model.sizeArray);
    MMLOG(model.skuIDArray);

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

#pragma mark  -----btnClicked:-----

- (void)login:(UIButton *)button{
    NSLog(@"登录");
    LogInViewController *loginVC = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 3) {
        NSLog(@"333");
        isOrder = NO;
        [self.womanCollectionView reloadData];
        
    } else if (sender.tag == 4){
        isOrder = YES;
     
            [self downloadOrderData];
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.backgroundColor = [UIColor clearColor];
        [activityIndicator startAnimating];
        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2);
        [self.womanCollectionView addSubview:activityIndicator];
       
        [self.womanCollectionView reloadData];
        
        
    
    }
}

- (void)fatchedOrderLadyListData:(NSData *)responseData{
    NSError *error;
    self.orderDataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
 //   MMLOG(json);
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
        
        NSLog(@"childlist = %d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        
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
    [self.womanCollectionView reloadData];
}


- (void)downloadOrderData{
    [self downLoadWithURLString:@"http://youni.huyi.so/rest/v1/products/ladylist?order_by=price" andSelector:@selector(fatchedOrderLadyListData:)];
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
