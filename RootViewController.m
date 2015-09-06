//
//  RootViewController.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "RootViewController.h"
#import "MMClass.h"
#import "EmptyCartViewController.h"
#import "CartViewController.h"
#import "EnterViewController.h"

@interface RootViewController (){
    BOOL isToday;//
    BOOL isFirst;
    NSInteger goodsCount;
    UILabel *countLabel;

    NSMutableArray *_prePosterArray;//保存昨日海报数据
    NSMutableArray *_todayPosterArray;//存储今日海报数据
    
    NSMutableArray *_todayPromoteChildArray;//今日推荐
    NSMutableArray *_todayPromoteLadyArray;
    
    NSMutableArray *_prePromoteChildArray;//昨日推荐
    NSMutableArray *_prePromoteLadyArray;
    
    NSMutableArray *_ModelListArray;
    
    //保存下载的数据
    NSMutableData *_data;
    
    //视图
    PosterView *posterViewOwner;
    GoodsView *ownerGoodsView;
    LadyView *ownerLadyView;
    
    //显示剩余时间
    UILabel *childTimeLabel;
    UILabel *ladyTimeLabel;
    
    UILabel *poster1TimeLabel;
    UILabel *poster2TimeLabel;
    
    UILabel *childPreTimeLabel;
    UILabel *ladyPreTimeLabel;
    
    UILabel *poster1PreTimeLabel;
    UILabel *poster2PreTimeLabel;
    
    NSTimer *theTimer;

}

@end

@implementation RootViewController



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
    
    self.navigationController.navigationBar.hidden = NO;

    // Do any additional setup after loading the view from its nib.
    //自定义导航栏信息
    posterViewOwner = [PosterView new];
    ownerGoodsView = [GoodsView new];
    ownerLadyView = [LadyView new];
    
    _ModelListArray = [[NSMutableArray alloc] init];
    isToday = YES;
    isFirst = YES;
    
    self.widthView.constant = SCREENWIDTH;//设置视图的大小
    self.posterView.frame = CGRectMake(0, 84, SCREENWIDTH, 370);
    self.childView.frame = CGRectMake(0, 454, SCREENWIDTH, 500);
    self.ladyView.frame = CGRectMake(0, 954, SCREENWIDTH, 500);
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kIsLogin];
    
    [userDefaults setInteger:0 forKey:NumberOfCart];
    [userDefaults synchronize];

    
    
    [self setInfo];
    [self setTitleImage];
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
    view.layer.cornerRadius = 10;
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    countLabel.layer.cornerRadius = 10;
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_Number_URL]];
    if (data != nil) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSLog(@"%@", dic);
        
        goodsCount = [[dic objectForKey:@"result"] integerValue];
        NSLog(@"%ld", (long)goodsCount);
        NSString *strNum = [NSString stringWithFormat:@"%ld", (long)goodsCount];
        countLabel.text = strNum;
    }
  
    countLabel.font = [UIFont systemFontOfSize:14];
    countLabel.userInteractionEnabled = NO;
    view.userInteractionEnabled = NO;
    [view addSubview:countLabel];
    [button addSubview:view];
}
- (void)cartClicked:(UIButton *)btn{
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
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-fanhuidingbu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoTopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
    button.alpha = 0.5;
   
}
- (void)gotoTopClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, -64);
    }];
}






