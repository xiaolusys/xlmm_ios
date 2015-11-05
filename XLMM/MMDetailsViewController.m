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
#import "ArrowView.h"
#import "MMSizeChartView.h"

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
    
    NSString *caizhi;
    NSString *yanse;
    NSString *beizhu;
    NSString *shuoming;
    NSArray *allSizeKeys;
    UIView *view0;
    MMSizeChartView *mmSizeChart;
    int theNumberOfSizeCanSelected;
    NSMutableArray *agentPriceArray;
    NSMutableArray *salePriceArray;
    
    NSString *offShelfTime;
    NSMutableArray *orderKeyArray;
    NSMutableArray *mutableSize;
    NSMutableArray *mutableSizeName;
    CGFloat labelWidth;
}


// 4张链接图片
@property (weak, nonatomic) IBOutlet UILabel *caizhiLabel;

@property (weak, nonatomic) IBOutlet UILabel *yanseLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageview1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;


@property (nonatomic, strong) UIView *infoView;//显示信息视图

@property (nonatomic, strong) ArrowView *popView;
@property (nonatomic, strong) NSMutableArray *popViewArray;

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
            countLabel.frame = CGRectMake(76, 0, 12, 12);
            countLabel.layer.masksToBounds = YES;
            countLabel.layer.cornerRadius = 6;
            countLabel.font = [UIFont systemFontOfSize:6];
            countLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
          //  countLabel.hidden = NO;\
            
            [cartsButton bringSubviewToFront:countLabel];
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
    self.popViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    agentPriceArray = [[NSMutableArray alloc] init];
    salePriceArray = [[NSMutableArray alloc] init];
    self.scrollerView.delegate = self;
    contentCount = 0;

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    theNumberOfSizeCanSelected = 0;
    
    allSizeKeys = @[@"领围",@"肩宽",@"胸围",@"袖长",
                    @"插肩袖",@"袖口",@"腰围",
                    @"衣长",@"裙腰",@"裤腰",
                    @"臀围",@"下摆围",@"前档",
                    @"后档",@"大腿围",@"小腿围",
                    @"脚口",@"裙长",@"裤长",
                    @"建议身高"];
    NSLog(@"keys = %@", allSizeKeys);
    isInfoHidden = YES;
    
    
    self.bottomImageViewHeight.constant = SCREENWIDTH;
    self.headViewwidth.constant = SCREENWIDTH;
    self.headViewHeitht.constant = SCREENWIDTH + 175;
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
  //  [self.imageView4 sd_setImageWithURL:[NSURL URLWithString:@"http://image.xiaolu.so/chimabiao.png"]];
   
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhuiqianye.png"] forState:UIControlStateNormal];
    
    self.backButton.layer.cornerRadius = 22;
    [self.backButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    
     [self createCartView];
    
     [self downloadDetailsData];
    self.addCartButton.layer.cornerRadius = 20;
    self.addCartButton.layer.borderWidth = 1;
    self.addCartButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    
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
    if ([[dic objectForKey:@"lowest_price"] integerValue] != [[dic objectForKey:@"lowest_price"] floatValue]) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic objectForKey:@"lowest_price"] floatValue]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"lowest_price"]];
    }
   // self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"agent_price"]];
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"std_sale_price"]];
    self.bianhao.text = [dic objectForKey:@"outer_id"];
    self.mingcheng.text = [dic objectForKey:@"name"];
    itemID = [dic objectForKey:@"id"];
    normalSkus = [dic objectForKey:@"normal_skus"];
    details = [dic objectForKey:@"details"];
    saleTime = [dic objectForKey:@"sale_time"];
    offShelfTime = [dic objectForKey:@"offshelf_time"];
  [frontView removeFromSuperview];
    self.caizhiLabel.text = [[dic objectForKey:@"details"] objectForKey:@"material"];
    self.yanseLabel.text = [[dic objectForKey:@"details"] objectForKey:@"color"];
    self.beizhuLabel.text = [[dic objectForKey:@"details"] objectForKey:@"note"];
    [self createSizeView];
    [self createDetailsView];
    [self createContentView];
    
    cartsButton.hidden = NO;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    [self setTime];
}

