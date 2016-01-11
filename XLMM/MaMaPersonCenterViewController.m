//
//  MaMaPersonCenterViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/11.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaPersonCenterViewController.h"
#import "FSLineChart.h"
#import "MMClass.h"
#import "UIColor+FSPalette.h"




@interface MaMaPersonCenterViewController (){
    NSMutableArray *dataArray;
    CGFloat widthOfChart;
}

@property (nonatomic, strong)FSLineChart *lineChart;

@end

@implementation MaMaPersonCenterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc] initWithCapacity:30];
    widthOfChart = (SCREENWIDTH)/6;
    self.headViewWidth.constant = SCREENWIDTH;
    [self prepareData];
    [self createChart:dataArray];
    
    
    
}

- (void)createChart:(NSMutableArray *)chartData {
    self.mamaScrollView.contentSize = CGSizeMake(SCREENWIDTH * 15, 100);
    self.mamaScrollView.contentOffset = CGPointMake(0, 0);
    self.mamaScrollView.bounces = NO;
    self.mamaScrollView.showsHorizontalScrollIndicator = NO;
    self.mamaScrollView.contentOffset = CGPointMake(SCREENWIDTH * 14, 0);
    //self.mamaScrollView.pagingEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [self.mamaScrollView addGestureRecognizer:tap];
    
    [self.mamaScrollView addSubview:[self chart2:chartData]];
    [self.view addSubview:self.mamaScrollView];
}

- (void)tapClicked:(UITapGestureRecognizer *)recognizer{
 //   UIScrollView *scrollView = (UIScrollView*)recognizer.view;
   // NSLog(@"scrollView = %@", scrollView);

    CGPoint location = [recognizer locationInView:recognizer.view];
    //NSLog(@"location = %@", NSStringFromCGPoint(location));
    CGFloat width = location.x;
    NSInteger index = (int)(width + SCREENWIDTH/12) / SCREENWIDTH * 6;
    NSLog(@"index = %ld", index);
    NSInteger days = 90 - index;
    NSLog(@"%ld天前的数据",days);
}

-(FSLineChart*)chart2:(NSMutableArray *)chartData {
    // Creating the line chart
    self.lineChart = [[FSLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 15, 100)];
    self.lineChart.verticalGridStep = 1;
    self.lineChart.horizontalGridStep = 90;
    self.lineChart.color = [UIColor fsOrange];
    self.lineChart.fillColor = nil;
    
    //    lineChart.labelForIndex = ^(NSUInteger item) {
    //         return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%lu%%",(unsigned long)item];
    //    };
    //
    //    lineChart.labelForValue = ^(CGFloat value) {
    //        return [NSString stringWithFormat:@""];
    ////        return [NSString stringWithFormat:@"%.f €", value];
    //    };
    
    self.lineChart.bezierSmoothing = NO;
    self.lineChart.animationDuration = 1.0;
    
    [self.lineChart setChartData:chartData];
    return self.lineChart;
}


- (void)prepareData{
    for (int i = 0; i < 91; i++) {
        int k = arc4random()%10+2;
        NSNumber *number = [NSNumber numberWithInt:k];
        [dataArray addObject:number];
    }
    NSLog(@"dataArray = %@", dataArray);
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

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendProduct:(id)sender {
    NSLog(@"发布产品");
}


@end