//设计倒计时方法。。。。
- (void)timerFireMethod:(NSTimer*)theTimer
{
    NSLog(@"***********");
    
    
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
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int nextday = day + 1;
    
   // NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
    [endTime setYear:year];
    [endTime setMonth:month];
    [endTime setDay:nextday];
    [endTime setHour:14];
    [endTime setMinute:0];
    [endTime setSecond:0];

    NSDate *todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
    
    //用来得到具体的时差

    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    NSString *str = nil;
    if (  !isToday ) {
        str = [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    }else{
    str = [NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
    }
    
    poster1TimeLabel.text = str;
    poster2TimeLabel.text = str;
    childTimeLabel.text = str;
    ladyTimeLabel.text = str;
    poster1TimeLabel.font = [UIFont fontWithName:@"LiHei Pro" size:14];
    poster2TimeLabel.font = [UIFont fontWithName:@"LiHei Pro" size:14];
    childTimeLabel.font = [UIFont fontWithName:@"LiHei Pro" size:14];
    ladyTimeLabel.font = [UIFont fontWithName:@"LiHei Pro" size:14];

}




- (void)downloadData{
    //下载今日海报
    [self downLoadWithURLString:kTODAY_POSTERS_URL andSelector:@selector(fetchedTodayPosterData:)];
    //下载今日推荐
    [self downLoadWithURLString:kTODAY_PROMOTE_URL andSelector:@selector(fetchedTodaypromoteData:)];
    
}

- (void)downloadPreData{
    //下载昨日海报
    [self downLoadWithURLString:kPREVIOUS_POSTERS_URL andSelector:@selector(fetchedPreviousPosterData:)];
    //下载昨日推荐
    [self downLoadWithURLString:kPREVIOUS_PROMOTE_URL andSelector:@selector(fetchedPreviouspromoteData:)];

}
//下载数据
- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}
#pragma mark ---JSON 解析 ------
//昨日推荐 JSON 数据解析
- (void) fetchedPreviouspromoteData:(NSData *)responseData{
    NSError *error;
    _prePromoteChildArray = [[NSMutableArray alloc] init];
    _prePromoteLadyArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *childArray = [dic objectForKey:@"child_list"];
    if ([childArray count] == 0) {
        return;
    }
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
        model.url = [child objectForKey:@"url"];
        model.uid = [child objectForKey:@"id"];
        MMLOG(model.url);
        model.isSaleOpen = [[child objectForKey:@"is_saleopen"] boolValue];
        model.isSaleOut = [[child objectForKey:@"is_saleout"]boolValue];
        model.isNewGood = [[child objectForKey:@"is_newgood"]boolValue];
        model.remainNumber = [[child objectForKey:@"remain_num"]integerValue];
        
    //    NSLog(@"%d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        
        
        NSDictionary *dic = [child objectForKey:@"product_model"];
        if ([dic class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic;
            model.headImageURLArray = [dic objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic objectForKey:@"content_imgs"];
        }
        [_prePromoteChildArray addObject:model];
    }
    [self createChildViewWithArray:_prePromoteChildArray];
    
    NSArray *ladyArray = [dic objectForKey:@"female_list"];
    if (ladyArray.count == 0) {
        return;
    }
    for (int i = 0; i<4; i++) {
        NSDictionary *lady = [ladyArray objectAtIndex:i];
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [lady objectForKey:@"pic_path"];
        model.name = [lady objectForKey:@"name"];
        model.price = [lady objectForKey:@"agent_price"];
        model.oldPrice = [lady objectForKey:@"std_sale_price"];
        model.url = [lady objectForKey:@"url"];
        model.isSaleOpen = [[lady objectForKey:@"is_saleopen"] boolValue];
        model.isSaleOut = [[lady objectForKey:@"is_saleout"]boolValue];
        model.isNewGood = [[lady objectForKey:@"is_newgood"]boolValue];
        model.remainNumber = [[lady objectForKey:@"remain_num"]integerValue];
        model.uid = [lady objectForKey:@"id"];
    //    NSLog(@"%d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        
        
        NSDictionary *dic2 = [lady objectForKey:@"product_model"];
        if ([dic2 class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic2;
            model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
        }
        [_prePromoteLadyArray addObject:model];
    }
    [self createLadyViewWithArray:_prePromoteLadyArray];
}

//今日推荐 JSON 数据解析
- (void) fetchedTodaypromoteData:(NSData *)responseData{
    NSError *error;
    _todayPromoteChildArray = [[NSMutableArray alloc] init];
    _todayPromoteLadyArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *childArray = [dic objectForKey:@"child_list"];
   // NSLog(@"today dic = %@", dic);
    if ([childArray count] == 0) {
        
        [self createDefaultChildView];
        [self createDefaultLadyView];
        
        return;
    }
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
        model.url = [child objectForKey:@"url"];
        model.uid = [child objectForKey:@"id"];
        MMLOG(model.url);
        
        
        model.isSaleOpen = [[child objectForKey:@"is_saleopen"] boolValue];
        model.isSaleOut = [[child objectForKey:@"is_saleout"]boolValue];
        model.isNewGood = [[child objectForKey:@"is_newgood"]boolValue];
        model.remainNumber = [[child objectForKey:@"remain_num"]integerValue];
        
    //    NSLog(@"%d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);

        NSDictionary *dic = [child objectForKey:@"product_model"];
        if ([dic class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic;
            model.headImageURLArray = [dic objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic objectForKey:@"content_imgs"];
        }
       
        
        [_todayPromoteChildArray addObject:model];
    }
    [self createChildViewWithArray:_todayPromoteChildArray];
    NSArray *ladyArray = [dic objectForKey:@"female_list"];
    
   // NSLog(@"%@", ladyArray);
    if (ladyArray.count == 0) {
        [self createDefaultLadyView];
        return;
    }
    for (int i = 0; i<4; i++) {
        
        NSDictionary *lady = [ladyArray objectAtIndex:i];
        PeopleModel *model = [[PeopleModel alloc] init];
        model.imageURL = [lady objectForKey:@"pic_path"];
        model.name = [lady objectForKey:@"name"];
        model.price = [lady objectForKey:@"agent_price"];
        model.oldPrice = [lady objectForKey:@"std_sale_price"];
        model.url = [lady objectForKey:@"url"];
        model.uid = [lady objectForKey:@"id"];
        MMLOG(model.url);
        model.isSaleOpen = [[lady objectForKey:@"is_saleopen"] boolValue];
        model.isSaleOut = [[lady objectForKey:@"is_saleout"]boolValue];
        model.isNewGood = [[lady objectForKey:@"is_newgood"]boolValue];
        model.remainNumber = [[lady objectForKey:@"remain_num"]integerValue];
        
   //     NSLog(@"%d,%d,%d,%ld,", model.isSaleOpen, model.isSaleOut, model.isNewGood, model.remainNumber);
        NSDictionary *dic2 = [lady objectForKey:@"product_model"];
        if ([dic2 class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic2;
            model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
        }
        
        [_todayPromoteLadyArray addObject:model];
    }
    [self createLadyViewWithArray:_todayPromoteLadyArray];
}


//昨日海报 JSON 数据解析
- (void) fetchedPreviousPosterData:(NSData *)responseData{
    NSError *error;
    _prePosterArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *wemArray = [dic objectForKey:@"wem_posters"];
    if ([wemArray count] == 0) {
        return;
    }
    NSDictionary *wonmendic = [wemArray objectAtIndex:0];
    NSArray *nameArr = [wonmendic objectForKey:@"subject"];
    
    PosterModel *model = [PosterModel new];
    model.imageURL = [wonmendic objectForKey:@"pic_link"];
    model.firstName = [nameArr objectAtIndex:0];
    model.secondName = [nameArr objectAtIndex:1];
    [_prePosterArray addObject:model];
    
    
 
    NSArray *childArray = [dic objectForKey:@"chd_posters"];
    NSDictionary *childdic = [childArray objectAtIndex:0];
    NSArray *nameArr2 = [childdic objectForKey:@"subject"];
    
    PosterModel *model2 = [[PosterModel alloc] init];
    model2.imageURL = [childdic objectForKey:@"pic_link"];
    model2.firstName = [nameArr2 objectAtIndex:0];
    model2.secondName = [nameArr2 objectAtIndex:1];
    [_prePosterArray addObject:model2];
    
    [self createPosterViewWithArray:_prePosterArray];
}

//今日海报 JSON 数据解析
- (void)fetchedTodayPosterData:(NSData *)responseData{
    NSError *error;
    _todayPosterArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
   // NSLog(@"today poster = %@", dic);
   
    NSArray *wemArray = [dic objectForKey:@"wem_posters"];
  //  NSLog(@"%@", wemArray);
    if (wemArray.count == 0) {
        [self createDefaultPosterView];
        return;
    }
    

    NSDictionary *wonmendic = [wemArray objectAtIndex:0];
    
    NSArray *nameArr = [wonmendic objectForKey:@"subject"];
    PosterModel *model = [PosterModel new];
    model.imageURL = [wonmendic objectForKey:@"pic_link"];
    model.firstName = [nameArr objectAtIndex:0];
    model.secondName = [nameArr objectAtIndex:1];

    [_todayPosterArray addObject:model];
    
   
    NSArray *childArray = [dic objectForKey:@"chd_posters"];
    NSDictionary *childdic = [childArray objectAtIndex:0];
    NSArray *nameArr2 = [childdic objectForKey:@"subject"];
    PosterModel *model2 = [[PosterModel alloc] init];
    model2.imageURL = [childdic objectForKey:@"pic_link"];
    model2.firstName = [nameArr2 objectAtIndex:0];
    model2.secondName = [nameArr2 objectAtIndex:1];
    [_todayPosterArray addObject:model2];
    [self createPosterViewWithArray:_todayPosterArray];
}

#pragma mark ---JSON  解析 ----

- (void)setInfo{
    //导航栏标题
 
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 40)];
    UIImage *image = [UIImage imageNamed:@"font-logo.png"];
    imageView.image = image;
    self.navigationItem.titleView = imageView;
 //   NSLog(@"%f", self.widthView.constant);
    //左边返回按钮
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-xiaolu.png"]];
    leftImage.frame = CGRectMake(0, 0, 64, 40);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftImage];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边登陆按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:LOADIMAGE(@"icon-gerenzhongxin.png")];
    rightImageView.frame = CGRectMake(14, 5, 29, 33);
    [rightButton addSubview:rightImageView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 1, 40)];
    view.backgroundColor = [UIColor darkGrayColor];
    [rightButton addSubview:view];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

