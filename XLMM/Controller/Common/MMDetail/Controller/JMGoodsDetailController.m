//
//  JMGoodsDetailController.m
//  XLMM
//
//  Created by 崔人帅 on 16/8/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsDetailController.h"
#import "MMClass.h"
#import "JMGoodsExplainCell.h"
#import "JMGoodsParameterCell.h"



#define SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size

#define HEADER_VIEW_HEIGHT      300.0      // 顶部商品图片高度
#define END_DRAG_SHOW_HEIGHT    60.0       // 结束拖拽最大值时的显示
#define BOTTOM_VIEW_HEIGHT      60.0       // 底部视图高度（加入购物车＼立即购买）


@interface JMGoodsDetailController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

/**
 *  创建推荐视图 --> 在下拉的时候 顶部弹出的一个视图
 */
@property (nonatomic, strong) UIView *recommendView;
/**
 *  蒙版视图
 */
@property (nonatomic, strong) UIView *maskView;


@property (nonatomic, strong) UITableView *tableView;        // 原生界面

@property (nonatomic, strong) UIWebView *detailWebView;      // 加载网页视图

@property (nonatomic, strong) UILabel *topMessagelabel;      // 顶部(下拉)提示信息
@property (nonatomic, strong) UILabel *bottomMessageLabel;   // 底部(上拉)提示信息

@property (nonatomic, strong) UIView *headerView;            // 头视图 --> 显示商品图片的视图
@property (nonatomic, strong) UIScrollView *goodsScrollView; // 商品滚动视图




@end

@implementation JMGoodsDetailController {
    CGFloat minY;
    CGFloat maxY;
    
    BOOL isTop;         // 顶部视图布尔值，在Close方法中用到，判断动画不一样
    BOOL isShowTop;     // 顶部视图弹出开关，只有当isShowTop为假时，才会显示，否则不显示
    BOOL isShowDetail;  // 图文详情开关，
}

- (UIView *)recommendView {
    if (!_recommendView) {
        _recommendView = [[UIView alloc] initWithFrame:CGRectMake(0, -SCREENHEIGHT / 2.0f, SCREENWIDTH, SCREENHEIGHT / 2.0f)];
        _recommendView.backgroundColor = [UIColor orangeColor];
    }
    return _recommendView;
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0f;
        // 添加点击背景按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:SCREEN_BOUNDS];
//        [btn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"商品详情" selecotr:@selector(backClick:)];
    self.navigationController.navigationBar.alpha = 0.0f;
    
    
    [self createTableView];
    

    
}
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 60) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *dowmView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60)];
    dowmView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:dowmView];
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT + 64 + 60, SCREENWIDTH, SCREENHEIGHT - 60)];
    [self.view addSubview:self.detailWebView];
    self.detailWebView.scrollView.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    });
    self.detailWebView.scrollView.delegate = self;
    
    [self.tableView registerClass:[JMGoodsExplainCell class] forCellReuseIdentifier:JMGoodsExplainCellIdentifier];
    [self.tableView registerClass:[JMGoodsParameterCell class] forCellReuseIdentifier:JMGoodsParameterCellIdentifier];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, END_DRAG_SHOW_HEIGHT)];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , SCREENWIDTH, END_DRAG_SHOW_HEIGHT)];
    [footView addSubview:descLabel];
    self.tableView.tableFooterView = footView;
    descLabel.text = @"继续拖动,查看图文详情";
    descLabel.textAlignment = NSTextAlignmentCenter;
    footView.backgroundColor = [UIColor greenColor];
    
    [self createHeaderView];
    
    self.bottomMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, SCREENWIDTH, 60)];
    self.bottomMessageLabel.font = [UIFont systemFontOfSize:13.0f];
    self.bottomMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomMessageLabel.text = @"下拉返回商品详情";
    self.bottomMessageLabel.backgroundColor = [UIColor yellowColor];
    [self.detailWebView.scrollView addSubview:self.bottomMessageLabel];
    
    
}

- (void)createHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HEADER_VIEW_HEIGHT)];
//    [self.tableView addSubview:self.headerView];
    self.tableView.tableHeaderView = self.headerView;
    self.goodsScrollView = [[UIScrollView alloc] initWithFrame:self.headerView.bounds];
    // 添加多张图片
    for (int i=0; i<5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREENWIDTH, 0, SCREENWIDTH, HEADER_VIEW_HEIGHT)];
        imageView.backgroundColor = [UIColor whiteColor];
        if (i == 1 || i == 3) {
            imageView.backgroundColor = [UIColor yellowColor];
        }
        [self.goodsScrollView addSubview:imageView];
    }
    self.goodsScrollView.pagingEnabled = YES;
    self.goodsScrollView.showsHorizontalScrollIndicator = NO;
    self.goodsScrollView.contentSize = CGSizeMake(SCREENWIDTH * 5, HEADER_VIEW_HEIGHT);
    self.goodsScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.headerView addSubview:self.goodsScrollView];
}

// 返回按钮
- (void)backClick:(id)sender {
    if (isShowDetail) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            isShowDetail = NO;
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMGoodsExplainCell *explainCell = [tableView dequeueReusableCellWithIdentifier:JMGoodsExplainCellIdentifier];
        explainCell.backgroundColor = [UIColor orangeColor];
        return explainCell;
    }else if (indexPath.section == 1) {
        JMGoodsParameterCell *paramCell = [tableView dequeueReusableCellWithIdentifier:JMGoodsParameterCellIdentifier];
        paramCell.backgroundColor = [UIColor redColor];
        return paramCell;
    }else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 360.0f;
            break;
        case 1:
            return 300.0f;
            break;
        default:
            return 0.0f;
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.tableView) {
        self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, 0);
        if (self.tableView.contentOffset.y >= 0 && self.tableView.contentOffset.y <= HEADER_VIEW_HEIGHT) {
            self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, -offset / 2.);
            self.navigationController.navigationBar.alpha = offset / HEADER_VIEW_HEIGHT;
        }else if (self.tableView.contentOffset.y < 0) {
        
        }else {
            self.navigationController.navigationBar.alpha = 1.0;
        }
        
        
    }else {
        // --> 这里处理的是webView中的scrollView
        if (offset <= -END_DRAG_SHOW_HEIGHT) {
            self.bottomMessageLabel.text = @"释放返回商品详情";
        }else {
            self.bottomMessageLabel.text = @"下拉返回商品详情";
        }
        
    }
    
}

/**
 *  每次拖拽都会调用
 *  @param decelerate YES --> 减速动画  NO --> 没用动画
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
        if (scrollView == self.tableView) {
            if (offset < 0) {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        }else {
            minY = MIN(minY, offset);
        }
        
        // 滚到图文详情
        if (maxY >= self.tableView.contentSize.height - SCREENHEIGHT + END_DRAG_SHOW_HEIGHT + BOTTOM_VIEW_HEIGHT) {
            isShowDetail = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, - (SCREENHEIGHT + BOTTOM_VIEW_HEIGHT));
            } completion:^(BOOL finished) {
                maxY = 0.0f;
                isShowDetail = YES;
            }];
        }
        
        // 滚到商品详情
        if (minY <= -END_DRAG_SHOW_HEIGHT && isShowDetail) {
            [UIView animateWithDuration:0.4 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                minY = 0.0f;
                isShowDetail = NO;
                self.bottomMessageLabel.text = @"下拉返回商品详情";
            }];
        }
        
        
        
    }
}

/**
 *  带有滑动减速动画效果时，才会调用
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"END Decelerating");
}

@end


























































































