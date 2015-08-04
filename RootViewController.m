//
//  RootViewController.m
//  XLMM
//
//  Created by younishijie on 15/7/29.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "RootViewController.h"
#import "MMClass.h"
#import "PosterView.h"
#import "GoodsView.h"
#import "LadyView.h"
#import "PreviousViewController.h"
#import "PosterModel.h"
#import "ChildModel.h"
#import "LadyModel.h"
#import "LogInViewController.h"
#import "RegisterViewController.h"
#import "UIImageView+WebCache.h"
#import "ChildViewController.h"
#import "WomanViewController.h"
#import "PersonCenterViewController.h"
#import "DetailViewController.h"




@interface RootViewController (){
    BOOL isToday;//

    NSMutableArray *_prePosterArray;//保存昨日海报数据
    NSMutableArray *_todayPosterArray;//存储今日海报数据
    
    NSMutableArray *_todayPromoteChildArray;//今日推荐
    NSMutableArray *_todayPromoteLadyArray;
    
    NSMutableArray *_prePromoteChildArray;//昨日推荐
    NSMutableArray *_prePromoteLadyArray;
    
    //保存下载的数据
    NSMutableData *_data;
    
    //
    PosterView *posterViewOwner;
    GoodsView *ownerGoodsView;
    LadyView *ownerLadyView;

}

@end

@implementation RootViewController



- (void)viewWillAppear:(BOOL)animated{
  //  NSLog(@"appear");
    [super viewWillAppear:animated];
    
    NSArray *buttonArray = [self.buttonView subviews];
    for (UIButton *button in buttonArray) {
        button.backgroundColor = [UIColor clearColor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //自定义导航栏信息
    posterViewOwner = [PosterView new];
    ownerGoodsView = [GoodsView new];
    ownerLadyView = [LadyView new];
    isToday = YES;
//    isLogin = NO;
    //self.title = @"小鹿美美";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:kIsLogin];
    [userDefaults synchronize];
    
    
    self.widthView.constant = SCREENWIDTH;//设置视图的大小
    self.posterView.frame = CGRectMake(0, 84, SCREENWIDTH, 370);
    self.childView.frame = CGRectMake(0, 454, SCREENWIDTH, 500);
    self.ladyView.frame = CGRectMake(0, 954, SCREENWIDTH, 500);
    [self setInfo];
    [self setTitleImage];
    [self downloadData];
 
    [self createDefaultLadyView];
    [self createDefaultChildView];
    [self createDefaultPosterView];
    
    
}



- (void)downloadData{

    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(kTODAY_POSTERS_URL)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedTodayPosterData:) withObject:data waitUntilDone:YES];
        
    });//下载今日海报
    
    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(kTODAY_PROMOTE_URL)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedTodaypromoteData:) withObject:data waitUntilDone:YES];
        
    });//下载今日推荐
    
    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(kPREVIOUS_POSTERS_URL)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedPreviousPosterData:) withObject:data waitUntilDone:YES];
        
    });//下载昨日海报
    
    dispatch_async(kBgQueue, ^(){
        NSData *data = [NSData dataWithContentsOfURL:kLoansRRL(kPREVIOUS_PROMOTE_URL)];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedPreviouspromoteData:) withObject:data waitUntilDone:YES];
    });//下载昨日推荐
}

