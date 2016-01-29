//
//  MamaActivityViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/22.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MamaActivityViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "ActivityErweimaViewController.h"
#import "ChiMaBiaoViewController.h"
#import "HuojiangListViewController.h"


#define button_border_width 1
#define button_distance 8

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 568
#define IMAGEVIEW_COUNT 3

@interface MamaActivityViewController ()<UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *colorArray;
@property (nonatomic, copy) NSArray *sizeArray;


@end

@implementation MamaActivityViewController{
    NSString *colorparam;
    NSString *sizeparam;
    
    
    UIScrollView *_imageScrollView;
    UIImageView *_leftImageView;
    UIImageView *_centerImageView;
    UIImageView *_rightImageView;
    UILabel *_label;
    NSMutableDictionary *_imageData;//图片数据
    int _currentImageIndex;//当前图片索引
    int _imageCount;//图片总数
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self prepareData];
    }
    return self;
}

- (void)prepareData{
    
    NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:4];
    [colors addObject:@"红色"];
    [colors addObject:@"黄色"];
    [colors addObject:@"蓝色"];
    [colors addObject:@"绿色"];
    [colors addObject:@"黑色"];
    [colors addObject:@"白色"];
    [colors addObject:@"紫色"];
    
    self.colorArray = colors;
    
    NSMutableArray *size = [[NSMutableArray alloc] initWithCapacity:4];
    [size addObject:@"S"];
    [size addObject:@"M"];
    [size addObject:@"L"];
    [size addObject:@"XL"];
    [size addObject:@"XXL"];
    [size addObject:@"XXXL"];
    [size addObject:@"XXXXL"];
    
    self.sizeArray = size;
    
   // NSLog(@"%@\n%@", self.colorArray, self.sizeArray);
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"活动界面";
    [self createNavigationBarWithTitle:@"活动界面" selecotr:@selector(backClicked:)];
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self createColorView];
    [self createSizeView];
    
    self.imageViewWidth.constant = SCREENWIDTH;
    self.imageViewHeight.constant = SCREENWIDTH;
    
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self disableTijiaoButton];
    
    [self loadImageData];
    //添加滚动控件
    [self addScrollView];
    //添加图片控件
    [self addImageViews];
    //添加分页控件
    [self addPageControl];
    //添加图片信息描述控件
    //加载默认图片
    [self setDefaultImage];
    
    [self downloadData];
    
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/free_proinfo", Root_URL];
    
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
}

- (void)fetchedData:(NSData *)data{
    
    if(data == nil) return;
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error == nil) {
        NSLog(@"data = %@", dicJson);
    }
}

#pragma mark 加载图片数据
-(void)loadImageData{
    //读取程序包路径中的资源文件
    _imageCount= (int)self.colorArray.count;
}

#pragma mark 添加控件
-(void)addScrollView{
    _imageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
    [self.imageView addSubview:_imageScrollView];
    //设置代理
    _imageScrollView.delegate=self;
    _imageScrollView.tag = 8888;
    //设置contentSize
    _imageScrollView.contentSize=CGSizeMake(SCREENWIDTH*IMAGEVIEW_COUNT, SCREENWIDTH) ;
    //设置当前显示的位置为中间图片
    [_imageScrollView setContentOffset:CGPointMake(SCREENWIDTH, 0) animated:NO];
    //设置分页
    _imageScrollView.pagingEnabled=YES;
    //去掉滚动条
    _imageScrollView.showsHorizontalScrollIndicator=NO;
}

#pragma mark 添加图片三个控件
-(void)addImageViews{
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH)];
    _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_imageScrollView addSubview:_leftImageView];
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH)];
    _centerImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_imageScrollView addSubview:_centerImageView];
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*SCREENWIDTH, 0, SCREENWIDTH, SCREENWIDTH)];
    _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_imageScrollView addSubview:_rightImageView];
    
}
#pragma mark 设置默认显示图片
-(void)setDefaultImage{
    //加载默认图片
    _leftImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
    _centerImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
    _rightImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
    _currentImageIndex=0;
    //设置当前页
}

#pragma mark 添加分页控件
-(void)addPageControl{
       //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor orangeThemeColor];
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    
    _pageControl.currentPage=_currentImageIndex;
}