- (void)setTitleImage{
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(8, 1, 200, 26)];
    imageView.image = [UIImage imageNamed:@"font-xinpin.png"];
    [self.headView addSubview:imageView];
}

- (void)createPosterViewWithArray:(NSMutableArray *)array{
    for(UIView *view in [_posterView subviews])
    {
        [view removeFromSuperview];
    }
    if ([array count] == 0) {
        [self createDefaultPosterView];
        return;
    }
    for (int i = 0; i<2; i++) {
        [[NSBundle mainBundle] loadNibNamed:@"PosterView" owner:posterViewOwner options:nil];
        CGRect rect = CGRectMake(0, 0 + 185 * i, SCREENWIDTH, 185);
        posterViewOwner.posterView.frame = rect;
        PosterModel *model = (PosterModel *)[array objectAtIndex:i];
        posterViewOwner.leftLabel.text = model.firstName;
        posterViewOwner.rightLabel.text = model.secondName;
        [posterViewOwner.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
        [_posterView addSubview:posterViewOwner.posterView];
        CGRect btnframe = CGRectMake(0, 0+185*i, SCREENWIDTH, 185);
        UIButton *btn = [[UIButton alloc] initWithFrame:btnframe];
        btn.tag = 200 + i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_posterView addSubview:btn];
        NSInteger margin;
        if (isToday) {
            margin = 0;
        } else{
            margin = 30;
        }
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 135 +margin, 120, 180, 24)];
        timeView.tag = 888;
        timeView.backgroundColor = [UIColor blackColor];
        timeView.layer.cornerRadius = 12;
        timeView.alpha = 0.7f;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-shengyu2.png"]];
        imageView.frame = CGRectMake(4, 2, 16, 16);
        imageView.userInteractionEnabled = NO;
        [timeView addSubview:imageView];
   

        if (i == 0) {
            poster1TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 2, 160, 20)];
            poster1TimeLabel.textColor = [UIColor whiteColor];
            [timeView addSubview:poster1TimeLabel];
        }
        
        if (i == 1) {
            poster2TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 2, 160, 20)];
            poster2TimeLabel.textColor = [UIColor whiteColor];
            [timeView addSubview:poster2TimeLabel];
            
        }
        [posterViewOwner.posterView addSubview:timeView];
        
        
       
    }
    
    static int i = 0;
    if (i++ == 0) {
        [self createShoppingCart];
        [self createGotoTopView];
    }
    
}