- (void)createCartView{
    cartsButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREENHEIGHT - 48, 40, 40)];
    
    cartsButton.layer.cornerRadius = 20;
    [self.view addSubview:cartsButton];
  
    cartsButton.backgroundColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
   // cartsButton.layer.borderWidth = 1;
   // cartsButton.layer.borderColor = [UIColor colorWithR:38 G:38 B:46 alpha:1].CGColor;
    
    
    shengyutimeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(36, 2, 44, 30)];
    shengyutimeLabel.text = @"20:00";
    shengyutimeLabel.textColor = [UIColor whiteColor];
    shengyutimeLabel.textAlignment = NSTextAlignmentCenter;
    shengyutimeLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"shijian = %@", last_created);
    shengyutimeLabel.hidden = YES;
    [cartsButton addSubview:shengyutimeLabel];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouwucheicon2.png"]];
    imageview.frame = CGRectMake(6, 8, 20, 20);
    [cartsButton addSubview:imageview];
    [cartsButton addTarget:self action:@selector(cartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:cartsButton];
    view0 = [[UIView alloc] initWithFrame:CGRectMake(26, 6, 4, 4)];
    view0.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    view0.userInteractionEnabled = NO;
    view0.layer.cornerRadius = 2;
     [cartsButton addSubview:view0];

    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    countLabel.layer.cornerRadius = 9;
    countLabel.userInteractionEnabled = NO;
    countLabel.font = [UIFont systemFontOfSize:10];
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.text = @"0";
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.hidden = YES;
    [cartsButton addSubview:countLabel];
    [cartsButton bringSubviewToFront:countLabel];
    
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
   
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
   // NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
 
   
    
//    // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
//    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
//    [endTime setYear:year];
//    [endTime setMonth:month];
//    [endTime setDay:day + 1];
//    [endTime setHour:14];
//    [endTime setMinute:0];
//    [endTime setSecond:0];
//    
//    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    NSDate *todate;
    if ([offShelfTime class] == [NSNull class]) {
      //  NSLog(@"默认下架时间");
        NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
        [endTime setYear:year];
        [endTime setMonth:month];
        [endTime setDay:day + 1];
        [endTime setHour:14];
        [endTime setMinute:0];
        [endTime setSecond:0];
        
        todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
        
        //用来得到具体的时差
        
        
    } else{
        NSLog(@"特定下架时间");
        NSMutableString *string = [NSMutableString stringWithString:offShelfTime];
        NSRange range = [string rangeOfString:@"T"];
        [string replaceCharactersInRange:range withString:@" "];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        todate = [dateformatter dateFromString:string];
    }
    
    
    //用来得到具体的时差
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *string = nil;
    if ((long)[d day] == 0) {
        string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    }
    else{
        string = [NSString stringWithFormat:@"剩余%02ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
        
    }  self.timeLabel.text = string;
    if ([d hour] < 0 || [d minute] < 0 || [d second] < 0) {
        self.timeLabel.text = @"00:00:00";
    }
}

- (void)createContentView{
    NSArray *imageArray;
    NSLog(@"%@", json);
    NSLog(@"%@", [json objectForKey:@"product_model"]);
    if ([[json objectForKey:@"product_model"] class] != [NSNull class]) {
        NSDictionary *produltModel = [json objectForKey:@"product_model"];
        NSLog(@"Model = %@", produltModel);
        imageArray = [produltModel objectForKey:@"content_imgs"];
        
    } else{
       imageArray  = [details objectForKey:@"content_imgs"];
    }
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

   
}
// 可选尺码。。。
- (void)createSizeView{
    int sizeCount = (int)normalSkus.count;
    float height = 52;
    if (sizeCount%3 == 0) {
        height = 8;
    }
    self.sizeViewHeight.constant =  15 + 50*(int)(sizeCount/3)+height;
    NSLog(@"height = %f",20 + 44*(int)(sizeCount/3)+height);
    CGFloat buttonwidth = (SCREENWIDTH-60)/3;
    for (int i = 0; i<sizeCount; i++) {
        NSLog(@"%D", i);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 * (buttonwidth + 15) + 15, 15 + i/3 * 50, buttonwidth, 35)];
        button.tag = i + 100;
        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
       // button settit
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button.layer setMasksToBounds:YES];
        [button.layer setBorderWidth:1];
        button.layer.cornerRadius = 3;
        [button.layer setBorderColor:[UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor];
        //[button.layer setCornerRadius:8];
        
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor whiteColor];
        [self.sizeView addSubview:button];
        
