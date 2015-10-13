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
#import "LiJiGMViewController1.h"

@interface MMDetailsViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>{
  
    
    NSDictionary *json; //详情页json数据
    
    NSArray *normalSkus; //尺码表
    NSDictionary *details;//商品参数
    NSString *skusID;  //规格id
    NSString *itemID;  //商品id
    NSString *saleTime;//上佳时间
    UIView *frontView; //完成前显示 界面
    NSTimer *timer;    // 底部定时器
    UILabel *countLabel;// 购物车label
    NSInteger goodsCount;//购物车商品数量
    
    UIButton *cartsButton;//购物车按钮
    NSString *last_created;//  最后加入购物车的时间
    NSTimer *theTimer;//  购物车定时器
    UILabel *shengyutimeLabel;// 购物车剩余时间 label
    BOOL isInfoHidden;  //
    int contentCount;
    
}


// 4张链接图片


@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (nonatomic, strong) UIView *infoView;//显示信息视图



@end

@implementation MMDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
      NSLog(@"appear");
    [super viewWillAppear:animated];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"]) {
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
            NSLog(@"%@", kCart_Number_URL);
            [self performSelectorOnMainThread:@selector(fetchedCartNumber:)withObject:data waitUntilDone:YES];
            
        });
    }
    
        
  
}


- (void)fetchedCartNumber:(NSData *)data{
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if ([dic objectForKey:@"result"] != nil) {
            goodsCount = [[dic objectForKey:@"result"] integerValue];
            NSLog(@"%ld", (long)goodsCount);
            NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
            countLabel.text = strNum;
        }
        
    } else{
        countLabel.text = @"0";
        return;
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
    [self.view addSubview:self.scrollerView];
    [self.view addSubview:self.backView];
    
    self.scrollerView.delegate = self;
    contentCount = 0;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    
    isInfoHidden = YES;
    
    self.bottomImageViewHeight.constant = SCREENWIDTH;
    self.headViewwidth.constant = SCREENWIDTH;
    self.headViewHeitht.constant = SCREENWIDTH + 50;
    //完成前的显示界面
    frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    
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
   
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhuiqianye.png"] forState:UIControlStateNormal];
    
    self.backButton.layer.cornerRadius = 22;
    [self.backButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    
     [self createCartView];
    
     [self downloadDetailsData];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    CGPoint contentOffset = scrollView.contentOffset;
  
    
    self.bottomImageView.frame = CGRectMake(0, 0, SCREENWIDTH , SCREENWIDTH);

    if (contentOffset.y<0) {
        CGFloat sizeheight = SCREENWIDTH - contentOffset.y;
        self.bottomImageViewHeight.constant = sizeheight;
        self.imageleading.constant = contentOffset.y/2;
        self.imageTrailing.constant = contentOffset.y/2;
    }
    if (contentOffset.y >= 0 && contentOffset.y < SCREENWIDTH) {
        NSLog(@"");
        //上拉 headImageView
        
        self.imageViewTop.constant = -contentOffset.y/3;
        self.imageBottom.constant = contentOffset.y/3;
    }
}



- (void)backClicked:(UIButton *)button{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ( self.navigationController.viewControllers.count == 1) {
        return NO;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    } else {
        return YES;
    }
   
}
- (void)downloadDetailsData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]];
        NSLog(@"details url = %@", self.urlString);
        [self performSelectorOnMainThread:@selector(fetchedDetailsData:)withObject:data waitUntilDone:YES];
        
    });
    
}
- (void)fetchedDetailsData:(NSData *)data{
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
    
    
    [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic_path"]]];
    
    
    NSLog(@"imageFrame = %@", NSStringFromCGRect(self.bottomImageView.frame));
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"agent_price"]];
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"std_sale_price"]];
    self.bianhao.text = [dic objectForKey:@"outer_id"];
    self.mingcheng.text = [dic objectForKey:@"name"];
    itemID = [dic objectForKey:@"id"];
    normalSkus = [dic objectForKey:@"normal_skus"];
    details = [dic objectForKey:@"details"];
    saleTime = [dic objectForKey:@"sale_time"];
    
  [frontView removeFromSuperview];
    
    
    [self createSizeView];
    [self createDetailsView];
    [self createContentView];
    
    cartsButton.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    [self setTime];
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
    countLabel.text = @"0";
    countLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:countLabel];
    [cartsButton addSubview:view];
    cartsButton.hidden = YES;
}
- (void)cartClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    if (goodsCount == 0) {
        NSLog(@"购物车为空");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的购物车为空\n请先加入购物车~" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
   
}
    


