//
//  DetailViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/4.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageWithUrl.h"
#import "MMClass.h"
#import "PurchaseViewController.h"
#import "EnterViewController.h"
#import "AFNetworking.h"
#import "CartViewController.h"
#import "EmptyCartViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate,NSURLConnectionDataDelegate>{
    NSMutableArray *imageArray;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *myTimer;
    NSString *selectSize;
    NSString *selectskuID;
    NSInteger goodsCount;
    UILabel *countLabel;
}

@end

@implementation DetailViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.headHeight.constant = 0;
    
}

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


- (void)setviewInfo{
    self.nameLabel.text = _detailsModel.name;
    self.priceLabel.text = _detailsModel.price;
    self.oldPriceLabel.text = _detailsModel.oldPrice;
    self.productNameLabel.text = _detailsModel.name;
    self.productName.text = _detailsModel.productID;
    
    selectSize = @"";
    
    NSArray *sizeArray = _detailsModel.sizeArray;
    NSArray *isSaleoutArray = _detailsModel.skuIsSaleOutArray;
    NSLog(@"saleArray = %@", isSaleoutArray);
    NSArray *buttonArray = @[self.sizebtn1, self.sizeBtn2, self.sizeBtn3, self.sizeBtn4, self.sizeBtn5, self.sizeBtn6, self.sizeBtn7, self.sizeBtn8];
    NSLog(@"sizeArray = %@", sizeArray);
    NSLog(@"sku array = %@", _detailsModel.skuIDArray);
    int i = 0;
    for (NSString *sizeName in sizeArray) {
        BOOL isSaleout = [[isSaleoutArray objectAtIndex:i] boolValue];
        NSLog(@"%d", isSaleout);
        if (isSaleout) {
             NSLog(@"抢光了");
             UIButton *btn = [buttonArray objectAtIndex:i++];
             [btn setTitle:sizeName forState:UIControlStateNormal];
             [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
        }else{
            UIButton *btn = [buttonArray objectAtIndex:i++];
            [btn setTitle:sizeName forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
      
    }
    
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 44)];
    navLabel.text = @"商品详情";
    navLabel.textColor = [UIColor colorWithR:105 G:59 B:29 alpha:1];
    navLabel.font = [UIFont boldSystemFontOfSize:24];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    NSLog(@"商品详情");
    [self setviewInfo];
  
    self.headWidth.constant = SCREENWIDTH;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 18, 31);
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhui2.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.headImageUrlArray = self.detailsModel.headImageURLArray;
    self.contentImageUrlArray = self.detailsModel.contentImageURLArray;
    imageArray = [[NSMutableArray alloc] init];
    
    for (NSString *headImageUrl in self.headImageUrlArray) {
        UIImage *image = [UIImage imagewithURLString:headImageUrl];
        [imageArray addObject:image];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
    _scrollView.backgroundColor = [UIColor orangeColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    UIImageView *firstView = [[UIImageView alloc] initWithImage:[imageArray lastObject]];
    CGFloat width = _scrollView.frame.size.width;
    CGFloat height = _scrollView.frame.size.height;
    firstView.frame = CGRectMake(0, 0, width, height);
    [_scrollView addSubview:firstView];
    
    //set last as the first
    
    
    for (int i = 0; i<[imageArray count]; i++) {
        UIImageView *subViews = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        subViews.frame = CGRectMake(width*(i+1), 0, width, height);
        [_scrollView addSubview:subViews];
    }
    
    //set the first as the last
    
    UIImageView *lastView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    lastView.frame = CGRectMake(width * (imageArray.count + 1), 0, width, height);
    [_scrollView addSubview:lastView];
    
    [_scrollView setContentSize:CGSizeMake(width * (imageArray.count + 2), height)];
    [self.headView addSubview:_scrollView];
    [_scrollView scrollRectToVisible:CGRectMake(width, 0, width, height) animated:NO];
    //设置pageController的位置以及相关属性
    
    CGRect pageControlFrame = CGRectMake(100, height - 30, 78, 36);
    
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    _pageControl.bounds = CGRectMake(0, 0, 16*(_pageControl.numberOfPages - 1), 16);
    [_pageControl.layer setCornerRadius:8];
    _pageControl.numberOfPages = imageArray.count;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    _pageControl.enabled = YES;
    [self.headView addSubview:_pageControl];
    
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    
    
    long contentNumber =(long) self.contentImageUrlArray.count;
    
    for (long i = 0; i<contentNumber; i++) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:i]] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (i == 0) {
                self.view1Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView1.image = image;
            } else if(i == 1){
                self.view2Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView2.image = image;
            }else if(i == 2 ){
                self.view3Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView3.image = image;
            }else if(i == 3){
                self.view4Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView4.image = image;
            }else if(i == 4){
                self.view5Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView5.image = image;
            }else if(i == 5){
                self.view6Height.constant = image.size.height/image.size.width*SCREENWIDTH;
                self.imageView6.image = image;
            }
            

        }];
    }
    for (long i = 6; i > contentNumber; i--) {
        if (i == 6) {
            self.view6Height.constant = 0;
        } else if(i == 5){
            self.view5Height.constant = 0;
        }else if(i == 4 ){
            self.view4Height.constant = 0;
        }else if(i == 3){
            self.view3Height.constant = 0;
        }else if(i == 2){
            self.view2Height.constant = 0;
        }else if(i == 1){
            self.view1Height.constant = 0;
        }
    }
    
    [self.view addSubview:_scrollerView];
    [self createGotoTopView];
    [self createShoppingCart];
}