- (void)createDefaultPosterView{
    
    for (int i = 0; i<2; i++) {
        [[NSBundle mainBundle] loadNibNamed:@"PosterView" owner:posterViewOwner options:nil];
        CGRect rect = CGRectMake(0, 0 + 185 * i, SCREENWIDTH, 185);
        posterViewOwner.posterView.frame = rect;
        [_posterView addSubview:posterViewOwner.posterView];
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        btn.tag = 200 + i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_posterView addSubview:btn];
    }

}

- (void) createChildViewWithArray:(NSMutableArray *)array{
    for (UIView *view in [_childView subviews]) {
        [view removeFromSuperview];
    }
    if ([array count] == 0) {
        [self createDefaultChildView];
        return;
    }
    
    [self.childView addSubview:[self createHeadViewWithTitle:@"潮童专区"]];

    childTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-140, 5, 160, 30)];
    childTimeLabel.font = [UIFont boldSystemFontOfSize:18];
    childTimeLabel.textColor = [UIColor whiteColor];
    [self.childView addSubview:childTimeLabel];
    
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:ownerGoodsView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerGoodsView.view.frame = rect;
            PeopleModel *model = (PeopleModel *)[array objectAtIndex:(i*2 + j)];
            [ownerGoodsView.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
            ownerGoodsView.nameLabel.text = model.name;
            ownerGoodsView.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            ownerGoodsView.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
        
            
            [_childView addSubview:ownerGoodsView.view];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 300;
            if (model.isSaleOut) {
        
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2-40, 50, 80, 80)];
                view.backgroundColor = [UIColor darkGrayColor];
                view.layer.cornerRadius = 40;
                view.alpha = 1;
                view.userInteractionEnabled = NO;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
                label.text = @"抢光了";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                view.alpha = 0.7;
                label.font = [UIFont boldSystemFontOfSize:24];
                label.userInteractionEnabled = NO;
                [view addSubview:label];
                UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 220)];
                frontView.backgroundColor = [UIColor blackColor];
                frontView.alpha = 0.3;
                frontView.userInteractionEnabled = NO;
                [btn addSubview:frontView];
                [btn addSubview:view];
            } else{
                btn.backgroundColor = [UIColor clearColor];

            }
            
            
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_childView addSubview:btn];
        }
    }
}

