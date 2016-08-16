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
#import "JMGoodsInfoPopView.h"
#import "JMGoodsSafeGuardCell.h"
#import "SVProgressHUD.h"
#import "IMYWebView.h"
#import "JMShareViewController.h"
#import "JMPopView.h"
#import "JMShareView.h"
#import "JMShareModel.h"
#import "CartViewController.h"
#import "JMDescLabelModel.h"
#import "JMLogInViewController.h"

#define BottomHeitht 60.0
#define RollHeight 20.0
#define HeaderScrolHeight SCREENHEIGHT * 0.65

#define POPHeight SCREENHEIGHT * 0.6

#define NavigationMaskWH 36

@interface JMGoodsDetailController ()<JMShareViewDelegate,JMGoodsInfoPopViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,JMAutoLoopScrollViewDatasource,JMAutoLoopScrollViewDelegate,WKScriptMessageHandler,IMYWebViewDelegate> {
    CGFloat maxY;
    CGFloat minY;
    
    BOOL isShowGoodsDetail;
    
    BOOL isTop;                 // 顶部视图 -- > 判断动画不同
    BOOL isShowTop;             // 顶部视图弹出开团  --> 当isShowTop为假时才显示
    
    NSMutableArray *_sizeArray;
    NSMutableArray *_colorArray;
    NSMutableDictionary *_stockDict;
    NSMutableArray *_imageArray;
    
    NSDictionary *detailContentDic;
    NSDictionary *coustomInfoDic;
    
    NSDictionary *_paramer;
    
}
@property (nonatomic, strong) JMShareViewController *goodsShareView;

@property (nonatomic, strong) UIView *allContentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IMYWebView *detailWebView;

@property (nonatomic, strong) UILabel *upViewLabel;
@property (nonatomic, strong) UILabel *downViewLabel;

@property (nonatomic, strong) JMAutoLoopScrollView *goodsScrollView;
/**
 *  自定义导航栏视图
 */
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIView *backToRootView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *cartsLabel;
/**
 *  数据源 --> 数组
 */
@property (nonatomic, strong) NSMutableArray *topImageArray;

/**
 *  蒙版视图
 */
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) JMGoodsInfoPopView *popView;

@property (nonatomic, strong) NSMutableArray *attributeArray;

@property (nonatomic, strong) JMShareModel *shareModel;
@property (nonatomic, strong) UIButton *addCartButton;
@end

@implementation JMGoodsDetailController {
    NSMutableArray *goodsArray;
    
    NSInteger _cartsGoodsNum;
    BOOL _isAddcart;           // 判断商品是否即将开售
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MobClick beginLogPageView:@"JMGoodsDetailController"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"JMGoodsDetailController"];
}
- (JMShareModel *)shareModel {
    if (!_shareModel) {
        _shareModel = [[JMShareModel alloc] init];
    }
    return _shareModel;
}
- (NSMutableArray *)attributeArray {
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.400];
        _maskView.alpha = 0.0;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [btn addTarget:self action:@selector(hideMaskView) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}
- (UIView *)popView {
    if (!_popView) {
        _popView = [[JMGoodsInfoPopView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, POPHeight)];
//        _popView.backgroundColor = [UIColor orangeColor];
        _popView.delegate = self;
        _popView.backgroundColor = [UIColor whiteColor];
        
    }
    return _popView;
}
- (NSMutableArray *)topImageArray {
    if (_topImageArray == nil) {
        _topImageArray = [NSMutableArray array];
    }
    return _topImageArray;
}

