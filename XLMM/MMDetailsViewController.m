//
//  MMDetailsViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMDetailsViewController.h"
#import "MMDetailsModel.h"
#import "LogInViewController.h"
#import "MMClass.h"
#import "CartViewController.h"
#import "AFNetworking.h"
#import "ChiMaBiaoViewController.h"
#import "XidiShuomingViewController.h"
#import "WXApi.h"
#import "UIImage+UIImageExt.h"
#import "NSString+URL.h"
#import "UIImage+ImageWithUrl.h"
#import "UIColor+RGBColor.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "YoumengShare.h"
#import "SendMessageToWeibo.h"
#import "UIImage+ImageWithSelectedView.h"
#import "MMLoadingAnimation.h"

@interface MMDetailsViewController ()<UIGestureRecognizerDelegate, UIScrollViewDelegate, UIWebViewDelegate>{
    CGFloat headImageOrigineHeight;
    CGFloat contentTopHeight;
    CGFloat distance;
    CGFloat origineDistance;
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
    int contentCount;
    NSString *caizhi;
    NSString *yanse;
    NSString *beizhu;
    NSString *shuoming;
    UIView *view0;
    int theNumberOfSizeCanSelected;
    NSMutableArray *agentPriceArray;
    NSMutableArray *salePriceArray;
    NSString *offShelfTime;
    NSMutableArray *mutableSize;
    NSMutableArray *mutableSizeName;
    NSDictionary *shareDic;
    BOOL isWXFriends;
}


// 4张链接图片
@property (weak, nonatomic) IBOutlet UILabel *caizhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *yanseLabel;

//遮罩层
@property (nonatomic, strong)UIView *shareBackView;
//分享页面
@property (nonatomic, strong) YoumengShare *youmengShare;
//分享参数
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)UIImage *shareImage;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSData *imageD;
//加载快照
@property (nonatomic, strong)UIWebView *webView;

@property (nonatomic, strong)UIImage *kuaiZhaoImage;


@end

@implementation MMDetailsViewController

