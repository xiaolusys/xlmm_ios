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

@interface RootViewController (){
    BOOL isToday;
    NSMutableArray *_prePosterArray;
    NSMutableArray *_todayPosterArray;
    NSMutableArray *_todayPromoteChildArray;
    NSMutableArray *_todayPromoteLadyArray;
    NSMutableArray *_prePromoteChildArray;
    NSMutableArray *_prePromoteLadyArray;
    
    NSMutableData *_data;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //自定义导航栏信息
    isToday = YES;
    self.title = @"小鹿美美";
    self.widthView.constant = SCREENWIDTH;
    self.posterView.frame = CGRectMake(0, 84, SCREENWIDTH, 370);
    self.childView.frame = CGRectMake(0, 454, SCREENWIDTH, 500);
    self.ladyView.frame = CGRectMake(0, 954, SCREENWIDTH, 500);
    [self setInfo];
    [self setTitleImage];
    
#if 1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://youni.huyi.so/rest/v1/posters/today"]];
        [self performSelectorOnMainThread:@selector(fetchedTodayPosterData:) withObject:data waitUntilDone:YES];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://youni.huyi.so/rest/v1/posters/previous"]];
        [self performSelectorOnMainThread:@selector(fetchedPreviousPosterData:) withObject:data waitUntilDone:YES];
        
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://youni.huyi.so/rest/v1/products/promote_today"]];
        [self performSelectorOnMainThread:@selector(fetchedTodaypromoteData:) withObject:data waitUntilDone:YES];
        
    });

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://youni.huyi.so/rest/v1/products/promote_today"]];
        [self performSelectorOnMainThread:@selector(fetchedTodaypromoteData:) withObject:data waitUntilDone:YES];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://youni.huyi.so/rest/v1/products/promote_previous"]];
        [self performSelectorOnMainThread:@selector(fetchedPreviouspromoteData:) withObject:data waitUntilDone:YES];
    });
#endif
}

- (void)updateData{
  
}

- (void) fetchedPreviouspromoteData:(NSData *)responseData{
    NSError *error;
    _prePromoteChildArray = [[NSMutableArray alloc] init];
    _prePromoteLadyArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *childArray = [dic objectForKey:@"child_list"];
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        ChildModel *model = [[ChildModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
        [_prePromoteChildArray addObject:model];
    }
   // [self createChildViewWithArray:_prePromoteChildArray];
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
   // [self createLadyViewWithArray:_prePromoteLadyArray];
}

- (void) fetchedTodaypromoteData:(NSData *)responseData{
    NSError *error;
    _todayPromoteChildArray = [[NSMutableArray alloc] init];
    _todayPromoteLadyArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *childArray = [dic objectForKey:@"child_list"];
    for (int i = 0; i<4; i++) {
        NSDictionary *child = [childArray objectAtIndex:i];
        ChildModel *model = [[ChildModel alloc] init];
        model.imageURL = [child objectForKey:@"pic_path"];
        model.name = [child objectForKey:@"name"];
        model.price = [child objectForKey:@"agent_price"];
        model.oldPrice = [child objectForKey:@"std_sale_price"];
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
        [_todayPromoteLadyArray addObject:model];
    }
    [self createLadyViewWithArray:_todayPromoteLadyArray];
}

- (void) fetchedPreviousPosterData:(NSData *)responseData{
    NSError *error;
    _prePosterArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
    NSArray *wemArray = [dic objectForKey:@"wem_posters"];
    NSDictionary *wonmendic = [wemArray objectAtIndex:0];
    NSArray *nameArr = [wonmendic objectForKey:@"subject"];
    PosterModel *model = [PosterModel new];
    model.imageURL = [wonmendic objectForKey:@"pic_link"];
    model.firstName = [nameArr objectAtIndex:0];
    model.secondName = [nameArr objectAtIndex:1];
    [_prePosterArray addObject:model];
    PosterModel *model2 = [[PosterModel alloc] init];
    NSArray *childArray = [dic objectForKey:@"chd_posters"];
    NSDictionary *childdic = [childArray objectAtIndex:0];
    NSArray *nameArr2 = [childdic objectForKey:@"subject"];
    model2.imageURL = [childdic objectForKey:@"pic_link"];
    model2.firstName = [nameArr2 objectAtIndex:0];
    model2.secondName = [nameArr2 objectAtIndex:1];
    [_prePosterArray addObject:model2];
  //  [self createPosterViewWithArray:_prePosterArray];
}
- (void)fetchedTodayPosterData:(NSData *)responseData{
    NSError *error;
    _todayPosterArray = [[NSMutableArray alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *wemArray = [dic objectForKey:@"wem_posters"];
    NSDictionary *wonmendic = [wemArray objectAtIndex:0];
    NSArray *nameArr = [wonmendic objectForKey:@"subject"];
    PosterModel *model = [PosterModel new];
    model.imageURL = [wonmendic objectForKey:@"pic_link"];
    model.firstName = [nameArr objectAtIndex:0];
    model.secondName = [nameArr objectAtIndex:1];
    [_todayPosterArray addObject:model];
    PosterModel *model2 = [[PosterModel alloc] init];
    NSArray *childArray = [dic objectForKey:@"chd_posters"];
    NSDictionary *childdic = [childArray objectAtIndex:0];
    NSArray *nameArr2 = [childdic objectForKey:@"subject"];
    model2.imageURL = [childdic objectForKey:@"pic_link"];
    model2.firstName = [nameArr2 objectAtIndex:0];
    model2.secondName = [nameArr2 objectAtIndex:1];
    [_todayPosterArray addObject:model2];
    [self createPosterViewWithArray:_todayPosterArray];
}

- (void)setInfo{
    //导航栏标题
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = KTITLENAME;
    navLabel.textColor = [UIColor orangeColor];
    navLabel.font = [UIFont systemFontOfSize:30];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    NSLog(@"%f", self.widthView.constant);
    //左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40 , 40);
    [backButton setBackgroundImage:LOADIMAGE(@"goodsthumb.png") forState:UIControlStateNormal];
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
    NSLog(@"posterView");
    PosterView *owner = [PosterView new];
    for (int i = 0; i<2; i++) {
        [[NSBundle mainBundle] loadNibNamed:@"PosterView" owner:owner options:nil];
        CGRect rect = CGRectMake(0, 0 + 185 * i, SCREENWIDTH, 185);
        owner.posterView.frame = rect;
        PosterModel *model = (PosterModel *)[array objectAtIndex:i];
        owner.leftLabel.text = model.firstName;
        owner.rightLabel.text = model.secondName;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageURL]]];
        owner.imageView.image = image;
        [self.posterView addSubview:owner.posterView];
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        btn.tag = 200 + i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.posterView addSubview:btn];
    }
    
}

