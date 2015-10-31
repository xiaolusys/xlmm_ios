 //
//  EmptyCartViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "EmptyCartViewController.h"
#import "MMClass.h"
#import "CartModel.h"
#import "CartCollectionCell.h"
#import "AFNetworking.h"
#import "MMCartsView.h"
#import "CartViewController.h"
#import "HistoryCartsModel.h"

@interface EmptyCartViewController (){
    MMCartsView *singleton; //购物车视图
    NSString *last_created; //最后加入购物车的时间
    NSString *result;       //购物车数量
    UIButton *cartsButton;  //购物车点击按钮
    UILabel *cartsTimeLabel;//购物车倒计时
    NSTimer *theTimer;      //定时器
}


@property (nonatomic, copy)NSArray *dataArray;


@end

@implementation EmptyCartViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updataNumberLabel];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if ([theTimer isValid]) {
        [theTimer invalidate];
        NSLog(@"销毁定时器");
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
   
    [self createCollectionView];
    
    [self createCartsView];
    
    [self downloadData];
    
}

- (void)createCollectionView{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 56, SCREENWIDTH, SCREENHEIGHT - 120) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    [self.myCollectionView registerClass:[CartCollectionCell class] forCellWithReuseIdentifier:@"cartCell"];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = YES;
    self.myCollectionView.multipleTouchEnabled = YES;  
    [self.view addSubview:[[UIView alloc] init]];
    [self.view addSubview:self.myCollectionView];
}

- (void)createCartsView{
    singleton = [MMCartsView sharedCartsView];
    
    singleton.cartsView.frame = CGRectMake(8, SCREENHEIGHT - 58, 50, 50);
    singleton.cartsView.alpha = 0.7;
    
    NSLog(@"url = %@", kCart_Number_URL);
    NSURL *url = [NSURL URLWithString:kCart_Number_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    last_created = [json objectForKey:@"last_created"];
    result = [json objectForKey:@"result"];
    cartsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    cartsButton.frame = singleton.cartsView.frame;
    [cartsButton addTarget:self action:@selector(cartViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    cartsButton.backgroundColor = [UIColor clearColor];
   
//    cartsButton.backgroundColor = [UIColor redColor];
    cartsTimeLabel = [[UILabel alloc] init];
    cartsTimeLabel.frame = singleton.cartsView.frame;
    CGRect timeLabelRect = cartsTimeLabel.frame;
    timeLabelRect.origin.x += 44;
    cartsTimeLabel.frame = timeLabelRect;
    cartsTimeLabel.textAlignment = NSTextAlignmentCenter;
    cartsTimeLabel.text = @"";
    cartsTimeLabel.textColor = [UIColor redColor];
    cartsTimeLabel.font = [UIFont systemFontOfSize:18];
    cartsTimeLabel.hidden = YES;
    [self.view addSubview:singleton.cartsView];
    [self.view addSubview:cartsButton];
    [self.view addSubview:cartsTimeLabel];
}

- (void)cartViewClicked:(UIButton *)button{
    NSLog(@"进入购物车");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_History_URL]];
        NSLog(@"%@", kCart_History_URL);
        [self performSelectorOnMainThread:@selector(fetchedHistoryData:)withObject:data waitUntilDone:YES];
    });
}

- (void)createDefaultView{
    singleton.cartsView.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 328/2, 382/2);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    CGRect rect = imageView.frame;
    rect.origin.y = 50;
    imageView.frame = rect;
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    
    label1.font = [UIFont systemFontOfSize:18];
    label1.text = @"您的购物车还是空的";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = self.view.center;
    
    CGRect labelrect = label1.frame;
    labelrect.origin.y = 250;
    label1.frame = labelrect;
    
    
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label2.font = [UIFont systemFontOfSize:18];
    label2.text = @"去首页逛逛吧~~";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = self.view.center;
    
    CGRect labelFram = label2.frame;
    labelFram.origin.y = 280;
    label2.frame = labelFram;
    
    [self.view addSubview:label2];
    
    self.frontLabel.hidden = YES;
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void)fetchedHistoryData:(NSData *)data{
   
    if (data == nil) {
        NSLog(@"历史购物车为空");
        
        [self createDefaultView];
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
     NSLog(@"data = %@", array);
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *dic in array) {
        HistoryCartsModel *model = [HistoryCartsModel new];
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
        model.is_sale_out = [[dic objectForKey:@"is_sale_out"] boolValue];
        model.ID = [[dic objectForKey:@"id"] intValue];
        model.buyer_id = [[dic objectForKey:@"buyer_id"] intValue];
        [mutableArray addObject:model];
    }
    
    self.dataArray = [[NSArray alloc] initWithArray:mutableArray];
    
    NSLog(@"dataArray = %@", self.dataArray);
    
    
    if (self.dataArray.count == 0) {
        NSLog(@"您的购物车为空！");
        [self createDefaultView];
        
        
    } else {
        self.frontLabel.hidden = NO;
        [self.myCollectionView reloadData];

    }
    
}


