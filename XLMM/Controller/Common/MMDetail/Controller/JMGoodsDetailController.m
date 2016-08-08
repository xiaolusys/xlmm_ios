//
//  JMGoodsDetailController.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsDetailController.h"
#import "MMClass.h"
#import "JMGoodsAttributeCell.h"
#import "JMGoodsExplainCell.h"
#import "JMAutoLoopScrollView.h"
#import "JMGoodsLoopRollView.h"

#define BottomHeitht 60.0

@interface JMGoodsDetailController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,JMAutoLoopScrollViewDatasource,JMAutoLoopScrollViewDelegate> {
    CGFloat maxY;
    CGFloat minY;
    
    BOOL isShowGoodsDetail;
    
    
}

@property (nonatomic, strong) UIView *allContentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIWebView *detailWebView;

@property (nonatomic, strong) UILabel *upViewLabel;
@property (nonatomic, strong) UILabel *downViewLabel;

@property (nonatomic, strong) UIScrollView *goodsScrollView;
/**
 *  自定义导航栏视图
 */
@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, strong) UIView *backToRootView;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSMutableArray *topImageArray;

@end

@implementation JMGoodsDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (NSMutableArray *)topImageArray {
    if (_topImageArray == nil) {
        _topImageArray = [NSMutableArray arrayWithObjects:@"http://image.xiaolu.so/MG_1467381630863heide-.jpg",@"http://image.xiaolu.so/MG_1467383383441heide-.jpg",@"http://image.xiaolu.so/MG_14674319192811.jpg",@"http://image.xiaolu.so/MG_14670824874061.jpg",@"http://image.xiaolu.so/MG_14670829662741.jpg",@"http://image.xiaolu.so/MG_14670834927463.jpg", nil];
    }
    return _topImageArray;
}
//- (UIView *)allContentView {
//    if (_allContentView == nil) {
//
//    }
//    return _allContentView;
//}
//- (UITableView *)tableView {
//    if (_tableView == nil) {
//
//    }
//    return _tableView;
//}
//- (UIWebView *)detailWebView {
//    if (_upViewLabel == nil) {
//        _detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT + 64, SCREENWIDTH, SCREENHEIGHT - 108)];
//        _detailWebView.backgroundColor = [UIColor orangeColor];
//        _detailWebView.scrollView.delegate = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
//        });
//    }
//    return _detailWebView;
//    
//}
- (UILabel *)upViewLabel {
    if (_upViewLabel == nil) {
        _upViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        _upViewLabel.font = [UIFont systemFontOfSize:13.0f];
        _upViewLabel.textAlignment = NSTextAlignmentCenter;
        _upViewLabel.backgroundColor = [UIColor purpleColor];
        _upViewLabel.text = @"继续拖动,查看图文详情";
        _upViewLabel.textColor = [UIColor buttonTitleColor];
    }
    return _upViewLabel;
}
- (UILabel *)downViewLabel {
    if (_downViewLabel == nil) {
        _downViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, SCREENWIDTH, 60)];
        _downViewLabel.font = [UIFont systemFontOfSize:13.0f];
        _downViewLabel.textAlignment = NSTextAlignmentCenter;
        _downViewLabel.backgroundColor = [UIColor countLabelColor];
        _downViewLabel.text = @"下拉回到商品详情";
        _downViewLabel.textColor = [UIColor buttonTitleColor];
        [self.detailWebView.scrollView addSubview:_downViewLabel];
    }
    return _downViewLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor countLabelColor];