- (YoumengShare *)youmengShare {
    if (!_youmengShare) {
        self.youmengShare = [[YoumengShare alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _youmengShare;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (last_created != nil) {
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    }
    //
    [self createTimeCartView];
    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}



- (void)hiddenNavigationView{
    self.navigationController.navigationBarHidden = YES;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.webView = nil;
    self.kuaiZhaoImage = nil;
   // [SVProgressHUD dismiss];
//    [MMLoadingAnimation dismissLoadingView];
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil modelID:(NSString *)modelID isChild:(BOOL)isChild{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json", Root_URL, modelID];
        self.urlString = string;
        _childClothing = isChild;
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.scrollerView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.shareView];
    _midLabel.hidden = YES;
    agentPriceArray = [[NSMutableArray alloc] init];
    salePriceArray = [[NSMutableArray alloc] init];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.scrollerView.delegate = self;
    contentCount = 0;
    theNumberOfSizeCanSelected = 0;
   
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
//  
//    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, -60)];
//    
//    [SVProgressHUD setDefaultMaskType:3];
//    
////    [SVProgressHUD show];
    [self.view addSubview:[MMLoadingAnimation sharedView]];
    [MMLoadingAnimation showLoadingView];
    // 667 736
    self.headViewwidth.constant = SCREENWIDTH;
    if (SCREENHEIGHT == 568) {
        self.headViewHeitht.constant = 420;
        self.bottomImageViewHeight.constant = 420;
        contentTopHeight = 420 - 106;
    } else if (SCREENHEIGHT == 667){
        self.headViewHeitht.constant = 420 + 96;
        self.bottomImageViewHeight.constant = 420 + 96;
        contentTopHeight = 420 + 96 - 106;
    } else if (SCREENHEIGHT > 670){
        self.headViewHeitht.constant = 420 + 163;
        self.bottomImageViewHeight.constant = 420 + 163;
        contentTopHeight = 420 + 163 - 106;
    }
    [self createCartView];

    //完成前的显示界面 加载界面 可以使用加载动画
//    frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    frontView.backgroundColor = [UIColor whiteColor];
//    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    indicatorView.frame = CGRectMake(SCREENWIDTH/2-40, 200, 80, 80);
//    [indicatorView startAnimating];
//    [frontView addSubview:indicatorView];
//    [self.view addSubview:frontView];
    self.addCartButton.layer.cornerRadius = 20;
    self.addCartButton.layer.borderWidth = 1;
    self.addCartButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.addCartButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    self.line2Height.constant = 0.5;
    self.line3Height.constant = 0.5;
    self.line5Height.constant = 0.5;
    self.line6height.constant = 0.5;
    [self downloadDetailsData];
    
    if ([WXApi isWXAppInstalled]) {
        
    } else {
        self.shareButton.hidden = YES;
        self.shareButtonImage.hidden = YES;
    }
    
    
    self.scrollerView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.navigationController.navigationBarHidden = YES;
    CGPoint contentOffset = scrollView.contentOffset;
    self.bottomImageView.frame = CGRectMake(0, 0, SCREENWIDTH , self.bottomImageViewHeight.constant);
    distance = headImageOrigineHeight - contentTopHeight;
    if (contentOffset.y<-distance) {
        //下拉
        CGFloat sizeheight = contentTopHeight- contentOffset.y;
        self.bottomImageViewHeight.constant = sizeheight;
        self.imageleading.constant = (contentOffset.y + distance)/2;
        self.imageTrailing.constant = (contentOffset.y + distance)/2;
    }
    if (contentOffset.y >= 0) {
//        NSLog(@"");
//        
//        NSLog(@"%@", NSStringFromCGPoint(contentOffset));
        //上滑
        self.imageViewTop.constant = -contentOffset.y/3;
        self.imageBottom.constant = (contentOffset.y)/3;
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}
- (void)downloadDetailsData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlString]];
        [self performSelectorOnMainThread:@selector(fetchedDetailsData:)withObject:data waitUntilDone:YES];
    });
    
}
- (void)fetchedDetailsData:(NSData *)data{
    if (data == nil) {
        [MMLoadingAnimation dismissLoadingView];
        cartsButton.hidden = NO;
        return;
    }
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    json = dic; 
    //设置底部图片,调整高度
    self.midLabel.hidden = NO;
   [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"pic_path"] URLEncodedString] ImageNoCompression]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       [MMLoadingAnimation dismissLoadingView];
       cartsButton.hidden = NO;
       if (image != nil) {

           self.scrollerView.scrollEnabled = YES;
            self.bottomImageViewHeight.constant = SCREENWIDTH *image.size.height /image.size.width;
            headImageOrigineHeight = SCREENWIDTH *image.size.height /image.size.width;
            #pragma mark --判断是否拉伸图片
            origineDistance = headImageOrigineHeight - contentTopHeight;
            if (origineDistance < 0 ) {
                CGFloat sizeheight = contentTopHeight;
                self.bottomImageViewHeight.constant = sizeheight;
                self.imageleading.constant = (origineDistance)/2;
                self.imageTrailing.constant = (origineDistance)/2;
            }
       } else{
           UIImage *image = [UIImage imagewithURLString:[[[dic objectForKey:@"pic_path"] URLEncodedString] ImageNoCompression]];
           if (image != nil) {
               self.bottomImageView.image = image;
               self.scrollerView.scrollEnabled = YES;
               self.bottomImageViewHeight.constant = SCREENWIDTH *image.size.height /image.size.width;
               headImageOrigineHeight = SCREENWIDTH *image.size.height /image.size.width;
#pragma mark --判断是否拉伸图片
               origineDistance = headImageOrigineHeight - contentTopHeight;
               if (origineDistance < 0 ) {
                   CGFloat sizeheight = contentTopHeight;
                   self.bottomImageViewHeight.constant = sizeheight;
                   self.imageleading.constant = (origineDistance)/2;
                   self.imageTrailing.constant = (origineDistance)/2;
               }
           }
         
       }

    }];
    //名字 价格 原价
    self.nameLabel.text = [dic objectForKey:@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [[dic objectForKey:@"lowest_price"] floatValue]];
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥%@", [dic objectForKey:@"std_sale_price"]];
    
    details = [dic objectForKey:@"details"];
    self.bianhao.text = [dic objectForKey:@"outer_id"];
    if ([[details objectForKey:@"material"] isKindOfClass:[NSString class]]) {
        self.caizhiLabel.text = [details objectForKey:@"material"];
    } else {
        self.caizhiLabel.text = @"无";
    }
    if ([[details objectForKey:@"color"] isKindOfClass:[NSString class]]) {
        self.yanseLabel.text = [details objectForKey:@"color"];
        NSString *string = [details objectForKey:@"color"];
        NSInteger length = string.length;
        //商品可选颜色
        if (length > 0) {
        self.yansebottomHeight.constant = 14;
        }
        if (length > 22) {
            self.yansebottomHeight.constant = 24;
        }
        if (length > 45) {
            self.yansebottomHeight.constant = 34;
        }
       
       // self.canshuViewHeight.constant += length/16*15;
    } else {
        self.yanseLabel.text = @"无";
    }
    if ([[details objectForKey:@"note"] isKindOfClass:[NSString class]]) {
        self.canshulabel.text = [details objectForKey:@"note"];
        NSString *string = [details objectForKey:@"note"];
        NSInteger length = string.length;
        self.canshuViewHeight.constant += length/16*15;
    } else{
        self.canshulabel.text = @"无";
    }
    
    itemID = [dic objectForKey:@"id"];
    normalSkus = [dic objectForKey:@"normal_skus"];
    saleTime = [dic objectForKey:@"sale_time"];
    offShelfTime = [dic objectForKey:@"offshelf_time"];
  