#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 8888) {
        
        
        //重新加载图片
        [self reloadImage];
        //移动到中间
        [_imageScrollView setContentOffset:CGPointMake(SCREENWIDTH, 0) animated:NO];
        //设置分页
        _pageControl.currentPage=_currentImageIndex;
        //设置描述
    }
   
}

#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_imageScrollView contentOffset];
    if (offset.x>SCREENWIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }else if(offset.x<SCREENWIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    //UIImageView *centerImageView=(UIImageView *)[_scrollView viewWithTag:2];
    _centerImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    rightImageIndex=(_currentImageIndex+1)%_imageCount;
    _leftImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
    _rightImageView.image=[UIImage imageNamed:@"Unknown.jpeg"];
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}



- (UIButton *)buttonWithFrame:(CGRect)rect title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    [button setTitle:title forState:UIControlStateNormal];
    //do other things .
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 4;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    
    return button;
    
}

- (void)createColorView{
    CGFloat width = (SCREENWIDTH - 4 *button_distance)/3;

     CGFloat height = 40;
    for (int i = 0; i < self.colorArray.count; i++) {
        
        
        
        CGRect rect = CGRectMake(button_distance + i%3 * (button_distance + width), button_distance + i/3 * (button_distance + height), width, height);
        UIButton *button = [self buttonWithFrame:rect title:self.colorArray[i]];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(colorSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.colorView addSubview:button];
    }
    self.colorViewHeight.constant = (self.colorArray.count + 2)/3 * (height + button_distance) + button_distance;
    self.colorView.backgroundColor = [UIColor whiteColor];
}

- (void)colorSelected:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - 1000;
  //  NSLog(@"index = %@", self.colorArray[index]);
    colorparam = self.colorArray[index];
    if (colorparam && sizeparam) {
        [self enableTijiaoButton];
    }
    
    for (int i = 1000; i < 1000 + self.colorArray.count; i++) {
        UIButton *btn = (UIButton *)[self.colorView viewWithTag:i];
        if (btn.tag == button.tag) {
            [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor orangeThemeColor].CGColor;
        } else {
            [btn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
        }
    }
    
}

- (void)sizeSelected:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - 2000;
  //  NSLog(@"index = %@", self.sizeArray[index]);
    sizeparam = self.sizeArray[index];
    if (colorparam && sizeparam) {
        [self enableTijiaoButton];
    }
    
    for (int i = 2000; i < 2000 + self.sizeArray.count; i++) {
        UIButton *btn = (UIButton *)[self.sizeView viewWithTag:i];
        if (btn.tag == button.tag) {
            [btn setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor orangeThemeColor].CGColor;
        } else {
            [btn setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
        }
    }
    
}

- (void)createSizeView{
    CGFloat width = (SCREENWIDTH - 4 *button_distance)/3;
    
    CGFloat height = 40;
    for (int i = 0; i < self.sizeArray.count; i++) {
        CGRect rect = CGRectMake(button_distance + i%3 * (button_distance + width), button_distance + i/3 * (button_distance + height), width, height);
        UIButton *button = [self buttonWithFrame:rect title:self.sizeArray[i]];
        button.tag = i + 2000;
        [button addTarget:self action:@selector(sizeSelected:) forControlEvents:UIControlEventTouchUpInside
         ];
        [self.sizeView addSubview:button];
    }
    self.sizeViewHeight.constant = (self.sizeArray.count + 2)/3 * (height + button_distance) + button_distance;
    self.sizeView.backgroundColor = [UIColor whiteColor];
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

- (IBAction)commitClicked:(id)sender {
    NSLog(@"颜色：%@， 尺码：%@",colorparam, sizeparam);
    NSString *message = [NSString stringWithFormat:@"确定要选择颜色为%@，尺码为%@的商品吗", colorparam, sizeparam];
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
}

- (IBAction)chimabiao:(id)sender {
    
    ChiMaBiaoViewController *chimaVC = [[ChiMaBiaoViewController alloc] init];
    [self.navigationController pushViewController:chimaVC animated:YES];
    
}

- (IBAction)huojianglistClicked:(id)sender {
    HuojiangListViewController *listVC = [[HuojiangListViewController alloc] init];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
       // NSLog(@"确定");
        ActivityErweimaViewController *erweimaVC = [[ActivityErweimaViewController alloc] init];
        
        [self.navigationController pushViewController:erweimaVC animated:YES];
        
    }
}
@end