- (void)setTime{
 
    int year = [[saleTime substringWithRange:NSMakeRange(0, 4)]intValue];
    int month = [[saleTime substringWithRange:NSMakeRange(5, 2)]intValue];
    int day = [[saleTime substringWithRange:NSMakeRange(8, 2)] intValue];

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
    NSLog(@"contentImgs = %@", imageArray);
    __block float origineY = 0.0;
    __block float imagewidth = 0.0;
    __block float imageHeight = 0.0;
    
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<imageArray.count; i++) {
        
        UIImageView *imageview = [[UIImageView alloc] init];
        
        [imageview sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            imagewidth = SCREENWIDTH;
            
            if (image.size.width == 0) {
                imageHeight = 0;
                NSLog(@"图片的宽度为0。");
            } else {
            imageHeight = image.size.height/image.size.width * SCREENWIDTH;
            }
            [heights addObject:[NSNumber numberWithFloat:imageHeight]];
          
            NSLog(@"imagewidth = %f, imageheight = %f", imagewidth, imageHeight);
            NSLog(@"contentCount = %d", contentCount);
            
            if (contentCount == 0) {
                origineY = 0;
            } else {
                origineY += [[heights objectAtIndex:(contentCount-1)] floatValue];
            }
            contentCount++;
            
            NSLog(@"origineY = %f", origineY);
            
            imageview.frame = CGRectMake(0, origineY, imagewidth, imageHeight);
            
            self.contentViewHeight.constant = origineY + imageHeight;
            
        }];
        
        [self.contentView addSubview:imageview];
        
      
    }
    
  

}

- (void)createDetailsView{
    self.caizhi.text = [details objectForKey:@"material"];
    self.yanse.text = [details objectForKey:@"color"];
     self.beizhu.text = [details objectForKey:@"note"];
     self.shuoming.text = [details objectForKey:@"wash_instructions"];
    
}
// 可选尺码。。。
- (void)createSizeView{
    int sizeCount = (int)normalSkus.count;
    float height = 52;
    if (sizeCount%3 == 0) {
        height = 8;
    }
    self.sizeViewHeight.constant = 20 + 44*(int)(sizeCount/3)+height;
    NSLog(@"height = %f",20 + 44*sizeCount/3+height);
    for (int i = 0; i<sizeCount; i++) {
        NSLog(@"%D", i);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 *105+5,20 + i/3 *48, 100, 44)];
        button.tag = i + 100;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
       // button settit
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1];
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        //[button.layer setCornerRadius:8];
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self.sizeView addSubview:button];
        self.sizeView.backgroundColor = [UIColor whiteColor];
    }
    for (int i = 0; i<sizeCount; i++) {
        UIButton *button = (UIButton *)[self.sizeView viewWithTag:i + 100];
        NSDictionary *dic = [normalSkus objectAtIndex:i];
        NSLog(@"%@", dic);
        NSLog(@"%d", (int)button.tag);
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
      
        
        
        if (![[json objectForKey:@"is_saleopen"]boolValue]) {
            [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
            button.userInteractionEnabled = NO;
        } else{
            if ([[dic objectForKey:@"is_saleout"]boolValue]) {
                [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
                button.userInteractionEnabled = NO;
            }
        }
        
    }
    //  [self createInfoView];
    
    [self createSizeTable];
}

- (void)createSizeTable{
    NSInteger width = 0;
    NSInteger height;
    NSMutableArray *mutableSize = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *mutableSizeName = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (NSDictionary *dic in normalSkus) {
        // NSLog(@"dic = %@", dic);
        
        id object = [[dic objectForKey:@"size_of_sku"] objectForKey:@"result"];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic2 = (NSDictionary *)object;
            [mutableSize addObject:dic2];
            [mutableSizeName addObject:[dic objectForKey:@"name"]];
            NSInteger result = dic2.count;
            width = result;
            NSLog(@"result = %ld", (long)result);
        }
    }
    
        
    
    NSLog(@"mutable = %@", mutableSize);
    NSLog(@"mutable = %@", mutableSizeName);
    if (mutableSize.count != 0) {
        
    
    height = normalSkus.count;
    self.sizeTableHeight.constant = (height + 1)*24;
    self.sizeTableView.backgroundColor = [UIColor whiteColor];
    CGRect parentFrame = self.sizeTableView.frame;
  
    NSInteger sizewidth = parentFrame.size.width/(width +1);
    NSInteger sizeHeight = 24;
    
    NSInteger viewWidth = sizewidth * (width +1);
    NSInteger viewHeight = sizeHeight * (height +1);
    
    //1.画线
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, sizeHeight)];
    view1.backgroundColor = [UIColor lightGrayColor];
    [self.sizeTableView addSubview:view1];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, sizewidth, viewHeight)];
    view2.backgroundColor = [UIColor lightGrayColor];
    [self.sizeTableView addSubview:view2];
    
    for (int i = 1; i<height+2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sizeHeight*i , viewWidth, 0.5)];
        if (i == 1) {
            line.backgroundColor = [UIColor redColor];
            CGRect rect = line.frame;
            rect.size.height = 1;
            line.frame = rect;
        }else{
            line.backgroundColor = [UIColor grayColor];
        }
        [self.sizeTableView addSubview:line];
        
    }
    for (int i = 1; i<width+2; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(sizewidth*i, 0 , 0.5, viewHeight)];
        if (i == 1) {
            line.backgroundColor = [UIColor redColor];
            CGRect rect = line.frame;
            rect.size.width = 1;
            line.frame = rect;
        }else{
            line.backgroundColor = [UIColor grayColor];
        }
        [self.sizeTableView addSubview:line];
        
    }
    
    
    //2.填数据
    
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sizewidth, sizeHeight)];
    label0.text = @"尺码";
    label0.font = [UIFont systemFontOfSize:14];
    label0.backgroundColor = [UIColor clearColor];
    label0.textColor = [UIColor darkGrayColor];
    label0.textAlignment = NSTextAlignmentCenter;
    [self.sizeTableView addSubview:label0];
    for (int i = 1; i<=height; i++) {
        UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(0, sizeHeight * i, sizewidth, sizeHeight)];
        label0.text = [mutableSizeName objectAtIndex:i-1];
        label0.font = [UIFont systemFontOfSize:12];
        label0.backgroundColor = [UIColor clearColor];
        label0.textColor = [UIColor darkGrayColor];
        label0.textAlignment = NSTextAlignmentCenter;
        [self.sizeTableView addSubview:label0];
    }
    NSArray *diction = [[mutableSize lastObject] allKeys];
    
    NSLog(@"diction = %@", diction);
    