#pragma mark ---JSON 解析 ------
//昨日推荐 JSON 数据解析
- (void) fetchedPreviouspromoteData:(NSData *)responseData{
    NSError *error;
    _prePromoteChildArray = [[NSMutableArray alloc] init];
    _prePromoteLadyArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *childArray = [dic objectForKey:@"child_list"];
   // NSLog(@"previous promote = %@", dic);
    if ([childArray count] == 0) {
        return;
    }
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        ChildModel *model = [[ChildModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
        [_prePromoteChildArray addObject:model];
    }
    [self createChildViewWithArray:_prePromoteChildArray];
    
    NSArray *ladyArray = [dic objectForKey:@"female_list"];
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [ladyArray objectAtIndex:i];
        LadyModel *model = [[LadyModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
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
        
        [self createChildViewWithArray:_todayPromoteChildArray];
        [self createLadyViewWithArray:_todayPromoteLadyArray];
        
        return;
    }
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        ChildModel *model = [[ChildModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];

        NSDictionary *dic = [child objectForKey:@"product_model"];
        if ([dic class] == [NSNull class]) {
            model.productModel = nil;
        } else{
            model.productModel = dic;
            model.headImageURLArray = [dic objectForKey:@"head_imgs"];
            model.contentImageURLArray = [dic objectForKey:@"content_imgs"];
           // NSLog(@"%@\n%@", model.headImageURLArray, model.contentImageURLArray);
            
        }
       
        
        [_todayPromoteChildArray addObject:model];
    }
    [self createChildViewWithArray:_todayPromoteChildArray];
    NSArray *ladyArray = [dic objectForKey:@"female_list"];
    for (int i = 0; i<4; i++) {
        
        NSDictionary *child = [ladyArray objectAtIndex:i];
        LadyModel *model = [[LadyModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
        
        NSDictionary *dic2 = [child objectForKey:@"product_model"];
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
   // NSLog(@"previous poster = %@", dic);
    NSArray *wemArray = [dic objectForKey:@"wem_posters"];
   // NSLog(@"poster Array = %ld", (long)wemArray.count);
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
        [self createPosterViewWithArray:_todayPosterArray];
        
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
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = KTITLENAME;
    navLabel.textColor = [UIColor orangeColor];
    navLabel.font = [UIFont systemFontOfSize:30];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
 //   NSLog(@"%f", self.widthView.constant);
    //左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40 , 40);
    [backButton setBackgroundImage:LOADIMAGE(@"") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边登陆按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 30, 30);
    [rightButton setBackgroundImage:LOADIMAGE(@"goodsthumb.png") forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
}

- (void)setTitleImage{
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 240, 30)];
    imageView.backgroundColor = [UIColor redColor];
    imageView.layer.cornerRadius = 14;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 240, 30)];
    label.text = @"每天10:00  新品上线";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:label];
    self.headView.backgroundColor = [UIColor whiteColor];
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
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        btn.tag = 200 + i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_posterView addSubview:btn];
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    imageView.backgroundColor = [UIColor orangeColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 16, 16)];
    view.layer.cornerRadius = 4;
    view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"潮童专区";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    [imageView addSubview:label];
    UILabel *timaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 140, 30)];
    timaLabel.textAlignment = NSTextAlignmentLeft;
    timaLabel.text = @"剩余2天1小时";
    timaLabel.font = [UIFont systemFontOfSize:16];
    timaLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:timaLabel];
    [self.childView addSubview:imageView];
    
    
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:ownerGoodsView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerGoodsView.view.frame = rect;
            ChildModel *model = (ChildModel *)[array objectAtIndex:(i*2 + j)];
            [ownerGoodsView.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
            ownerGoodsView.nameLabel.text = model.name;
            ownerGoodsView.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            ownerGoodsView.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
        
            
            [_childView addSubview:ownerGoodsView.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 300;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_childView addSubview:btn];
        }
    }
}

- (void)createDefaultChildView{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    imageView.backgroundColor = [UIColor orangeColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 16, 16)];
    view.layer.cornerRadius = 4;
    view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"潮童专区";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    [imageView addSubview:label];
    UILabel *timaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 140, 30)];
    timaLabel.textAlignment = NSTextAlignmentLeft;
    timaLabel.text = @"剩余2天1小时";
    timaLabel.font = [UIFont systemFontOfSize:16];
    timaLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:timaLabel];
    [self.childView addSubview:imageView];
    
    
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    imageView.backgroundColor = [UIColor orangeColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 16, 16)];
    view.layer.cornerRadius = 4;
    view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"时尚女装";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    [imageView addSubview:label];
    UILabel *timaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 140, 30)];
    timaLabel.textAlignment = NSTextAlignmentLeft;
    timaLabel.text = @"剩余2天1小时";
    timaLabel.font = [UIFont systemFontOfSize:16];
    timaLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:timaLabel];
    [self.ladyView addSubview:imageView];
    NSInteger margin = 5;
    NSInteger width = (SCREENWIDTH - 3 * margin)/2;
    NSInteger height = 230;
  
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"LadyView" owner:ownerLadyView options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            ownerLadyView.view.frame = rect;
            LadyModel *model = (LadyModel *)[array objectAtIndex:i*2 + j];
            [ownerLadyView.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
            ownerLadyView.nameLabel.text = model.name;
            ownerLadyView.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            ownerLadyView.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
            [_ladyView addSubview:ownerLadyView.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 400;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_ladyView addSubview:btn];
        }
    }
    
}

