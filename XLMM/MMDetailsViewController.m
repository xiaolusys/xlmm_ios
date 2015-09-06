//
//  MMDetailsViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "MMDetailsModel.h"
#import "UIImage+ImageWithUrl.h"
#import "UIColor+RGBColor.h"
#import "MMClass.h"
#import "CartViewController.h"
#import "EmptyCartViewController.h"
#import "EnterViewController.h"
#import "AFNetworking.h"
#import "LiJiGMViewController.h"



#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface MMDetailsViewController (){
    
    NSArray *normalSkus;
    NSDictionary *details;
   // NSString *bianhao;
    
    
    NSString *skusID;
    NSString *itemID;
    NSString *saleTime;
    
    UIView *frontView;
    NSTimer *timer;
    
    UILabel *countLabel;
    NSInteger goodsCount;
    
    NSDictionary *json;
    UIButton *cartsButton;
    
    NSString *last_created;
    NSTimer *theTimer;
    UILabel *shengyutimeLabel;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imageview1;

@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end

@implementation MMDetailsViewController

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
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.headViewwidth.constant = SCREENWIDTH;
    self.headViewHeitht.constant = SCREENWIDTH + 40;
    frontView = [[UIView alloc] initWithFrame:self.view.frame];
    frontView.backgroundColor = [UIColor whiteColor];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(SCREENWIDTH/2-40, 200, 80, 80);
    [indicatorView startAnimating];
    [frontView addSubview:indicatorView];
    [self.view addSubview:frontView];
    
    self.title = @"商品详情";
    NSLog(@"%@", self.urlString);
    
    [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/kexuanchima.png"]];
    [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/xuanchuan.png"]];
    [self.imageView3 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/shangpincanshu.png"]];
    [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/chimabiao.png"]];
   
    
    
     [self downloadData];
    
}



- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_urlString]];
        [self performSelectorOnMainThread:@selector(fetchedCollectionData:)withObject:data waitUntilDone:YES];
        
    });
    
}
- (void)fetchedCollectionData:(NSData *)data{
    if (data == nil) {
        NSLog(@"urlstring = %@", _urlString);
        NSLog(@"集合页面数据下载失败");
        [frontView removeFromSuperview];
        return;
    }
    NSError *error;
   // [self.dataArray removeAllObjects];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    json = dic;
    
    NSLog(@"details data = %@", dic);
    
    itemID = [dic objectForKey:@"id"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic_path"]]];
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"agent_price"]];
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"std_sale_price"]];
    
    normalSkus = [dic objectForKey:@"normal_skus"];
    NSLog(@"normal_skus = %@", normalSkus);
    
    details = [dic objectForKey:@"details"];
    saleTime = [dic objectForKey:@"sale_time"];
    NSLog(@"details = %@", details);
    
    self.bianhao.text = [dic objectForKey:@"outer_id"];
    self.mingcheng.text = [dic objectForKey:@"name"];
   //sizeCount = 20;
    
    [self createSizeView];
    [self createDetailsView];
   
   
    [self createContentView];

    
    [frontView removeFromSuperview];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    [self setTime];
    
    [self createCartView];
    
}

- (void)createCartView{
    cartsButton = [[UIButton alloc] initWithFrame:CGRectMake(2, SCREENHEIGHT - 90, 44, 44)];
    cartsButton.layer.cornerRadius = 22;
    [self.view addSubview:cartsButton];
    //[cartsButton setBackgroundImage:[UIImage imageNamed:@"icon-gouwuche.png"] forState:UIControlStateNormal];
    cartsButton.backgroundColor = [UIColor blackColor];
    
    shengyutimeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 44, 44)];
    shengyutimeLabel.text = @"20:00";
    shengyutimeLabel.textColor = [UIColor whiteColor];
    shengyutimeLabel.textAlignment = NSTextAlignmentCenter;
    shengyutimeLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"shijian = %@", last_created);
    shengyutimeLabel.hidden = YES;
    [cartsButton addSubview:shengyutimeLabel];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-gouwuche.png"]];
    imageview.frame = CGRectMake(0, 0, 44, 44);
    [cartsButton addSubview:imageview];
    
    [cartsButton addTarget:self action:@selector(cartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:cartsButton];
    cartsButton.alpha = 0.5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 6, 18, 18)];
    view.backgroundColor = [UIColor colorWithR:232 G:79 B:136 alpha:1];
    view.userInteractionEnabled = NO;
    view.layer.cornerRadius = 10;
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    countLabel.layer.cornerRadius = 9;
    countLabel.userInteractionEnabled = NO;
    countLabel.font = [UIFont systemFontOfSize:10];
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
    [cartsButton addSubview:view];
}
- (void)cartClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    
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
    