- (void)createDefaultChildView{
    
    [self.childView addSubview:[self createHeadViewWithTitle:@"潮童专区"]];
    
    
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:ownerGoodsView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerGoodsView.view.frame = rect;
            [_childView addSubview:ownerGoodsView.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 300;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_childView addSubview:btn];
        }
    }
    
}

- (void)createLadyViewWithArray:(NSMutableArray *)array{
    for (UIView *view in [_ladyView subviews]) {
        [view removeFromSuperview];
    }
    
    if ([array count] == 0) {
        [self createDefaultLadyView];
        return;
    }
    
    [self.ladyView addSubview:[self createHeadViewWithTitle:@"时尚女装"]];
    
    ladyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-140, 5, 160, 30)];
    ladyTimeLabel.font = [UIFont boldSystemFontOfSize:18];
    ladyTimeLabel.textColor = [UIColor whiteColor];
    [self.ladyView addSubview:ladyTimeLabel];
    
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
  
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:ownerLadyView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerLadyView.view.frame = rect;
            PeopleModel *model = (PeopleModel *)[array objectAtIndex:i*2 + j];
            [ownerLadyView.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
            ownerLadyView.nameLabel.text = model.name;
            ownerLadyView.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            ownerLadyView.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
            [_ladyView addSubview:ownerLadyView.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 400;
            if (model.isSaleOut) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(width/2-40, 50, 80, 80)];
                view.backgroundColor = [UIColor darkGrayColor];
                view.layer.cornerRadius = 40;
                view.alpha = 1;
                view.userInteractionEnabled = NO;
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 40)];
                label.text = @"抢光了";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                view.alpha = 0.7;
                label.font = [UIFont boldSystemFontOfSize:24];
                label.userInteractionEnabled = NO;
                [view addSubview:label];
                UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 220)];
                frontView.backgroundColor = [UIColor blackColor];
                frontView.alpha = 0.3;
                frontView.userInteractionEnabled = NO;
                [btn addSubview:frontView];
                [btn addSubview:view];
            } else{
                btn.backgroundColor = [UIColor clearColor];

            }
            
            
            
            
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_ladyView addSubview:btn];
        }
    }
    
}