//    [[mutableSize lastObject] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSLog(@"key = %@ and obj = %@", key, obj);
//    }];
    
    
        for (int i = 1; i<=width; i++) {
            
            UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(sizewidth * i, 0, sizewidth, sizeHeight)];
            label0.text = [diction objectAtIndex:i-1];
            label0.font = [UIFont systemFontOfSize:12];
            label0.backgroundColor = [UIColor clearColor];
            label0.textColor = [UIColor darkGrayColor];
            label0.textAlignment = NSTextAlignmentCenter;
            [self.sizeTableView addSubview:label0];
        }
   
    for (int i = 1; i<=height; i++) {
        for (int j = 1; j<=width; j++) {
            NSDictionary *sizedic = [mutableSize objectAtIndex:i-1];
            
            UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(sizewidth * j, sizeHeight *i, sizewidth, sizeHeight)];
            label0.text = [sizedic objectForKey:[diction objectAtIndex:j-1]];
            label0.font = [UIFont systemFontOfSize:12];
            label0.backgroundColor = [UIColor clearColor];
            label0.textColor = [UIColor darkGrayColor];
            label0.textAlignment = NSTextAlignmentCenter;
            [self.sizeTableView addSubview:label0];
        }
    }
    }
    
}

//点击按钮显示提示信息。。。。


- (void)btnClicked:(UIButton *)button{
    NSLog(@"button.tag = %ld", (long)button.tag);
    for (int i = 100; i<100+normalSkus.count; i++) {
        if (button.tag == i) {
            [button.layer setBorderColor:[UIColor redColor].CGColor];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            skusID = [[normalSkus objectAtIndex:i-100] objectForKey:@"id"];
            
            
//            if (self.infoView.isHidden == isInfoHidden) {
//                self.infoView.hidden = NO;
//            } else {
//                self.infoView.hidden = YES;
//            }
       
            
            
            
            
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

//- (void)createInfoView{
//    self.infoView = [[UIView alloc] initWithFrame:CGRectMake(10, -50, SCREENWIDTH-20, 60)];
//    self.infoView.backgroundColor = [UIColor orangeColor];
//    [self.sizeView addSubview:self.infoView];
//    self.infoView.hidden = YES;
//    
//}


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
    NSLog(@"islogin = %d", islogin);
    if (islogin == NO) {
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
        
    }
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
}

- (void)myAnimation{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH/2 , SCREENHEIGHT - 44, 16, 16)];
    //view.backgroundColor = [UIColor colorWithR:250 G:172 B:20 alpha:1];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 8;
    [self.view addSubview:view];
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
    ani.duration=0.7;
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
        if ([theTimer isValid]) {
            [theTimer invalidate];
            
        }
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
            LiJiGMViewController1 *lijiVC = [[LiJiGMViewController1 alloc] initWithNibName:@"LiJiGMViewController1" bundle:nil];
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
- (IBAction)backqianye:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