- (void)setTime{
    //     "sale_time": "2015-09-05",
   // NSRange rang
    int year = [[saleTime substringWithRange:NSMakeRange(0, 4)]intValue];
    int month = [[saleTime substringWithRange:NSMakeRange(5, 2)]intValue];
    int day = [[saleTime substringWithRange:NSMakeRange(8, 2)] intValue];
   // NSLog(@"%d-%02d-%02d", year, month, day);
    
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
 
   
    
    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:day + 1];
    [endTime setHour:14];
    [endTime setMinute:0];
    [endTime setSecond:0];
    
    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;

        string = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour], (long)[d minute], (long)[d second]];
  
   
    
    self.timeLabel.text = string;


    
}

- (void)createContentView{
    NSArray *imageArray = [details objectForKey:@"content_imgs"];
    NSLog(@"imageUlrs = %@", imageArray);
    NSInteger height = 0;
    float imageheight [imageArray.count];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<imageArray.count; i++) {
        UIImage *image = [UIImage imagewithURLString:[imageArray objectAtIndex:i]];

        imageheight[i] = image.size.height/image.size.width * SCREENWIDTH;
        
        height += imageheight[i];
        [images addObject:image];
    }
    self.contentViewHeight.constant = height;
    for (int i = 0; i<imageArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[images objectAtIndex:i]];
        float yheight = 0;
        if (i ==0) {
            yheight = 0;
        }else{
            for (int j = 0; j<i; j++) {
                yheight = yheight +imageheight[j];
            }
        }
       
        imageview.frame = CGRectMake(0, yheight, SCREENWIDTH, imageheight[i]);
        [self.contentView addSubview:imageview];
        
    
    }
}

- (void)createDetailsView{
    self.caizhi.text = [details objectForKey:@"material"];
    self.yanse.text = [details objectForKey:@"color"];
     self.beizhu.text = [details objectForKey:@"note"];
     self.shuoming.text = [details objectForKey:@"wash_instructions"];
    
}

- (void)createSizeView{
    NSInteger sizeCount = normalSkus.count;
    self.sizeViewHeight.constant = 20 + 44*sizeCount/3+50;
    
    for (int i = 0; i<sizeCount; i++) {
        NSLog(@"%D", i);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 *105+5,20 + i/3 *48, 100, 44)];
        button.tag = i + 100;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
       // button settit
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:2.0];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        //[button.layer setCornerRadius:8];
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self.sizeView addSubview:button];
        
    }
    for (int i = 0; i<sizeCount; i++) {
        UIButton *button = (UIButton *)[self.sizeView viewWithTag:i + 100];
        NSDictionary *dic = [normalSkus objectAtIndex:i];
        NSLog(@"%@", dic);
        NSLog(@"%d", (int)button.tag);
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        if ([[dic objectForKey:@"is_saleout"]boolValue]) {
            [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
            button.userInteractionEnabled = NO;
        }
        
        
        if (![[json objectForKey:@"is_saleopen"]boolValue]) {
            [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
            button.userInteractionEnabled = NO;
        }
        
    }
}

- (void)btnClicked:(UIButton *)button{
    NSLog(@"button.tag = %ld", (long)button.tag);
    for (int i = 100; i<100+normalSkus.count; i++) {
        if (button.tag == i) {
            [button.layer setBorderColor:[UIColor redColor].CGColor];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            skusID = [[normalSkus objectAtIndex:i-100] objectForKey:@"id"];
            
            NSLog(@"skus_id = %@ and item_id = %@", skusID, itemID);
            
            
            
        }else{
            UIButton *btn = (UIButton *)[self.sizeView viewWithTag:i];
            if ([btn isUserInteractionEnabled]) {
                [btn.layer setBorderColor:[UIColor grayColor].CGColor];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    
    
    
    
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

- (IBAction)addCartBtnClicked:(id)sender {
    NSLog(@"加入购物车");
    
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin) {
        if (skusID == nil) {
            [UIView animateWithDuration:.5f animations:^{
                self.scrollerView.contentOffset = CGPointMake(0, 0);
                
            } completion:^(BOOL finished) {
                NSLog(@"top");
            }];
            
            __block UIView *view;
            
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
            view.center = self.view.center;
            [UIView animateWithDuration:3.0 animations:^{
                
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 30)];
                label.text = @"请选择正确的商品尺寸";
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:24];
                [view addSubview:label];
                view.layer.cornerRadius = 6;
                [self.view addSubview:view];
                NSLog(@"tips");
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                NSLog(@"finish");
            }];
            
        } else{
            NSLog(@"加入购物车");
            
            //                sku_id;
            //                item_id;
            //                http://youni.huyi.so/rest/v1/carts
            NSLog(@"item_id = %@", itemID);
            NSLog(@"sku_id = %@", skusID);
            
            
          
            
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            
            
            NSDictionary *parameters = @{@"item_id": itemID,
                                         @"sku_id":skusID};
//            self.detailsModel.skuID = selectskuID;
            [manager POST:kCart_URL parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      NSLog(@"JSON: %@", responseObject);
                      
                      [self myAnimation];
                      
                   
                      
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
            
            
            
        }
    }else{
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
    

}

- (void)myAnimation{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 , SCREENHEIGHT - 44, 16, 16)];
    //view.backgroundColor = [UIColor colorWithR:250 G:172 B:20 alpha:1];
    
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 8;
    [self.view addSubview:view];
   // [self.view sendSubviewToBack:view];
    CGFloat width = SCREENWIDTH;
    CGFloat height = SCREENHEIGHT;
    
    CAKeyframeAnimation *ani=[CAKeyframeAnimation animation];
    //初始化路径
    CGMutablePathRef aPath=CGPathCreateMutable();
    //动画起始点
    CGPathMoveToPoint(aPath, nil, width/2, height - 50);
    CGPathAddCurveToPoint(aPath, nil,
                          width/2 - 50 , height - 120,//控制点
                          width/2  - 100, height - 150,//控制点
                          20, height - 60
                          );//控制点
    
    ani.path=aPath;
    ani.rotationMode = @"auto";
    ani.duration=0.6;
    //设置为渐出
    ani.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [view.layer addAnimation:ani forKey:@"position"];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        view.bounds = CGRectMake(0, 0, 12, 12);
         view.alpha = 0.9;
         //view.frame = CGRectMake(30, height-80, 16, 16);
     } completion:^(BOOL finished) {
        
         [view removeFromSuperview];
         NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
         if (data != nil) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
             
             NSLog(@"%@", dic);
             if ([dic objectForKey:@"result"] != nil) {
                 
                 last_created = [dic objectForKey:@"last_created"];
                 goodsCount = [[dic objectForKey:@"result"] integerValue];
                 NSLog(@"%ld", (long)goodsCount);
                 NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
                 countLabel.text = strNum;
             }
         }
         
         [self createTimeCartView];
         
         
     }];
}