//        self.sizeView.backgroundColor = [UIColor whiteColor];
    }
    for (int i = 0; i<sizeCount; i++) {
        UIButton *button = (UIButton *)[self.sizeView viewWithTag:i + 100];
        NSDictionary *dic = [normalSkus objectAtIndex:i];
        
        NSLog(@"%@", dic);
        NSLog(@"%d", (int)button.tag);
        agentPriceArray[i] = [NSNumber numberWithFloat:[[dic objectForKey:@"agent_price"] floatValue]];
        salePriceArray[i] = [NSNumber numberWithFloat:[[dic objectForKey:@"std_sale_price"] floatValue]];
        
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        
        NSLog(@"button.frame = %@", NSStringFromCGRect(button.frame));
      
//        CGRect rect = button.frame;
//        [self createInfoViewWithFrame:rect];
        
        if (![[json objectForKey:@"is_saleopen"]boolValue]) {
            [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
            button.userInteractionEnabled = NO;
        } else {
            if ([[dic objectForKey:@"is_saleout"]boolValue]) {
                [button setBackgroundColor:[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
                button.userInteractionEnabled = NO;
            } else {
                theNumberOfSizeCanSelected++;
            }
            
        }
        
    }
    NSLog(@"agentPrice = %@", agentPriceArray);
    NSLog(@"salePrice = %@", salePriceArray);
    
    if (theNumberOfSizeCanSelected == 0) {
        NSLog(@"已抢光");
        [self.addCartButton setTitle:@"已抢光" forState:UIControlStateNormal];
        [self.lijiBuyButton setTitle:@"" forState:UIControlStateNormal];
        self.addCartButton.backgroundColor = [UIColor grayColor];
        self.lijiBuyButton.backgroundColor = [UIColor lightGrayColor];
        self.addCartButton.enabled = NO;
        self.lijiBuyButton.enabled = NO;
        
    } else if (theNumberOfSizeCanSelected == 1){
        NSLog(@"只有一种可选尺码");
        
        for (int i = 0; i<sizeCount; i++) {
            UIButton *button = (UIButton *)[self.sizeView viewWithTag:i + 100];
            NSDictionary *dic = [normalSkus objectAtIndex:i];

            
            
            if (![[dic objectForKey:@"is_saleout"]boolValue]) {
                [button.layer setBorderColor:[UIColor redColor].CGColor];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                skusID = [[normalSkus objectAtIndex:i] objectForKey:@"id"];
                NSLog(@"skus_id = %@ and item_id = %@", skusID, itemID);
            }
            
            
            
        }
        
    }
    NSLog(@"theNumberOfSizeCanSelected = %d", theNumberOfSizeCanSelected);
    
    [self createSizeTable];
    NSLog(@"popViewArray = %@", self.popViewArray);
    
}

- (void)createInfoViewWithFrame:(CGRect)frame{
    ArrowView *poperView = [[ArrowView alloc] initWithFrame:CGRectMake(0, frame.origin.y - 60, SCREENWIDTH, 60) style:ArrowView_Bottom height:frame.origin.x + frame.size.width/2];
    [self.sizeView addSubview:poperView];
    poperView.backgroundColor = [UIColor clearColor];
    poperView.hidden = YES;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, -24, 60, 60)];
    button.backgroundColor = [UIColor blackColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-guanbi.png"]];
    imageView.frame = CGRectMake(SCREENWIDTH - 30, -10, 30, 30);
    imageView.layer.cornerRadius = 15;
    [poperView addSubview:imageView];
    button.layer.cornerRadius = 22;
    [button addTarget:self action:@selector(popviewHidden:) forControlEvents:UIControlEventTouchUpInside];
    [poperView addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    [self.popViewArray addObject:poperView];
    
    
}

- (void)popviewHidden:(UIButton *)button{
    NSLog(@"guanbi");
    for (ArrowView *popView in self.popViewArray) {
        popView.hidden = YES;
    }
    
}

- (void)createSizeTable{
    NSInteger width = 0;
    NSInteger height;
    mutableSize = [[NSMutableArray alloc] initWithCapacity:5];
    mutableSizeName = [[NSMutableArray alloc] initWithCapacity:5];
    if (normalSkus.count != 0) {
        
        
        height = normalSkus.count;
        self.sizeTableHeight.constant = (height + 1)*31;
    }
    for (NSDictionary *dic in normalSkus) {
        // NSLog(@"dic = %@", dic);
        
        id object = [[dic objectForKey:@"size_of_sku"] objectForKey:@"result"];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic2 = (NSDictionary *)object;
            [mutableSize addObject:dic2];
            [mutableSizeName addObject:[dic objectForKey:@"name"]];
            NSInteger result = dic2.count;
            NSInteger max = 10;
            if (result > max) {
                result = max;
            }
            
            width = result;
            
            NSLog(@"result = %ld", (long)result);
        } else {
            self.sizeTableHeight.constant = 0;

        }
    
    }
   labelWidth = SCREENWIDTH / (width + 1);
    CGFloat labelHeight = 30.0;
    NSArray *keysArray;
    if (mutableSize.count != 0) {
        NSDictionary *result = [mutableSize objectAtIndex:0];
        keysArray = [result allKeys];
    }
    NSLog(@"keysArray = %@", keysArray);
    orderKeyArray  = [[NSMutableArray alloc] init];
    for (NSString *key1 in allSizeKeys) {
        for (NSString *key2 in keysArray) {
            if ([key1 isEqualToString:key2]) {
                [orderKeyArray addObject:key2];
            }
        }
    }
    NSLog(@"orderKey = %@", orderKeyArray);
        
    
    NSLog(@"mutable = %@", mutableSize);
    
    NSLog(@"mutable = %@", mutableSizeName);
  
    
    
    
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 31)];
    [self.sizeTableView addSubview:headview];
    
    
    headview.backgroundColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    //[label sizeToFit];
  //  label.backgroundColor = [UIColor redColor];
    label.text = @"尺码";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [headview addSubview:label];
    for (int i = 0; i< width; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * i + labelWidth, 0, labelWidth, labelHeight)];
        //[label sizeToFit];
        //  label.backgroundColor = [UIColor redColor];
        label.text = [orderKeyArray objectAtIndex:i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        [headview addSubview:label];
    }
 //   CGFloat sizeViewWidth;
    CGFloat sizeViewHeight = 31;
    
    
    for (int i = 0; i < mutableSize.count; i++) {
        UIView *sizeView = [[UIView alloc] initWithFrame:CGRectMake(0, sizeViewHeight *i + sizeViewHeight, SCREENWIDTH, sizeViewHeight)];
        sizeView.tag = 600 + i;
        sizeView.backgroundColor = [UIColor colorWithR:240 G:240 B:241 alpha:1];
        
        if (i == mutableSize.count -1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, sizeViewHeight - 1, SCREENWIDTH, 1)];
            line.backgroundColor = [UIColor colorWithR:222 G:223 B:223 alpha:1];
            [sizeView addSubview:line];
        } else {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, sizeViewHeight - 1, SCREENWIDTH - 16, 1)];
            line.backgroundColor = [UIColor colorWithR:222 G:223 B:223 alpha:1];
            [sizeView addSubview:line];
        }
       
        
        
        [self.sizeTableView addSubview:sizeView];
    }
    for (int i = 0; i < mutableSize.count; i++) {
        UIView *sizeView = [self.sizeTableView viewWithTag:(i + 600)];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        //[label sizeToFit];
        //  label.backgroundColor = [UIColor redColor];
        label.text = [mutableSizeName objectAtIndex:i];
        label.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [sizeView addSubview:label];
        for (int j = 0; j< width; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * j + labelWidth, 0, labelWidth, labelHeight)];
            //[label sizeToFit];
            //  label.backgroundColor = [UIColor redColor];
            label.text = [[mutableSize objectAtIndex:i] objectForKey:[orderKeyArray objectAtIndex:j]];
            label.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
            label.font = [UIFont systemFontOfSize:9];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            
            [sizeView addSubview:label];
        }
        
        
    }
    