//    [self createShareData];
   

    [self createSizeView];
    [self createContentView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTime) userInfo:nil repeats:YES];
    [self setTime];
}

- (void)createShareData{
    if (shareDic == nil) {
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/share/product?product_id=%@", Root_URL, itemID];
        NSLog(@"shareUrl = %@", string);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
        if (data == nil || [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin] == NO) {
            
            LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
            
        }
        shareDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"dic = %@", shareDic);
        
        self.titleStr = [shareDic objectForKey:@"title"];
        self.des = [shareDic objectForKey:@"desc"];
        self.url = [shareDic objectForKey:@"share_link"];
    }

    
}
- (void)createKuaiZhaoImage{
    NSString *str = [NSString stringWithFormat:@"%@/rest/v1/products/%@/snapshot.html", Root_URL, itemID];
    NSLog(@"imageUrlString = %@", str);
    
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
}




- (void)createCartView{
    cartsButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREENHEIGHT - 48, 40, 40)];
    cartsButton.layer.cornerRadius = 20;
    cartsButton.layer.borderWidth = 1;
    cartsButton.layer.borderColor = [UIColor colorWithR:38 G:38 B:46 alpha:1].CGColor;
    cartsButton.backgroundColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
    [cartsButton addTarget:self action:@selector(cartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cartsButton];
    cartsButton.hidden = YES;
    shengyutimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 6, 44, 30)];
    shengyutimeLabel.textColor = [UIColor whiteColor];
    shengyutimeLabel.textAlignment = NSTextAlignmentCenter;
    shengyutimeLabel.font = [UIFont systemFontOfSize:16];
    shengyutimeLabel.hidden = YES;
    [cartsButton addSubview:shengyutimeLabel];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gouwucheicon2.png"]];
    imageview.frame = CGRectMake(10, 10, 20, 20);
    [cartsButton addSubview:imageview];
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, SCREENHEIGHT - 50, 20, 20)];
    countLabel.layer.cornerRadius = 10;
    countLabel.userInteractionEnabled = NO;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor colorWithR:255 G:56 B:64 alpha:1];
    countLabel.layer.masksToBounds = YES;
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.hidden = YES;
    
    
    [self.view addSubview:countLabel];
}
//点击购物车
- (void)cartClicked:(UIButton *)btn{
    BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"login"];
    if (login == NO) {
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    CartViewController *cartVC = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    [self.navigationController pushViewController:cartVC animated:YES];
}
//设置倒计时。。。
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
    } else{
       // NSLog(@"特定下架时间");
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
//创建内容视图
- (void)createContentView{
    NSArray *imageArray;

    if ([[json objectForKey:@"product_model"] class] != [NSNull class]) {
        NSDictionary *produltModel = [json objectForKey:@"product_model"];
        imageArray = [produltModel objectForKey:@"content_imgs"];
        
    } else{
       imageArray  = [details objectForKey:@"content_imgs"];
        
        
    }
    
   // NSLog(@"imagelinks = %@", imageArray);
    __block float origineY = 0.0;
    __block float imagewidth = 0.0;
    __block float imageHeight = 0.0;
    
    NSMutableArray *heights = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<imageArray.count; i++) {
        
        UIImageView *imageview = [[UIImageView alloc] init];
        NSString *imagelink = [[[imageArray objectAtIndex:i] URLEncodedString] ImageNoCompression];
    //    NSLog(@"imageLink = %@", imagelink);
        [imageview sd_setImageWithURL:[NSURL URLWithString:imagelink] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
          //  NSLog(@"%dimage = %@",i, image);
            imagewidth = SCREENWIDTH;
            
            if (image.size.width == 0) {
                imageHeight = 0;
            } else {
            imageHeight = image.size.height/image.size.width * SCREENWIDTH;
            }
            [heights addObject:[NSNumber numberWithFloat:imageHeight]];

            
            if (contentCount == 0) {
                origineY = 0;
            } else {
                origineY += [[heights objectAtIndex:(contentCount-1)] floatValue];
            }
            contentCount++;
            imageview.frame = CGRectMake(0, origineY, imagewidth, imageHeight);
            self.contentViewHeight.constant = origineY + imageHeight;
        }];
        [self.contentView addSubview:imageview];
    }
}