- (UILabel *)upViewLabel {
    if (_upViewLabel == nil) {
        _upViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
        //继续拖动,查看图文详情
        _upViewLabel.font = [UIFont systemFontOfSize:14.0f];
        _upViewLabel.textAlignment = NSTextAlignmentCenter;
        _upViewLabel.backgroundColor = [UIColor countLabelColor];
        _upViewLabel.text = @"继续拖动,查看图文详情";
        _upViewLabel.textColor = [UIColor buttonTitleColor];
    }
    return _upViewLabel;
}
- (UILabel *)downViewLabel {
    if (_downViewLabel == nil) {
        _downViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, SCREENWIDTH, 60)];
        _downViewLabel.font = [UIFont systemFontOfSize:14.0f];
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
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    
    [self lodaDataSource];
    [self loadCatrsNumData];
    [self loadShareData];
    
    
    [self createContentView];
    [self setupHeadView];
    [self createBottomView];
    [self createNavigationView];

}
- (void)createContentView {
    self.allContentView = [UIView new];
    self.allContentView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT * 2 - BottomHeitht * 2);
    self.allContentView.backgroundColor = [UIColor countLabelColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREENWIDTH, SCREENHEIGHT - 40) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT * 2);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.upViewLabel;
    
    self.detailWebView = [[IMYWebView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT + 64, SCREENWIDTH, SCREENHEIGHT - 64 - BottomHeitht)];
    self.detailWebView.backgroundColor = [UIColor countLabelColor];
    //self.detailWebView.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *loadStr = [NSString stringWithFormat:@"%@/mall/product/details/app/%@",Root_URL,self.goodsID];
        NSURL *url = [NSURL URLWithString:loadStr];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.detailWebView loadRequest:request];
    });
    self.detailWebView.scrollView.delegate = self;
    
    [self.view addSubview:self.allContentView];
    [self.allContentView addSubview:self.tableView];
    [self.allContentView addSubview:self.detailWebView];
    
    [self.tableView registerClass:[JMGoodsAttributeCell class] forCellReuseIdentifier:JMGoodsAttributeCellIdentifier];
    [self.tableView registerClass:[JMGoodsExplainCell class] forCellReuseIdentifier:JMGoodsExplainCellIdentifier];
    [self.tableView registerClass:[JMGoodsSafeGuardCell class] forCellReuseIdentifier:JMGoodsSafeGuardCellIdentifier];
}
- (void)loadShareData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,self.goodsID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        self.shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        self.shareModel.share_type = @"link";
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
    } Progress:^(float progress) {
        
    }];
}
- (void)loadCatrsNumData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num.json",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        _cartsGoodsNum = [responseObject[@"result"] integerValue];
        if (_cartsGoodsNum == 0) {
            self.cartsLabel.hidden = YES;
        }else {
            self.cartsLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        }
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (void)lodaDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/%@",Root_URL,self.goodsID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        [self fetchData:responseObject];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
    } Progress:^(float progress) {
        
    }];
    
}
- (void)fetchData:(NSDictionary *)goodsDetailDic {
    detailContentDic = [NSDictionary dictionary];
    detailContentDic = goodsDetailDic[@"detail_content"];
    self.topImageArray = detailContentDic[@"head_imgs"];
    
    NSDictionary *comparison = goodsDetailDic[@"comparison"];
    NSArray *attributes = comparison[@"attributes"];
    for (NSDictionary *dic in attributes) {
        JMDescLabelModel *model = [JMDescLabelModel mj_objectWithKeyValues:dic];
        [self.attributeArray addObject:model];
    }
    
    coustomInfoDic = [NSDictionary dictionary];
    coustomInfoDic = goodsDetailDic[@"custom_info"];
    goodsArray = goodsDetailDic[@"sku_info"];

    if ([detailContentDic[@"is_saleopen"] boolValue]) {
        if ([detailContentDic[@"is_sale_out"] boolValue]) {
            // == > 抢光
            [self.addCartButton setTitle:@"已抢光" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }
        else {
        }
    }else {
        
        //NSLog(@"isnew %d", [model.isNewgood boolValue]);
        if([detailContentDic[@"is_newsales"] boolValue]){
            [self.addCartButton setTitle:@"即将开售" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }
    }
    
    [self.popView initTypeSizeView:goodsArray TitleString:detailContentDic[@"name"]];

    [self.goodsScrollView jm_reloadData];
    [self.tableView reloadData];
    
}
- (void)navigationBarButton:(UIButton *)button {
    if (button.tag == 100 || button.tag == 102) {
//        NSLog(@"navigationBarButton层  返回按钮 --------");
//        if (isShowGoodsDetail) {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.allContentView.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//                isShowGoodsDetail = NO;
//            }];
//        }else {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSLog(@"navigationBarButton层  分享按钮 --------");
        
        JMShareViewController *shareView = [[JMShareViewController alloc] init];
        self.goodsShareView = shareView;
        self.goodsShareView.model = self.shareModel;
        
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        //弹出视图
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
        menu.contentView = self.goodsShareView.view;
        
    }
}
#pragma mark --- 点击隐藏弹出视图
- (void)coverDidClickCover:(JMShareView *)cover {
    //隐藏pop菜单
    [JMPopView hide];
}
- (void)setupHeadView {
    JMAutoLoopScrollView *scrollView = [[JMAutoLoopScrollView alloc] initWithStyle:JMAutoLoopScrollStyleHorizontal];
    self.goodsScrollView = scrollView;
    scrollView.jm_scrollDataSource = self;
    scrollView.jm_scrollDelegate = self;
    
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, HeaderScrolHeight);
    
    scrollView.jm_isStopScrollForSingleCount = YES;
    scrollView.jm_autoScrollInterval = 3.;
    [scrollView jm_registerClass:[JMGoodsLoopRollView class]];
    self.tableView.tableHeaderView = scrollView;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else {
        return self.attributeArray.count;;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1) {
        return 110;
    }else if (indexPath.section == 2) {
        JMDescLabelModel *model = self.attributeArray[indexPath.row];
        return model.cellHeight;
    }else {
        return 0;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMGoodsExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:JMGoodsExplainCellIdentifier];
        cell.detailContentDic = detailContentDic;
        cell.customInfoDic = coustomInfoDic;
        cell.block = ^(BOOL isSelected) {
            if (isSelected) {
                // 收藏
                NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"model_id"] = self.goodsID;
                [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
                    if (!responseObject) return ;
                    NSLog(@"%@",responseObject);
                    NSInteger code = [responseObject[@"code"] integerValue];
                    if (code == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    }else {
                        [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
                    }
                } WithFail:^(NSError *error) {
                    
                } Progress:^(float progress) {
                    
                }];
            }else {
                // 取消收藏
                NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                param[@"model_id"] = self.goodsID;
                [JMHTTPManager requestWithType:RequestTypeDELETE WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
                    if (!responseObject) return ;
                    NSLog(@"%@",responseObject);
                    NSInteger code = [responseObject[@"code"] integerValue];
                    if (code == 0) {
                        [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                    }else {
                        [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
                    }
                } WithFail:^(NSError *error) {
                    
                } Progress:^(float progress) {
                    
                }];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1) {
        JMGoodsSafeGuardCell *cell = [tableView dequeueReusableCellWithIdentifier:JMGoodsSafeGuardCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        JMGoodsAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:JMGoodsAttributeCellIdentifier];
        JMDescLabelModel *model = self.attributeArray[indexPath.row];
        cell.descModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        return nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 40;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        UILabel *label = [UILabel new];
        [view addSubview:label];
        label.text = @"商品参数";
        label.font = [UIFont boldSystemFontOfSize:16.];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.centerY.equalTo(view.mas_centerY);
        }];
        return view;
    }else {
        return nil;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y ;
    if (offset < 0) {
        offset = 0;
    }
    if (scrollView == self.tableView) {
        self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, 0);
        if (self.tableView.contentOffset.y >= 0 &&  self.tableView.contentOffset.y <= HeaderScrolHeight) {
            self.goodsScrollView.contentOffset = CGPointMake(self.goodsScrollView.contentOffset.x, -offset / 2.0f);
            CGFloat scrolHeight = HeaderScrolHeight;
            self.navigationView.alpha = (offset / scrolHeight) * 1.25;
            self.backToRootView.alpha = 0.7 - (offset / scrolHeight) * 1.25;
            self.shareView.alpha = 0.7 - (offset / scrolHeight) * 1.25;
            
            NSLog(@"offset == %f",offset);
            NSLog(@"HeaderScrolHeight == %f",scrolHeight);
            NSLog(@"%.2f",offset / scrolHeight);
            
        }else {
//            self.navigationView.alpha = 1.0;
        }

        if (offset <= self.tableView.contentSize.height - SCREENHEIGHT + RollHeight + BottomHeitht) {
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
        if (scrollView == self.tableView) {
            if (offset < 0) {
                minY = MIN(minY, offset);
            } else {
                maxY = MAX(maxY, offset);
            }
        }
        else {
            minY = MIN(minY, offset);
        }
        // 滚到底部视图
        if (maxY >= self.tableView.contentSize.height - SCREENHEIGHT + RollHeight + BottomHeitht) {
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
        if (minY <= -60 && isShowGoodsDetail) {
            isShowGoodsDetail = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.allContentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                minY = 0.0f;
            }];
        }
    }
}
- (void)cartButton:(UIButton *)button {
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defalts boolForKey:kIsLogin];
    if (button.tag == 100) {
        if (isLogin) {
            CartViewController *cartVC = [[CartViewController alloc] init];
            [self.navigationController pushViewController:cartVC animated:YES];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (button.tag == 101) {
        if (isLogin) {
            [self showPopView];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else {
    }
}
- (void)showPopView {
    isTop = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];

    [UIView animateWithDuration:0.2 animations:^{
        self.view.layer.transform = [self firstStepTransform];
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [self secondStepTransform];
            self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -POPHeight);
        }];
    }];
}
- (void)hideMaskView {
    if (isTop) {
        isShowTop = NO;
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [self firstStepTransform];
            self.popView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.layer.transform = CATransform3DIdentity;
                self.maskView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.maskView removeFromSuperview];
                [self.popView removeFromSuperview];
            }];
        }];
    }
}
// 动画1
- (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}
// 动画2
- (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, SCREENHEIGHT * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}
#pragma mark -- 加入购物车
- (void)composeGoodsInfoView:(JMGoodsInfoPopView *)popView AttrubuteDic:(NSDictionary *)attrubuteDic {
    _paramer = [NSDictionary dictionary];
    _paramer = attrubuteDic;
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:attrubuteDic WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
            _cartsGoodsNum += [attrubuteDic[@"num"] integerValue];
            self.cartsLabel.hidden = NO;
            NSLog(@"%ld",_cartsGoodsNum);
            self.cartsLabel.text = [NSString stringWithFormat:@"%ld",_cartsGoodsNum];
        }else {
            self.cartsLabel.hidden = YES;
            [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
        }
        [self hideMaskView];
    } WithFail:^(NSError *error) {
        NSLog(@"%@",error);
        self.cartsLabel.hidden = YES;
    } Progress:^(float progress) {
        
    }];
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
#pragma mark 自定义导航视图
- (void)createNavigationView {
    kWeakSelf
    
    self.navigationView = [UIView new];
    self.navigationView.frame = CGRectMake(0, 0, SCREENWIDTH, 64);
    [self.view addSubview:self.navigationView];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationView.alpha = 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:button];
    //    button.frame = CGRectMake(10, 17, 100, NavigationMaskWH);
    [button setImage:[UIImage imageNamed:@"goodsDetailBackColorImage"] forState:UIControlStateNormal];
    button.tag = 100;
    [button addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton = button;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.navigationView).offset(10);
        make.centerY.equalTo(weakSelf.navigationView.mas_centerY).offset(8);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
    UIButton *shareButtoncolor = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navigationView addSubview:shareButtoncolor];
    [shareButtoncolor setImage:[UIImage imageNamed:@"goodsDetailShareColorImage"] forState:UIControlStateNormal];
    shareButtoncolor.layer.cornerRadius = NavigationMaskWH / 2;
    shareButtoncolor.tag = 101;
    [shareButtoncolor addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [shareButtoncolor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.navigationView).offset(-10);
        make.centerY.equalTo(button.mas_centerY);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
    
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    backView.layer.cornerRadius = NavigationMaskWH / 2;
    self.backToRootView = backView;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(10);
        make.centerY.equalTo(weakSelf.navigationView.mas_centerY).offset(8);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
    
    UIView *backView1 = [UIView new];
    [self.view addSubview:backView1];
    backView1.backgroundColor = [UIColor blackColor];
    backView1.alpha = 0.7;
    backView1.layer.cornerRadius = NavigationMaskWH / 2;
    self.shareView = backView1;
    [backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-10);
        make.centerY.equalTo(backView.mas_centerY);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"goodsDetailBackImage"] forState:UIControlStateNormal];
    backButton.layer.cornerRadius = NavigationMaskWH / 2;
    backButton.tag = 102;
    [backButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView.mas_centerY);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView1 addSubview:shareButton];
    [shareButton setImage:[UIImage imageNamed:@"goodsDetailShareImage"] forState:UIControlStateNormal];
    shareButton.layer.cornerRadius = NavigationMaskWH / 2;
    shareButton.tag = 103;
    [shareButton addTarget:self action:@selector(navigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backView1.mas_centerY);
        make.centerX.equalTo(backView1.mas_centerX);
        make.width.height.mas_equalTo(NavigationMaskWH);
    }];
}
#pragma mark 创建加入购物车视图
- (void)createBottomView {
    self.bottomView = [UIView new];
    [self.view addSubview:self.bottomView];
    self.bottomView.frame = CGRectMake(0, SCREENHEIGHT - BottomHeitht, SCREENWIDTH, BottomHeitht);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *shopCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:shopCartButton];
    shopCartButton.layer.cornerRadius = 20.;
    shopCartButton.backgroundColor = [UIColor blackColor];
    shopCartButton.alpha = 0.6;
    shopCartButton.tag = 100;
    [shopCartButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *shopCartImage = [UIImageView new];
    [shopCartButton addSubview:shopCartImage];
    shopCartImage.image = [UIImage imageNamed:@"gouwucheicon2"];
    
    self.cartsLabel = [UILabel new];
    [shopCartImage addSubview:self.cartsLabel];
    self.cartsLabel.font = [UIFont systemFontOfSize:12.];
    self.cartsLabel.textColor = [UIColor whiteColor];
    self.cartsLabel.backgroundColor = [UIColor redColor];
    self.cartsLabel.textAlignment = NSTextAlignmentCenter;
    self.cartsLabel.layer.cornerRadius = 10.;
    self.cartsLabel.layer.masksToBounds = YES;
    self.cartsLabel.hidden = YES;
    
    UIButton *addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:addCartButton];
    addCartButton.layer.cornerRadius = 20.;
    addCartButton.tag = 101;
    addCartButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addCartButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [addCartButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addCartButton = addCartButton;
    kWeakSelf
    [shopCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset(15);
        make.width.height.mas_equalTo(@40);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
    }];
    [shopCartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopCartButton.mas_centerX);
        make.centerY.equalTo(shopCartButton.mas_centerY);
        make.width.height.mas_equalTo(@20);
    }];
    [addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopCartButton.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(SCREENWIDTH - 85));
    }];
    [self.cartsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopCartImage.mas_right).offset(-5);
        make.bottom.equalTo(shopCartImage.mas_top).offset(5);
        make.width.height.mas_equalTo(@20);
    }];
    
}

@end






































































