- (void)createDefaultLadyView{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    imageView.backgroundColor = [UIColor orangeColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 16, 16)];
    view.layer.cornerRadius = 4;
    view.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:view];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 160, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"时尚女装";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22];
    [imageView addSubview:label];
    UILabel *timaLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH/2, 5, 140, 30)];
    timaLabel.textAlignment = NSTextAlignmentLeft;
    timaLabel.text = @"剩余2天1小时";
    timaLabel.font = [UIFont systemFontOfSize:16];
    timaLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:timaLabel];
    [self.ladyView addSubview:imageView];
    
    
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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [userDefault boolForKey:kIsLogin];
    
    if (!isLogin) {
        
        LogInViewController *login = [[LogInViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    
    }else{
        
        PersonCenterViewController *personCenter = [[PersonCenterViewController alloc] init];
        [self.navigationController pushViewController:personCenter animated:YES];
        
    }
  
}

- (void)backButtonClicked:(UIButton *)button{
    NSLog(@"back");
}

- (IBAction)btnClicked:(UIButton *)sender {
    
    for (int i = 101; i<= 102; i++) {
        if (sender.tag == i) {
            sender.backgroundColor = [UIColor orangeColor];
        } else {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i];
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    if (sender.tag == 101) {
        
        if (!isToday) {
            

            isToday = YES;
            [self createPosterViewWithArray:_todayPosterArray];
            [self createChildViewWithArray:_todayPromoteChildArray];
            [self createLadyViewWithArray:_todayPromoteLadyArray];
            self.headViewHeight.constant = 40;

        }
    } else if (sender.tag == 102){
       
        if (isToday) {

            isToday = NO;
            [self createPosterViewWithArray:_prePosterArray];
            [self createChildViewWithArray:_prePromoteChildArray];
            [self createLadyViewWithArray:_prePromoteLadyArray];
            self.headViewHeight.constant = 0;
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
        NSLog(@"200");
    } else if (button.tag == 201){
        NSLog(@"201");
    }
}

- (void)goodsClicked:(UIButton *)button{
    if (button.tag == 300) {
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        ChildModel *model = [_todayPromoteChildArray objectAtIndex:0];
        if (model.productModel != nil) {
            
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
            
            
        } else{
            NSLog(@"单品");
        }
    } else if (button.tag == 301){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        ChildModel *model = [_todayPromoteChildArray objectAtIndex:1];
        if (model.productModel != nil) {
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
        }else{
            NSLog(@"单品");
        }
        
    } else if (button.tag == 302){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        ChildModel *model = [_todayPromoteChildArray objectAtIndex:2];
        if (model.productModel != nil) {
            
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
        }else{
            NSLog(@"单品");
        }
        
    } else if (button.tag == 303){
        if (_todayPromoteChildArray.count == 0) {
            return;
        }
        ChildModel *model = [_todayPromoteChildArray objectAtIndex:3];
        if (model.productModel != nil) {
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
            
        }else{
            NSLog(@"单品");
        }
        
    } else if (button.tag == 400){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        LadyModel *model = _todayPromoteLadyArray[0];
        if (model.productModel == nil) {
            NSLog(@"单品");
            
     
            
            
            
        }else{
            
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    } else if (button.tag == 401){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        LadyModel *model = _todayPromoteLadyArray[1];
        if (model.productModel == nil) {
            NSLog(@"单品");
        }else{
            
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    } else if (button.tag == 402){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        LadyModel *model = _todayPromoteLadyArray[2];
        if (model.productModel == nil) {
            NSLog(@"单品");
        }else{
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            
            
            [self.navigationController pushViewController:detailVC animated:YES];
        }

    } else if (button.tag == 403){
        if (_todayPromoteLadyArray.count == 0) {
            return;
        }
        LadyModel *model = _todayPromoteLadyArray[3];
        if (model.productModel == nil) {
            NSLog(@"单品");
        }else{
            
            DetailViewController *detailVC = [[DetailViewController alloc] init];
            detailVC.headImageUrlArray = model.headImageURLArray;
            detailVC.contentImageUrlArray = model.contentImageURLArray;
            [self.navigationController pushViewController:detailVC animated:YES];
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


@end