//    for (int i = 0; i < width; i ++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        button.frame = CGRectMake(labelWidth + labelWidth * i, 0, labelWidth, 280);
//    
//        button.tag = 8000 + i;
//        [button addTarget:self action:@selector(showSizeDetails:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [self.sizeTableView addSubview:button];
//    }
    
    
    

 
    
   
    
  
    
    
}

- (void)showSizeDetails:(UIButton *)button{
    NSLog(@"button.tag = %ld", (long)button.tag);
    int i = (int)button.tag - 8000;
    NSLog(@"size = %@", [orderKeyArray objectAtIndex:i]);
    NSLog(@"sizeName = %@", mutableSizeName);
    
    for (NSDictionary *dic in mutableSize) {
        NSString *string = [dic objectForKey:[orderKeyArray objectAtIndex:i]];
        NSLog(@"%@", string);
    }
    CGRect rect = self.sizeTableView.bounds;
    rect.size.width -= SCREENWIDTH;
    rect.origin.x += 0;
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor colorWithR:240 G:240 B:241 alpha:1];
    view.tag = 1234;
   
    for (int j = 0; j < mutableSize.count; j++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth * i + labelWidth - 50, 25 * j + 25, labelWidth + 100, 24)];
        label.text = [[mutableSize objectAtIndex:j] objectForKey:[orderKeyArray objectAtIndex:i]];
        label.backgroundColor = [UIColor colorWithR:240 G:240 B:241 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        
        [view addSubview:label];
    }
    
    
    
    
    
    [self.sizeTableView addSubview:view];
    //view.alpha = 0.2;
    [self performSelector:@selector(removeView) withObject:nil afterDelay:2];
    
}
- (void)removeView{
    UIView *view = [self.sizeTableView viewWithTag:1234];
    [view removeFromSuperview];
    
}