- (void)createTimeCartView{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@", dic);
        if ([dic objectForKey:@"result"] != nil) {
            
            last_created = [dic objectForKey:@"last_created"];
            goodsCount = [[dic objectForKey:@"result"] integerValue];
            NSLog(@"%ld", (long)goodsCount);
            NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
            countLabel.text = strNum;
        }
    }

    [UIView animateWithDuration:0.5 animations:^{
        cartsButton.frame = CGRectMake(2, SCREENHEIGHT - 90, 100, 44);
    } completion:^(BOOL finished) {
        NSLog(@"显示剩余时间");
        [self createTimeLabel];
        
    }];
}

- (void)createTimeLabel{
    shengyutimeLabel.hidden = NO;
    
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
    shengyutimeLabel.text = string;
    
}




- (IBAction)buyBtnClicked:(id)sender {
    NSLog(@"立即购买");
    
    NSLog(@"立即购买");
    BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:kIsLogin];
    if (islogin) {
        if (skusID == nil) {
            [UIView animateWithDuration:.5f animations:^{
                self.scrollerView.contentOffset = CGPointMake(0, 0);
                
            } completion:^(BOOL finished) {
                NSLog(@"top");
            }];
            __block UIView *view;
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
            
            view.center = self.view.center;
            
            [UIView animateWithDuration:3.0 animations:^{
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 280, 30)];
                label.text = @"请选择正确的商品尺寸";
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:24];
                [view addSubview:label];
                view.layer.cornerRadius = 6;
                [self.view addSubview:view];
                NSLog(@"tips");
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                NSLog(@"finish");
            }];
        } else {
            NSLog(@"可以购买");
            // 立即购买
            LiJiGMViewController *lijiVC = [[LiJiGMViewController alloc] initWithNibName:@"LiJiGMViewController" bundle:nil];
            NSLog(@"skuid = %@", skusID);
            lijiVC.skuID = skusID;
            lijiVC.itemID = itemID;
            NSLog(@"lijiVC.skuID = %@", lijiVC.skuID);
            NSLog(@"lijiVC.itemID = %@", lijiVC.itemID);
            [self.navigationController pushViewController:lijiVC animated:YES];
        }
        
    } else{
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
}
@end