- (UIImageView *)createHeadViewWithTitle:(NSString *)name {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    imageView.backgroundColor = [UIColor colorWithR:84 G:199 B:189 alpha:1];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 16, 16)];
    view.layer.cornerRadius = 4;
    view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = name;
    label.textColor = [UIColor whiteColor];
    label.font =[UIFont fontWithName:@"LiHei Pro" size:18];
    [imageView addSubview:label];
    UIImageView *timeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-shengyu2.png"]];
    timeview.frame = CGRectMake(SCREENWIDTH - 170, 8, 24, 24);
    [imageView addSubview:timeview];
   
    
    return imageView;
}

- (void)createDefaultLadyView{
    
    [self.ladyView addSubview:[self createHeadViewWithTitle:@"时尚女装"]];
    
    
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"LadyView" owner:ownerLadyView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerLadyView.view.frame = rect;
            [_ladyView addSubview:ownerLadyView.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 400;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_ladyView addSubview:btn];
        }
    }
    
}



#pragma mark ------btnclicked--------

- (void)login:(UIButton *)button{
    PersonCenterViewController *personCenter = [[PersonCenterViewController alloc] init];
    [self.navigationController pushViewController:personCenter animated:YES];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 101) {
        sender.backgroundColor = [UIColor colorWithR:84 G:199 B:189 alpha:1];
        UIButton *btn = (UIButton *)[self.view viewWithTag:102];
        btn.backgroundColor = [UIColor colorWithR:250 G:172 B:20 alpha:1];
        if (!isToday) {
            isToday = YES;
            self.headViewHeight.constant = 30;

            [self createPosterViewWithArray:_todayPosterArray];
            [self createChildViewWithArray:_todayPromoteChildArray];
            [self createLadyViewWithArray:_todayPromoteLadyArray];
        }
    } else if (sender.tag == 102){
        if (isFirst) {
            isFirst = NO;
            [self downloadPreData];
        }
        sender.backgroundColor = [UIColor colorWithR:84 G:199 B:189 alpha:1];
        UIButton *btn = (UIButton *)[self.view viewWithTag:101];
        btn.backgroundColor = [UIColor colorWithR:250 G:172 B:20 alpha:1];
        if (isToday) {
            isToday = NO;
            self.headViewHeight.constant = 0;

            [self createPosterViewWithArray:_prePosterArray];
            [self createChildViewWithArray:_prePromoteChildArray];
            [self createLadyViewWithArray:_prePromoteLadyArray];
        }
    } else if (sender.tag == 103){
        
        ChildViewController *childVC = [[ChildViewController alloc] init];
        [self.navigationController pushViewController:childVC animated:YES];
        
    } else if (sender.tag == 104){
        
        WomanViewController *womanVC = [[WomanViewController alloc] init];
        [self.navigationController pushViewController:womanVC animated:YES];
    
    }
}

- (void)imageClicked:(UIButton *)button{
    if (button.tag == 200) {
        
        WomanViewController *womanVC = [[WomanViewController alloc] init];
        [self.navigationController pushViewController:womanVC animated:YES];
    
    
    
    } else if (button.tag == 201){
        ChildViewController *childVC = [[ChildViewController alloc] init];
        [self.navigationController pushViewController:childVC animated:YES];
    
    
    
    }
}

