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

@interface DetailViewController ()<UIScrollViewDelegate>{
    NSMutableArray *imageArray;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *myTimer;
    
}

@end

@implementation DetailViewController

- (void)viewDidDisappear:(BOOL)animated{


    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.headImageUrlArray = [[NSMutableArray alloc] init];
//    self.contentImageUrlArray = [[NSMutableArray alloc] init];

#if 1
    
    imageArray = [[NSMutableArray alloc] init];
    
    for (NSString *headImageUrl in self.headImageUrlArray) {
        
//        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:headImageUrl] options:SDWebImageContinueInBackground progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//            [imageArray addObject:image];
//            
//        }];
        
        
        
        
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
    
    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:0]] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
          self.view1Height.constant = image.size.height/image.size.width*SCREENWIDTH;
        self.imageView1.image = image;
    }];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:1]] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.view2Height.constant = image.size.height/image.size.width*SCREENWIDTH;
        self.imageView2.image = image;
    }];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:2]] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.view3Height.constant = image.size.height/image.size.width*SCREENWIDTH;
        self.imageView3.image = image;
    }];

    if (self.contentImageUrlArray.count == 4) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:3]] options:SDWebImageAllowInvalidSSLCertificates progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.view4Height.constant = image.size.height/image.size.width*SCREENWIDTH;
            self.imageView4.image = image;
        }];
        
        

    } else{
        self.view4Height.constant = 0;
    }
 
#endif
    
    // Do any additional setup after loading the view from its nib.
    
    
    
//    self.navigationController.navigationBarHidden = NO;
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.contentImageUrlArray objectAtIndex:1]]]];
//    self.imageWidth.constant = SCREENWIDTH;
//    self.imageHeight.constant = image.size.height *SCREENWIDTH/600;
//    [self.imageView sd_setImageWithURL:[self.contentImageUrlArray objectAtIndex:1]];
    
   // NSLog(@"%@\n, %@", self.headImageUrlArray, self.contentImageUrlArray);
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
    
}

- (IBAction)btnClicked:(UIButton *)sender {
    PurchaseViewController *purchase = [[PurchaseViewController alloc] init];
    [self.navigationController pushViewController:purchase animated:YES];
    
    
}
@end