// 可选尺码。。。
- (void)createSizeView{
    int sizeCount = (int)normalSkus.count;
    float height = 52;
    if (sizeCount%3 == 0) {
        height = 8;
    }
    self.sizeViewHeight.constant =  30 + 15 + 50*(int)(sizeCount/3)+height;
   // NSLog(@"height = %f",20 + 44*(int)(sizeCount/3)+height);
    CGFloat buttonwidth = (SCREENWIDTH-60)/3;
    for (int i = 0; i<sizeCount; i++) {
    //    NSLog(@"%D", i);
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%3 * (buttonwidth + 15) + 15, 15 + i/3 * 50, buttonwidth, 35)];
        button.tag = i + 100;
//        [button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
       // button settit
        button.titleLabel.font = [UIFont systemFontOfSize:14];
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
        agentPriceArray[i] = [NSNumber numberWithFloat:[[dic objectForKey:@"agent_price"] floatValue]];
        salePriceArray[i] = [NSNumber numberWithFloat:[[dic objectForKey:@"std_sale_price"] floatValue]];
        [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        if (![[json objectForKey:@"is_saleopen"]boolValue]) {
            [button setBackgroundColor:[UIColor buttonDisabledBackgroundColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
        } else {
            if ([[dic objectForKey:@"is_saleout"]boolValue]) {
                [button setBackgroundColor:[UIColor buttonDisabledBackgroundColor]];
                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            } else {
                theNumberOfSizeCanSelected++;
            }
        }
    }
    if (theNumberOfSizeCanSelected == 0) {
    //    NSLog(@"已抢光");
        [self.addCartButton setTitle:@"已抢光" forState:UIControlStateNormal];
        self.addCartButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
        self.addCartButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
        self.addCartButton.enabled = NO;
    } else if (theNumberOfSizeCanSelected == 1){
        for (int i = 0; i<sizeCount; i++) {
            UIButton *button = (UIButton *)[self.sizeView viewWithTag:i + 100];
            NSDictionary *dic = [normalSkus objectAtIndex:i];
            if (![[dic objectForKey:@"is_saleout"]boolValue]) {
                [button.layer setBorderColor:[UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor];
                [button setTitleColor:[UIColor colorWithR:245 G:177 B:35 alpha:1] forState:UIControlStateNormal];
                skusID = [[normalSkus objectAtIndex:i] objectForKey:@"id"];
               // NSLog(@"skus_id = %@ and item_id = %@", skusID, itemID);
            }
        }
    }
}
- (void)btnClicked:(UIButton *)button{
//    NSLog(@"button.tag = %ld", (long)button.tag);
    for (int i = 100; i<100+normalSkus.count; i++) {
        if (button.tag == i) {
            [button.layer setBorderColor:[UIColor colorWithR:245 G:177 B:35 alpha:1].CGColor];
            [button setTitleColor:[UIColor colorWithR:245 G:177 B:35 alpha:1] forState:UIControlStateNormal];
            skusID = [[normalSkus objectAtIndex:i-100] objectForKey:@"id"];
         //   NSLog(@"skus_id = %@ and item_id = %@", skusID, itemID);
            self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", [agentPriceArray[i - 100] floatValue]];
            self.allPriceLabel.text = [NSString stringWithFormat:@"¥%.0f", [salePriceArray[i - 100] floatValue]];
        }else{
            UIButton *btn = (UIButton *)[self.sizeView viewWithTag:i];
            if ([btn isUserInteractionEnabled]) {
                [btn.layer setBorderColor:[UIColor colorWithR:216 G:216 B:216 alpha:1].CGColor];
                [btn setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];

            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCartBtnClicked:(id)sender {
 //   NSLog(@"加入购物车");
    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
   // NSLog(@"islogin = %d", islogin);
    if (islogin == NO) {
        LogInViewController *enterVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
        return;
    }
    if (skusID == nil) {
        [UIView animateWithDuration:.5f animations:^{
            self.scrollerView.contentOffset = CGPointMake(0, self.sizeViewHeight.constant);
            
        } completion:^(BOOL finished) {
           // NSLog(@"top");
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
          //  NSLog(@"tips");
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
           // NSLog(@"finish");
        }];
        
    } else{
       // NSLog(@"加入购物车");
        //                http://youni.huyi.so/rest/v1/carts
      //  NSLog(@"item_id = %@", itemID);
      //  NSLog(@"sku_id = %@", skusID);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"item_id": itemID,
                                     @"sku_id":skusID};
        [manager POST:kCart_URL parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
               //   NSLog(@"JSON: %@", responseObject);
                  [self myAnimation];

            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         //   NSLog(@"Error: %@", error);
         //     NSLog(@"error:, --.>>>%@", error.description);
              NSDictionary *dic = [error userInfo];
            //  NSLog(@"dic = %@", dic);
           //   NSLog(@"error = %@", [dic objectForKey:@"com.alamofire.serialization.response.error.data"]);
              
              __unused NSString *str = [[NSString alloc] initWithData:[dic objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding];
           //   NSLog(@"%@",str);
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
          //   NSLog(@"%@", dic);
             if ([dic objectForKey:@"result"] != nil) {
                 last_created = [dic objectForKey:@"last_created"];
                 goodsCount = [[dic objectForKey:@"result"] integerValue];
            //     NSLog(@"%ld", (long)goodsCount);
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
      //  NSLog(@"%@", dic);
        if ([dic objectForKey:@"result"] != nil) {
            
            last_created = [dic objectForKey:@"last_created"];
            goodsCount = [[dic objectForKey:@"result"] integerValue];
           //nnnf
            
            
            //NSLog(@"%ld", (long)goodsCount);
            NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
            countLabel.text = strNum;
            if (goodsCount >0) {
                //CGRectMake(4, SCREENHEIGHT - 40, 36, 36)
                [UIView animateWithDuration:0.1 animations:^{
                    cartsButton.frame = CGRectMake(15, SCREENHEIGHT - 48, 88, 40);
                    //        CGRect frame = self.addCartButton.frame;
                    //        frame.origin.x = 118;
                    //        frame.size.width = SCREENWIDTH - 126;
                } completion:^(BOOL finished) {
              //
                 //   NSLog(@"显示剩余时间");
                    [self createTimeLabel];
                    countLabel.hidden = NO;
                    
                    
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    self.leftWidth.constant = 118;
                    
                }];
            }
        }
    }
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
 //   NSLog(@"string = %@", string);
    if ([d minute] < 0 || [d second] < 0) {
        string = @"00:00";
        if ([theTimer isValid]) {
            [theTimer invalidate];
            
        }
    }
    shengyutimeLabel.text = string;
}

- (IBAction)backqianye:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)washshuomingClicked:(id)sender {
 //   NSLog(@"查看洗涤说明");
    XidiShuomingViewController *xdVC = [[XidiShuomingViewController alloc] initWithNibName:@"XidiShuomingViewController" bundle:nil];
    [self.navigationController pushViewController:xdVC animated:YES];
}

- (IBAction)sizeViewBtnClicked:(id)sender {
    
 //   NSLog(@"尺码表");
    ChiMaBiaoViewController *sizeVC = [[ChiMaBiaoViewController alloc] initWithNibName:@"ChiMaBiaoViewController" bundle:nil];
    sizeVC.sizeArray = normalSkus;
    sizeVC.childClothing = self.childClothing;
    
    [self.navigationController pushViewController:sizeVC animated:YES];
}
#pragma mark -- weixin share

- (IBAction)shareClicked:(id)sender {
    //修改分享图片，标题， 链接 ，
    
    //  kLinkURL = @"http://xiaolu.so/m/18807/";
    //NSString *kLinkTagName = @"xiaolumeimei";
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        [self createShareData];

    } else {
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    
    NSString *shareTitle = [json objectForKey:@"name"];
    NSString *shareDesc = [[json objectForKey:@"details"] objectForKey:@"note"];
    NSString *kLinkDescription;
    if ([[[json objectForKey:@"details"] objectForKey:@"note"] isKindOfClass:[NSString class]]) {
       kLinkDescription = shareDesc;

    } else{
        kLinkDescription = @"小鹿妹妹";
    }
    __unused NSString *kLinkTitle = shareTitle;
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString *shareLink = [NSString stringWithFormat:@"http://m.xiaolu.so/pages/shangpinxq.html?id=%@", [json objectForKey:@"id"]];


    ext.webpageUrl = shareLink;
    
    NSString *imageUrlString = [json objectForKey:@"pic_path"];
    NSData *imageData = nil;
    do {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imageUrlString URLEncodedString]]];
        if (imageData != nil) {
            break;
        }
        
    } while (YES);
    UIImage *image = [UIImage imageWithData:imageData];
    image = [[UIImage alloc] scaleToSize:image size:CGSizeMake(300, 400)];
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.8);
    UIImage *newImage = [UIImage imageWithData:imagedata];
    
    self.shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.shareBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareBackView];
    [self.shareBackView addSubview:self.youmengShare];
    self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    
    // 点击分享后弹出自定义的分享界面
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240);
    }];
    
    
    // 分享页面事件处理
    [self.youmengShare.cancleShareBtn addTarget:self action:@selector(cancleShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.weixinShareBtn addTarget:self action:@selector(weixinShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.friendsShareBtn addTarget:self action:@selector(friendsShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqshareBtn addTarget:self action:@selector(qqshareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqspaceShareBtn addTarget:self action:@selector(qqspaceShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.weiboShareBtn addTarget:self action:@selector(weiboShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.linkCopyBtn addTarget:self action:@selector(linkCopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.snapshotBtn addTarget:self action:@selector(snapshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.friendsSnaoshotBtn addTarget:self action:@selector(friendsSnaoshotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.imageD = imageData;

    self.shareImage = newImage;

}

#pragma mark --分享按钮事件
- (void)cancleShareBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self.shareBackView removeFromSuperview];
    }];
}
- (void)weixinShareBtnClick:(UIButton *)btn{
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
    [UMSocialData defaultData].extConfig.wxMessageType = 0;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
    }];
    
    
    [self cancleShareBtnClick:nil];
    
}

- (void)friendsShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];

    }];

    [self cancleShareBtnClick:nil];
    
}