- (void)goodsClicked:(UIButton *)button{
    if (button.tag == 300) {
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = [_todayPromoteChildArray objectAtIndex:0];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];          ;
            }
        } else {
            PeopleModel *model = [_prePromoteChildArray objectAtIndex:0];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        }
    } else if (button.tag == 301){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = [_todayPromoteChildArray objectAtIndex:1];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        } else {
            PeopleModel *model = [_prePromoteChildArray objectAtIndex:1];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        }
    } else if (button.tag == 302){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = [_todayPromoteChildArray objectAtIndex:2];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        } else {
            PeopleModel *model = [_prePromoteChildArray objectAtIndex:2];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        }
        
    } else if (button.tag == 303){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = [_todayPromoteChildArray objectAtIndex:3];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        } else {
            PeopleModel *model = [_prePromoteChildArray objectAtIndex:3];
            if (model.productModel != nil) {
                [self downloadModelListDataWithProductModel:model.productModel];
            } else {
                [self downloadDetailsDataWithChildModel:model];
            }
        }
    } else if (button.tag == 400){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = _todayPromoteLadyArray[0];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        } else {
            PeopleModel *model = _prePromoteLadyArray[0];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        }
    } else if (button.tag == 401){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = _todayPromoteLadyArray[1];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        } else {
            PeopleModel *model = _prePromoteLadyArray[1];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        }
    } else if (button.tag == 402){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = _todayPromoteLadyArray[2];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        } else {
            PeopleModel *model = _prePromoteLadyArray[2];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        }
    } else if (button.tag == 403){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        if (isToday) {
            PeopleModel *model = _todayPromoteLadyArray[3];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        } else {
            PeopleModel *model = _prePromoteLadyArray[3];
            if (model.productModel == nil) {
                [self downloadDetailsDataWithLadyModel:model];
            }else{
                [self downloadModelListDataWithProductModel:model.productModel];
            }
        }
    }
}

#pragma mark ---下载集合商品页面 和 商品详情页

- (void)downloadModelListDataWithProductModel:(NSDictionary *)productModel{
    NSString *modelID = [productModel objectForKey:@"id"];
    NSMutableString *stringUrl = [NSMutableString stringWithFormat:@"%@/rest/v1/products/modellist/",Root_URL];
   [stringUrl appendString:[NSString stringWithFormat:@"%@", modelID]];
    
    
    MMLOG(stringUrl);
    
    
    [self downLoadWithURLString:stringUrl andSelector:@selector(fetchedModelListData:)];
}
- (void)downloadDetailsDataWithChildModel:(PeopleModel *)model{
    
    MMLOG(model.url);
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details",Root_URL ,model.uid];
    MMLOG(urlString);
    [self downLoadWithURLString:urlString andSelector:@selector(fetchedDetailsData1:)];
}

- (void)downloadDetailsDataWithLadyModel:(PeopleModel *)model{
    [self downloadDetailsDataWithChildModel:model];
}

#pragma mark ----商品详情数据解析，商品集合数据解析

- (void)fetchedDetailsData1:(NSData *)responseData{
    NSError *error = nil;
    NSDictionary *detailsInfo = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
  // MMLOG(detailsInfo);
    //商品详情 json 数据解析
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
    NSMutableArray *isSaleOutArray = [[NSMutableArray alloc] init];

    for (NSDictionary *dic in goodsArray) {
        NSString *size = [dic objectForKey:@"name"];
        NSString *sku = [dic objectForKey:@"id"];
        [arrayData addObject:size];
        [skuArray addObject:sku];
        NSString *str = [dic objectForKey:@"is_saleout"];
        [isSaleOutArray addObject:str];
    }
    model.sizeArray = arrayData;
    model.skuIDArray = skuArray;
    model.itemID = [detailsInfo objectForKey:@"id"];
      model.skuIsSaleOutArray = isSaleOutArray;
    MMLOG(model.sizeArray);
    MMLOG(model.skuIDArray);
    MMLOG(model.skuIsSaleOutArray);
  
    

 
    
    
    
    NSDictionary *dic2 = [detailsInfo objectForKey:@"details"];
    model.headImageURLArray = [dic2 objectForKey:@"head_imgs"];
    model.contentImageURLArray = [dic2 objectForKey:@"content_imgs"];
    
    DetailViewController *detailsVC = [[DetailViewController alloc] init];
    detailsVC.detailsModel = model;
 //   NSLog(@"hello");
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)fetchedModelListData:(NSData *)responseDate{
    
    NSError *error = nil;
    NSArray *modelListArray = [NSJSONSerialization JSONObjectWithData:responseDate options:kNilOptions error:&error];
     MMLOG(modelListArray);
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
        
        NSLog(@"%@", model.imageURL);
        
        [_ModelListArray addObject:model];
    }
    
    CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
    collectionVC.collectionArray = _ModelListArray;
    
    MMLOG(collectionVC.collectionArray);
  
    
    [self.navigationController pushViewController:collectionVC animated:YES];
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