- (void) createChildViewWithArray:(NSMutableArray *)array{
    NSLog(@"childView");
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
    GoodsView *owner = [GoodsView new];
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"GoodsView" owner:owner options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            owner.view.frame = rect;
            ChildModel *model = (ChildModel *)[array objectAtIndex:(i*2 + j)];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageURL]]];
            owner.imageView.image = image;
            owner.nameLabel.text = model.name;
            owner.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            owner.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
            [self.childView addSubview:owner.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 300;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.childView addSubview:btn];
        }
    }
}

- (void)createLadyViewWithArray:(NSMutableArray *)array{
    NSLog(@"LadyView");
    
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
    LadyView *owner = [LadyView new];
    for (int i = 0; i<2; i++) {
        for (int j = 0; j<2; j++) {
            [[NSBundle mainBundle] loadNibNamed:@"LadyView" owner:owner options:nil];
            CGRect rect = CGRectMake(margin + (margin + width) * j,40 + margin + height * i, width, height);
            owner.view.frame = rect;
            LadyModel *model = (LadyModel *)[array objectAtIndex:i*2 + j];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageURL]]];
            owner.imageView.image = image;
            owner.nameLabel.text = model.name;
            owner.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
            owner.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
            [self.ladyView addSubview:owner.view];
            UIButton *btn = [[UIButton alloc] initWithFrame:rect];
            btn.tag = i*2 +j + 400;
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(goodsClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.ladyView addSubview:btn];
        }
    }
}



#pragma mark ------btnclicked--------

- (void)login:(UIButton *)button{
    LogInViewController *login = [[LogInViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)backButtonClicked:(UIButton *)button{
    NSLog(@"back");
}

- (IBAction)btnClicked:(UIButton *)sender {
    for (int i = 101; i<= 104; i++) {
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
            NSLog(@"今日上新");
            [self createPosterViewWithArray:_todayPosterArray];
            [self createChildViewWithArray:_todayPromoteChildArray];
            [self createLadyViewWithArray:_todayPromoteLadyArray];
            self.headViewHeight.constant = 40;

        }
    } else if (sender.tag == 102){
        if (isToday) {
            
            isToday = NO;
            NSLog(@"昨日特卖");
            [self createPosterViewWithArray:_prePosterArray];
            [self createChildViewWithArray:_prePromoteChildArray];
            [self createLadyViewWithArray:_prePromoteLadyArray];
            self.headViewHeight.constant = 0;
        }
    } else if (sender.tag == 103){
        NSLog(@"103");
    } else if (sender.tag == 104){
        NSLog(@"104");
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
        NSLog(@"300");
    } else if (button.tag == 301){
        NSLog(@"301");
    } else if (button.tag == 302){
        NSLog(@"302");
    } else if (button.tag == 303){
        NSLog(@"303");
    } else if (button.tag == 400){
        NSLog(@"400");
    } else if (button.tag == 401){
        NSLog(@"401");
    } else if (button.tag == 402){
        NSLog(@"402");
    } else if (button.tag == 403){
        NSLog(@"403");
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
