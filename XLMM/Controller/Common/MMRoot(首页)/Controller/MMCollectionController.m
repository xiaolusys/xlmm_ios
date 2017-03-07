//
//  MMCollectionController.m
//  XLMM
//
//  Created by younishijie on 15/9/2.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "MMCollectionController.h"
#import "BrandGoodsModel.h"
#import "JMRootgoodsCell.h"
#import "CollectionModel.h"
#import "JMGoodsDetailController.h"

@interface MMCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UIButton *topButton;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, assign)NSInteger count;
@end

@implementation MMCollectionController{
    NSTimer *theTimer;
    UILabel *titleLabel;
    NSString *offSheltTime;

    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSLog(@"MMCollectionController initWithNibName1");

    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)dealloc{

}

- (void)viewDidLoad {
    NSLog(@"MMCollectionController viewDidLoad");
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title = @"品牌商品";
    //self.view.backgroundColor = [UIColor redColor];
//    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self createCollectionView];
    [self createInfo];
    [self createButton];
}

- (void)createInfo{
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"品牌商品";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.png"]];
    imageView.frame = CGRectMake(-4, 14, 16, 16);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:flowLayout];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.backgroundColor = [UIColor backgroundlightGrayColor];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = FALSE;
    [collectionView registerClass:[JMRootgoodsCell class] forCellWithReuseIdentifier:@"simpleCell"];
//    [self.view addSubview:[[UIView alloc] init]];

    [self.view addSubview:collectionView];
    self.collectionView  = collectionView;
    
    NSLog(@"Brand COUNT is %lu", (unsigned long)self.dataArray.count);
    [self.collectionView reloadData];

    

}


- (void)reload{
    

        [self.collectionView reloadData];

}

- (void)timerFireMethod:(NSTimer*)theTimer {
    if((self.dataArray == nil) || (self.dataArray.count == 0))
        return;
    CollectionModel *model = [self.dataArray objectAtIndex:0];
    NSString *saleTime = model.saleTime;
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    if((saleTime == nil) || ([saleTime isEqualToString:@""]))
       return;
    
    NSDate *toDate = [formatter dateFromString:saleTime];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   // NSDateComponents *comps =
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:toDate];
  //NSLog(@"comps = %@", comps);
    
    int year=(int)[comps year];
    int month =(int) [comps month];
    int day = (int)[comps day];
    int nextday = day + 1;
    

    NSDate *todate;
    if ((offSheltTime == nil) || ([offSheltTime isEqualToString:@""])) {
       // NSLog(@"默认下架时间");
        NSDateComponents *endTime = [[NSDateComponents alloc] init];    //初始化目标时间...奥运时间好了
        [endTime setYear:year];
        [endTime setMonth:month];
        [endTime setDay:nextday];
        [endTime setHour:14];
        [endTime setMinute:0];
        [endTime setSecond:0];
        
        todate = [calendar dateFromComponents:endTime]; //把目标时间装载入date
        
        //用来得到具体的时差
        
        
    } else{
     //   NSLog(@"特定下架时间");
        NSMutableString *string = [NSMutableString stringWithString:offSheltTime];
        NSRange range = [string rangeOfString:@"T"];
        [string replaceCharactersInRange:range withString:@" "];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        dateformatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        todate = [dateformatter dateFromString:string];
    }

    
    NSDate *date = [NSDate date];
    NSDateComponents *d = [calendar components:unitFlags fromDate:date toDate:todate options:0];
    if ([d hour] < 0 || [d minute] < 0) {
        titleLabel.text = @"已下架";
     //   NSLog(@"已下架");
    } else{
        NSString *string;
        if ((long)[d day] == 0) {
            string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
        }
        else{
            string = [NSString stringWithFormat:@"剩余%02ld天%02ld时%02ld分%02ld秒", (long)[d day],(long)[d hour], (long)[d minute], (long)[d second]];
            
        }
      //  NSString * string = [NSString stringWithFormat:@"剩余%02ld时%02ld分%02ld秒",(long)[d hour], (long)[d minute], (long)[d second]];
    //    NSLog(@"string = %@", string);
        titleLabel.text = string;
    }

    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSLog(@"MMCollectionController numberOfSectionsInCollectionView");
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"MMCollectionController numberOfItemsInSection");
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

 
//    NSLog(@"MMCollectionController sizeForItemAtIndexPath");
    return CGSizeMake((SCREENWIDTH-15)/2, (SCREENWIDTH-15)/2 *8/6+ 60);
    
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JMRootgoodsCell *cell = (JMRootgoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"simpleCell" forIndexPath:indexPath];
    
    
    BrandGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *string = model.product_img;
    
    NSMutableString *newString = [NSMutableString stringWithString:string];
   

    NSLog(@"MMCollectionController cellForItemAtIndexPath newString = %@", newString);
    cell.iconImage.alpha = 0.0f;
    cell.iconImage.contentMode = UIViewContentModeScaleAspectFill;

    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[[newString JMUrlEncodedString] imageCompression]] placeholderImage:[UIImage imageNamed:@"placeHolderImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            cell.iconImage.alpha = 1.0;
        }];
        
        
    }] ;
    cell.titleLabel.text = model.product_name;

    
    if ([model.product_lowest_price integerValue] != [model.product_lowest_price floatValue]) {
        cell.PriceLabel.text = [NSString stringWithFormat:@"¥%.1f", [model.product_lowest_price floatValue]];
    } else {
        cell.PriceLabel.text = [NSString stringWithFormat:@"¥%@", model.product_lowest_price];
    }
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%.1f",[model.product_std_sale_price floatValue]];
    cell.backView.layer.cornerRadius = 30;
    
//    if ([model.isSaleopen boolValue]) {
//        
//        if ([model.isSaleout boolValue]) {
//            cell.backView.hidden = NO;
//        } else{
//            cell.backView.hidden = YES;
//        }
//    } else{
//        cell.backView.hidden = NO;
//        if([model.isNewgood boolValue]){
//            UILabel *label = [cell.backView viewWithTag:100];
//            label.text = @"即将开售";
//        }
//
//    }
    return cell;

}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandGoodsModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.brandID;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
//    WebViewController *webView = [[WebViewController alloc] init];
//    webView.eventLink = model.web_url;
//    webView.goodsID = model.ID;
//    webView.diction = model.productModel;
//
//    [self.navigationController pushViewController:webView animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 添加返回顶部按钮

- (void)createButton {
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-20);
        make.width.height.mas_equalTo(@50);
    }];    [self.topButton setImage:[UIImage imageNamed:@"backTop"] forState:UIControlStateNormal];
    self.topButton.hidden = YES;
    [self.topButton bringSubviewToFront:self.view];
    
}
- (void)topButtonClick:(UIButton *)btn {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    self.topButton.hidden = YES;
}
//
//- (void)hiddenBackTopBtn {
//    [UIView animateWithDuration:0.3 animations:^{
//        self.topButton.hidden = YES;
//    }];
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.topButton.hidden = scrollView.contentOffset.y > SCREENHEIGHT * 2 ? NO : YES;
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenBackTopBtn) userInfo:nil repeats:NO];
//}




@end