//点击按钮显示提示信息。。。。


- (void)btnClicked:(UIButton *)button{
    NSLog(@"button.tag = %ld", (long)button.tag);
    for (int i = 100; i<100+normalSkus.count; i++) {
        
        if (button.tag == i) {
            [button.layer setBorderColor:[UIColor redColor].CGColor];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            skusID = [[normalSkus objectAtIndex:i-100] objectForKey:@"id"];
            NSLog(@"skus_id = %@ and item_id = %@", skusID, itemID);
//            ArrowView *popView = [self.popViewArray objectAtIndex:i - 100];
//            popView.hidden = !popView.hidden;
            
            self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [agentPriceArray[i - 100] floatValue]];
            self.allPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [salePriceArray[i - 100] floatValue]];
            
            
        }else{
            UIButton *btn = (UIButton *)[self.sizeView viewWithTag:i];
            if ([btn isUserInteractionEnabled]) {
                [btn.layer setBorderColor:[UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor];
                [btn setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
//                ArrowView *popView = [self.popViewArray objectAtIndex:i - 100];
//                popView.hidden = YES;
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
                          width/2  - 140, height - 10,//控制点
                          0, height
                          );//控制点
    
    ani.path=aPath;
    ani.rotationMode = @"auto";
    ani.duration=0.9;
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
    
    //CGRectMake(4, SCREENHEIGHT - 40, 36, 36)
    [UIView animateWithDuration:0.5 animations:^{
        cartsButton.frame = CGRectMake(15, SCREENHEIGHT - 48, 88, 40);
        self.leftWidth.constant = 118;
//        CGRect frame = self.addCartButton.frame;
//        frame.origin.x += 48;
     //   self.addCartButton.frame = frame;
    } completion:^(BOOL finished) {
        NSLog(@"显示剩余时间");
        [self createTimeLabel];
        countLabel.hidden = NO;
        view0.hidden = YES;
        [cartsButton bringSubviewToFront:countLabel];

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
    
    [@"d" drawInRect:CGRectZero withAttributes:nil];
    [@"d" drawAtPoint:CGPointZero withAttributes:nil];
    //[@"d" drawLayer:nil inContext:nil];
}
- (IBAction)washshuomingClicked:(id)sender {
    NSLog(@"查看洗涤说明");
}
@end