#pragma mark --CollectionViewDelegate--


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENWIDTH, 108);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CartCollectionCell *cell = (CartCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cartCell" forIndexPath:indexPath];
   // cell.backgroundColor = [UIColor redColor];
    HistoryCartsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.pic_path]];
    cell.nameLabel.text = model.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%.1f", model.price];
    cell.allPriceLabel.text = [NSString stringWithFormat:@"￥%.0f", model.std_sale_price];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@", model.sku_name];
    [cell.mybutton addTarget:self action:@selector(reBuyClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.mybutton.tag = indexPath.row + 1000;
    
    if (model.is_sale_out) {
        cell.mybutton.enabled = NO;
        [cell.mybutton setTitle:@"已抢光" forState:UIControlStateNormal];
        [cell.mybutton setTitleColor:[UIColor colorWithR:218 G:218 B:218 alpha:1] forState:UIControlStateNormal];
        [cell.mybutton.layer setBorderWidth:1.0];
        [cell.mybutton.layer setBorderColor:[UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor];
        
    } else {
        cell.mybutton.enabled = YES;
        [cell.mybutton setTitle:@"重新购买" forState:UIControlStateNormal];
        [cell.mybutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell.mybutton.layer setBorderWidth:1.0];
        [cell.mybutton.layer setBorderColor:[UIColor redColor].CGColor];
    }
    
    return cell;
}


- (void)reBuyClicked:(UIButton *)button{
    NSLog(@"重新购买");
    NSLog(@"button.tag = %ld", (long)button.tag);
    CartModel *model = [self.dataArray objectAtIndex:(button.tag - 1000)];
    
    NSLog(@"itemid = %@, skuid = %@", model.item_id, model.sku_id);
    //重新加入购物车
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"item_id": model.item_id,
                                 @"sku_id":model.sku_id};
    [self myAnimation:model andTag:button.tag - 1000];

    [manager POST:kCart_URL parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              NSLog(@"成功加入购物车");
        }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              
              NSLog(@"Error: %@", error);
              NSLog(@"error:, --.>>>%@", error.description);
              NSDictionary *dic = [error userInfo];
              NSLog(@"dic = %@", dic);
              
              
              NSLog(@"error = %@", [dic objectForKey:@"com.alamofire.serialization.response.error.data"]);
              
              NSString *str = [[NSString alloc] initWithData:[dic objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
              NSLog(@"%@",str);
              UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 - 80, 200, 160, 60)];
              view.backgroundColor = [UIColor blackColor];
              view.layer.cornerRadius = 5;
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
}

- (void)myAnimation:(CartModel *)model andTag:(NSInteger)tag{
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imagewithURLString:model.pic_path]];
    
    NSLog(@"%@",NSStringFromCGPoint(self.myCollectionView.contentOffset));
    imageview.frame = CGRectMake(SCREENWIDTH - 80, 56 + 112 *tag - self.myCollectionView.contentOffset.y, 80, 80);
    [self.view addSubview:imageview];
    [imageview.layer setMasksToBounds:YES];
    [imageview.layer setBorderWidth:0.5];
    imageview.layer.cornerRadius = 8;
    [imageview.layer setBorderColor:[UIColor colorWithR:155 G:155 B:155 alpha:1].CGColor];

    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        imageview.frame = CGRectMake(36, SCREENHEIGHT - 48, 10, 10);
        
    } completion:^(BOOL finished) {
        NSLog(@"完成加入购物车");
        [imageview removeFromSuperview];
        [self updataNumberLabel];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = singleton.cartsView.frame;
            rect.size.width = 100;
            singleton.cartsView.frame = rect;
            [self createTimeCartView];
            
        } completion:^(BOOL finished) {
            
        }];

    }];
  
    
}


- (void)createTimeCartView{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@", dic);
        if ([dic objectForKey:@"result"] != nil) {
            
            last_created = [dic objectForKey:@"last_created"];
          
           
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        cartsButton.frame = CGRectMake(8, SCREENHEIGHT - 58, 100, 50);
    } completion:^(BOOL finished) {
        NSLog(@"显示剩余时间");
        [self createTimeLabel];
        
    }];
}

- (void)createTimeLabel{
    cartsTimeLabel.hidden = NO;
    
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}
- (void)timerFireMethod:(NSTimer*)thetimer
{
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[last_created doubleValue]];
    // NSLog(@"%@", lastDate);
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    
    NSDateComponents *d = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date] toDate:lastDate options:0];
    
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)[d minute], (long)[d second]];
    NSLog(@"string = %@", string);
    if ([string isEqualToString:@"00:00"]) {
        string = @"00:00";
        [theTimer invalidate];
    }
    cartsTimeLabel.text = string;
    
}
- (void)updataNumberLabel{
    
    NSLog(@"url = %@", kCart_Number_URL);
    NSURL *url = [NSURL URLWithString:kCart_Number_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    
    last_created = [json objectForKey:@"last_created"];
    result = [json objectForKey:@"result"];
  
    
    if ([result integerValue] == 0) {
        
        cartsButton.userInteractionEnabled = NO;
        
    } else {
        cartsButton.userInteractionEnabled = YES;
    }

 
    singleton.myNumberView.text = [NSString stringWithFormat:@"%@", result];
    //   NSTimeInterval
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[last_created doubleValue]];
    NSLog(@"%@", date);
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"begin");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"cancel");
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"end");
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"moves");
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

- (IBAction)gotoHomePage:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