- (void)createShoppingCart{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, SCREENHEIGHT - 110 - 8, 60, 60)];
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
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    countLabel.layer.cornerRadius = 10;
    countLabel.userInteractionEnabled = NO;
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
    [button addSubview:view];
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

- (void)createGotoTopView{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 68, SCREENHEIGHT - 110 - 8, 60, 60)];
    button.layer.cornerRadius = 30;
    [self.view addSubview:button];
    [button setBackgroundImage:[UIImage imageNamed:@"icon-fanhuidingbu.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoTopClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:button];
    button.alpha = 0.5;
    
}
- (void)gotoTopClicked:(UIButton *)btn{
    NSLog(@"gouguche ");
    [UIView animateWithDuration:0.5f animations:^{
        self.scrollerView.contentOffset = CGPointMake(0, 0);
        
    }];
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pageTurn:(UIPageControl *)sender{
    long pageNum=_pageControl.currentPage;
    CGSize viewSize=_scrollView.frame.size;
    [_scrollView setContentOffset:CGPointMake((pageNum+1)*viewSize.width, 0)];
    NSLog(@"myscrollView.contentOffSet.x==%f",_scrollView.contentOffset.x);
    NSLog(@"pageControl currentPage==%ld",(long)_pageControl.currentPage);
    [myTimer invalidate];
    
}

- (void)scrollToNextPage:(id)sender{
    
    long pageNum=_pageControl.currentPage;
    CGSize viewSize=_scrollView.frame.size;
    
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    if (pageNum==imageArray.count) {
        CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [_scrollView scrollRectToVisible:newRect animated:NO];
    }
    
    
}

#pragma mark ---UIScrollView Delegate----

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth=_scrollView.frame.size.width;
    int currentPage=floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        _pageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        _pageControl.currentPage=0;
    }
    _pageControl.currentPage=currentPage-1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [myTimer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat pageWidth=_scrollView.frame.size.width;
    CGFloat pageHeigth=_scrollView.frame.size.height;
    int currentPage=floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",_scrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [_scrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage=imageArray.count-1;
        NSLog(@"pageControl currentPage==%ld",(long)_pageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [_scrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        _pageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%ld",(long)_pageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    _pageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%ld",(long)_pageControl.currentPage);
    
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

- (void)login:(UIButton *)button
{
    NSLog(@"登录");
}




- (IBAction)selectSize:(id)sender {
    UIButton *button = (UIButton *)sender;
    int length = (int)self.detailsModel.sizeArray.count;
    for (int i = 601; i< 601 + length; i++) {
        if (button.tag == i) {
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor lightGrayColor];
            selectSize = [self.detailsModel.sizeArray objectAtIndex:i-601];
            NSLog(@"selectSize = %@", selectSize);
            selectskuID = [self.detailsModel.skuIDArray objectAtIndex:i-601];
            NSLog(@"sku_id = %@", selectskuID);
        }
        else{
            UIButton *btn = (UIButton *)[self.view viewWithTag:i];
            if (btn.userInteractionEnabled) {
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else{
                    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        
            btn.backgroundColor = [UIColor clearColor];
          //  NSLog(@"2222");
        }
    }
  //  NSLog(@"btn.tag = %d", (int)button.tag);
    for (int i = 608; i> 601+length-1; i--) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        btn.userInteractionEnabled = NO;
       // btn.backgroundColor = [UIColor redColor];
    }
    
    
    
    
    
    
}

- (IBAction)addCart:(id)sender {
    NSLog(@"加入购物车");

    BOOL islogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (islogin) {
        if ([selectSize isEqualToString:@""]) {
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
                NSLog(@"item_id = %@", _detailsModel.itemID);
                NSLog(@"sku_id = %@", selectskuID);
                
                
//                //第一步，创建url
//                
//                NSURL *url = [NSURL URLWithString:@"http://youni.huyi.so/rest/v1/carts"];
//                
//                //第二步，创建请求
//                
//                NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//                
//                [request setHTTPMethod:@"POST"];
//                
//                NSString *str = [NSString stringWithFormat:@"item_id=%@&sku_id=%@", _detailsModel.itemID, selectskuID];
//                
//                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//                
//               [request setHTTPBody:data];
//                
//                //第三步，连接服务器
//                
//                NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//                NSLog(@"%@", connection);
                
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
               
                NSDictionary *parameters = @{@"item_id": _detailsModel.itemID,
                                             @"sku_id":selectskuID};
                
                [manager POST:kCart_URL parameters:parameters
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          
                          NSLog(@"JSON: %@", responseObject);
                          
                          
                          
                          
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
                          //NSLog(@"operation: %@", operation);

                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          //NSLog(@"operation: %@", operation);

                          NSLog(@"Error: %@", error);
                          
                      }];
                
                
                
            }
    }else{
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }
    
}

#pragma mark --NSURLConnectionDataDelegate--

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
   // NSLog(@"data");
   // NSLog(@"%@", data);
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"string = %@", str);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"finished");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (IBAction)purchase:(id)sender {
    NSLog(@"立即购买");
   BOOL islogin = [[NSUserDefaults standardUserDefaults]boolForKey:kIsLogin];
    if (islogin) {
        if ([selectSize isEqualToString:@""]) {
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
        }

    } else{
        EnterViewController *enterVC = [[EnterViewController alloc] initWithNibName:@"EnterViewController" bundle:nil];
        [self.navigationController pushViewController:enterVC animated:YES];
    }

}
@end