- (void)qqshareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
    }];

    
    [self cancleShareBtnClick:nil];
}

- (void)qqspaceShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr  ;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
    }];

    [self cancleShareBtnClick:nil];
}

- (void)weiboShareBtnClick:(UIButton *)btn {
    NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.titleStr, self.url];
    [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:self.imageD];

    [self cancleShareBtnClick:nil];
}

- (void)linkCopyBtnClick:(UIButton *)btn {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *str = self.url;
    [pab setString:str];
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"请重新复制"];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
    }

    [self cancleShareBtnClick:nil];
}

- (void)snapshotBtnClick:(UIButton *)btn {
    isWXFriends = NO;
    [self createKuaiZhaoImage];

}

- (void)friendsSnaoshotBtnClick:(UIButton *)btn{
    isWXFriends = YES;
    [self createKuaiZhaoImage];

}
#pragma mark -- UIWebView代理

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    self.kuaiZhaoImage = [UIImage imagewithWebView:self.webView];
    self.kuaiZhaoImage = [UIImage imagewithWebView:self.webView];
    
    if (isWXFriends) {
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:self.kuaiZhaoImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            
        }];
        [self cancleShareBtnClick:nil];
    } else {
        [[UMSocialControllerService defaultControllerService] setShareText:nil shareImage:self.kuaiZhaoImage socialUIDelegate:self];
        [UMSocialControllerService defaultControllerService].socialData.extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
        [self cancleShareBtnClick:nil];
    }
    
    
}


@end