//    self.navigationController.navigationBar.alpha = 0.0;
    self.allContentView = [UIView new];
    self.allContentView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 2 - BottomHeitht * 2);
    self.allContentView.backgroundColor = [UIColor countLabelColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREENWIDTH, SCREENHEIGHT - 40) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    //        _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    //        _tableView.contentSize = CGSizeMake(SCREENWIDTH, 940);
    //        _tableView.delegate = self;
    self.tableView.tableFooterView = self.upViewLabel;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT + 64, SCREENWIDTH, SCREENHEIGHT - 64 - BottomHeitht)];
    self.detailWebView.backgroundColor = [UIColor countLabelColor];
    self.detailWebView.scrollView.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    });
    
    [self.view addSubview:self.allContentView];
    [self.allContentView addSubview:self.tableView];
    [self.allContentView addSubview:self.detailWebView];
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, SCREENHEIGHT - BottomHeitht, SCREENWIDTH, BottomHeitht);
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *shopCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:shopCartButton];
    shopCartButton.layer.cornerRadius = 20.;
    shopCartButton.backgroundColor = [UIColor blackColor];
    shopCartButton.alpha = 0.6;
    
    UIImageView *shopCartImage = [UIImageView new];
    [shopCartButton addSubview:shopCartImage];
    shopCartImage.image = [UIImage imageNamed:@"gouwucheicon2"];
    
    
    UIButton *addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:addCartButton];
    addCartButton.layer.cornerRadius = 20.;
    addCartButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addCartButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    
    
    [shopCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(15);
        make.width.height.mas_equalTo(@40);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    [shopCartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopCartButton.mas_centerX);
        make.centerY.equalTo(shopCartButton.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    [addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopCartButton.mas_right).offset(15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(SCREENWIDTH - 85));
    }];
    
    
    
    
    [self.tableView registerClass:[JMGoodsAttributeCell class] forCellReuseIdentifier:JMGoodsAttributeCellIdentifier];
    [self.tableView registerClass:[JMGoodsExplainCell class] forCellReuseIdentifier:JMGoodsExplainCellIdentifier];
    
    [self setupHeadView];
    
    self.navigationView = [UIView new];
    self.navigationView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    [self.view addSubview:self.navigationView];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.alpha = 0;
    
    
    kWeakSelf
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:button];
    button.frame = CGRectMake(10, 17, 100, 30);
    [button setImage:[UIImage imageNamed:@"icon-fanhui2"] forState:UIControlStateNormal];
    button.tag = 100;
    [button addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = button;
    
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.navigationView).offset(10);
        make.centerY.equalTo(weakSelf.navigationView.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    backView.layer.cornerRadius = 15.;
    self.backToRootView = backView;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.navigationView).offset(10);
        make.centerY.equalTo(weakSelf.navigationView.mas_centerY);
        make.width.height.mas_equalTo(@30);
    }];
    
    
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"goodsDetailBackImage"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = 15.;
    backButton.tag = 101;
    [backButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.height.mas_equalTo(@30);
    }];
    
    
    
    
    
    
    
    
    
    
    
}
- (void)setupHeadView {
    
    JMAutoLoopScrollView *scrollView = [[JMAutoLoopScrollView alloc] initWithStyle:JMAutoLoopScrollStyleHorizontal];
    self.goodsScrollView = scrollView;
    scrollView.jm_scrollDataSource = self;
    scrollView.jm_scrollDelegate = self;
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, 300);
    
    scrollView.jm_isStopScrollForSingleCount = YES;
    scrollView.jm_autoScrollInterval = 3.;
    [scrollView jm_registerClass:[JMGoodsLoopRollView class]];
    
    
    
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 300)];
//    // 添加多张图片
//    for (int i=0; i<5; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, 300)];
//        imageView.image = [UIImage imageNamed:@(i+1).stringValue];
//        if (i == 1 || i == 3) {
//            imageView.backgroundColor = [UIColor purpleColor];
//        }else {
//            imageView.backgroundColor = [UIColor blueColor];
//        }
//        [scrollView addSubview:imageView];
//    }
//    scrollView.pagingEnabled = YES;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(SCREENWIDTH * 5, 300);
//    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    
//    self.goodsScrollView = scrollView;
    
    self.tableView.tableHeaderView = scrollView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 340.0f;
            break;
        case 1:
            return 300.0f;
            break;
        default:
            return 0.0f;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMGoodsAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:JMGoodsAttributeCellIdentifier];
        cell.backgroundColor = [UIColor orangeColor];
        return cell;
    }else {
        JMGoodsExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:JMGoodsExplainCellIdentifier];
        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }
    return nil;
}
- (void)navigationBarButton:(UIButton *)button {
    if (button.tag == 100 || button.tag == 101) {
        if (isShowGoodsDetail) {
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                isShowGoodsDetail = NO;
            }];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.tableView) {
        self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, 0);
        if (self.tableView.contentOffset.y >= 0 &&  self.tableView.contentOffset.y <= 300) {
            self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, -offset / 2.0f);
//            self.navigationController.navigationBar.hidden = NO;
            self.navigationView.alpha = offset / 300;
            self.backToRootView.alpha = 0.8 - offset / 300;
            
        }else {
//            self.navigationView.alpha = 1.0;
        }
        
        
        
        
        if (offset <= self.tableView.contentSize.height - SCREENHEIGHT + 60 + BottomHeitht) {
            self.upViewLabel.text = @"继续拖动,查看图文详情";
        }else {
            //            self.middleLab.text = @"上拉显示底部View";
        }
    }else {
        // WebView中的ScrollView
        if (offset <= -60) {
            self.downViewLabel.text = @"释放返回商品详情";
        }else {
            self.downViewLabel.text = @"下拉返回商品详情";
        }
    }
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
        NSLog(@"----offset=%f",offset);
        if (scrollView == self.tableView)
        {
            if (offset < 0)
            {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        }
        else
        {
            minY = MIN(minY, offset);
        }
        // 滚到底部视图
        NSLog(@"----maxY=%f",maxY);
        NSLog(@"----contentSize=%f",self.tableView.contentSize.height);
        if (maxY >= self.tableView.contentSize.height - SCREENHEIGHT + 60 + BottomHeitht)
        {
            NSLog(@"----%@",NSStringFromCGRect(self.allContentView.frame));
            isShowGoodsDetail = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformTranslate(self.allContentView.transform, 0,-SCREENHEIGHT);
            } completion:^(BOOL finished) {
                maxY = 0.0f;
                isShowGoodsDetail = YES;
            }];
        }
        
        // 滚到中间视图
        if (minY <= -60 && isShowGoodsDetail)
        {
            NSLog(@"----minY=%f",minY);
            NSLog(@"----%@",NSStringFromCGRect(self.allContentView.frame));
            isShowGoodsDetail = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                minY = 0.0f;
            }];
        }
    }
}

#pragma mark - LPAutoScrollViewDatasource

- (NSUInteger)jm_numberOfNewViewInScrollView:(JMAutoLoopScrollView *)scrollView {
    return self.topImageArray.count;
}
/**
 *  类似UITableVIew
 */
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView newViewIndex:(NSUInteger)index forRollView:(JMGoodsLoopRollView *)rollView {
    rollView.imageString = self.topImageArray[index];
}
#pragma mark LPAutoScrollViewDelegate
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didSelectedIndex:(NSUInteger)index {
    NSLog(@"%@", self.topImageArray[index]);
    
    
}



@end






































































































