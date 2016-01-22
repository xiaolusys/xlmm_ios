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


#define button_border_width 1
#define button_distance 8

@interface MamaActivityViewController ()<UIAlertViewDelegate>

@property (nonatomic, copy) NSArray *colorArray;
@property (nonatomic, copy) NSArray *sizeArray;


@end

@implementation MamaActivityViewController{
    NSString *colorparam;
    NSString *sizeparam;
    
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
    
    NSLog(@"%@\n%@", self.colorArray, self.sizeArray);
    
    
    
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
    NSLog(@"index = %@", self.colorArray[index]);
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
    NSLog(@"index = %@", self.sizeArray[index]);
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"确定");
        ActivityErweimaViewController *erweimaVC = [[ActivityErweimaViewController alloc] init];
        
        [self.navigationController pushViewController:erweimaVC animated:YES];
        
    }
}
@end
