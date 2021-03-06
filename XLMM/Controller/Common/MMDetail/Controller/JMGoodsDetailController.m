//
//  JMGoodsDetailController.m
//  XLMM
//
//  Created by zhang on 16/8/8.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMGoodsDetailController.h"
#import "JMGoodsAttributeCell.h"
#import "JMGoodsExplainCell.h"
#import "JMGoodsInfoPopView.h"
#import "JMGoodsSafeGuardCell.h"
#import "IMYWebView.h"
#import "JMShareViewController.h"
#import "JMShareModel.h"
#import "JMDescLabelModel.h"
#import "JMLogInViewController.h"
#import "JMSelecterButton.h"
#import "CartListModel.h"
#import "JMPurchaseController.h"
#import "JMAutoLoopPageView.h"
#import "JMGoodsLoopRollCell.h"
#import "JMPopViewAnimationDrop.h"
#import "JMCartViewController.h"
#import "JumpUtils.h"
#import "JMPushingDaysController.h"


#define BottomHeitht 60.0
#define RollHeight 20.0
#define HeaderScrolHeight SCREENHEIGHT * 0.65
//#define POPHeight SCREENHEIGHT * 0.6
#define NavigationMaskWH 36
#define kBottomViewTag 200
static NSString *currentCartsType = @"5"; // 当前购物车的类型 (普通购物车 type=0 , 精品购物车 type=5 , 团购 type=3) 默认为 @5;

@interface JMGoodsDetailController ()<JMGoodsInfoPopViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,WKScriptMessageHandler,IMYWebViewDelegate,JMAutoLoopPageViewDataSource,JMAutoLoopPageViewDelegate> {
    CGFloat maxY;
    CGFloat minY;
    CGFloat popHeight;
    BOOL isShowGoodsDetail;
    
    BOOL isTop;                 // 顶部视图 -- > 判断动画不同
    BOOL isShowTop;             // 顶部视图弹出开团  --> 当isShowTop为假时才显示
    
    NSMutableArray *_sizeArray;
    NSMutableArray *_colorArray;
    NSMutableDictionary *_stockDict;
    NSMutableArray *_imageArray;
    
    NSDictionary *detailContentDic;
    NSDictionary *coustomInfoDic;
    
    NSMutableDictionary *_paramer;
    
    NSMutableArray *goodsArray; // 商品属性数据
    NSInteger _cartsGoodsNum;   // 购物车数量
    BOOL _isAddcart;            // 判断商品是否即将开售
    BOOL _isTeamBuyGoods;       // 判断商品是否可以团购
    BOOL _isDirectBuyGoods;     // 判断商品是否可以直接跳转支付页面 (精品商品)
    BOOL _isFineGoods;          // 判断商品是否是精品商品
    BOOL _isFineGoodsHeightShow;// 是否显示精品商品
    NSString *_buyCouponUrl;    // 购买精品券的链接
    BOOL _isUserClickAddCart;   // 用户点击加入购物车
    NSInteger _goodsAddressLevel;// 商品的地址信息登记
    
}
@property (nonatomic, strong) JMShareViewController *goodsShareView;

@property (nonatomic, strong) UIView *allContentView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) IMYWebView *detailWebView;

@property (nonatomic, strong) UILabel *upViewLabel;
@property (nonatomic, strong) UILabel *downViewLabel;

@property (nonatomic, strong) JMAutoLoopPageView *pageView;
//@property (nonatomic, strong) JMAutoLoopScrollView *goodsScrollView;
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
@property (nonatomic, strong) UIButton *shopCartButton;
@property (nonatomic, strong) UIButton *addCartButton;
@property (nonatomic, strong) UIButton *buyNowButton;
@property (nonatomic, strong) JMSelecterButton *groupBuyPersonal;
@property (nonatomic, strong) JMSelecterButton *groupBuyTeam;


@end

@implementation JMGoodsDetailController

#pragma mark -- 懒加载 --
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
        _popView = [[JMGoodsInfoPopView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, popHeight)];
        _popView.delegate = self;
        _popView.backgroundColor = [UIColor whiteColor];
    }
    return _popView;
}
- (JMShareViewController *)goodsShareView {
    if (!_goodsShareView) {
        _goodsShareView = [[JMShareViewController alloc] init];
    }
    return _goodsShareView;
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

#pragma mark --- 视图生命周期 ---
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MobClick event:@"checkGoodsDetail"];
    [MobClick beginLogPageView:@"JMGoodsDetailController"];
    [self loadCatrsNumData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:@"JMGoodsDetailController"];
    if (self.pageView) {
        [self.pageView endAutoScroll];
    }
}
- (void)dealloc {
    if (self.pageView) {
        [self.pageView removeFromSuperview];
        self.pageView = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showLoading:@""];
    self.view.backgroundColor = [UIColor countLabelColor];
    [self createNavigationBarWithTitle:@"" selecotr:nil];
    
    popHeight = SCREENHEIGHT * 0.6;
    _paramer = [NSMutableDictionary dictionary];
    BOOL isXLMM = [JMUserDefaults boolForKey:kISXLMM];
    BOOL isLogin = [JMUserDefaults boolForKey:kIsLogin];
    _isFineGoodsHeightShow = isXLMM && isLogin;
    _goodsAddressLevel = 0;
    
    [self lodaDataSource];          // 商品详情数据源
    [self loadShareData];           // 分享数据
    [self createContentView];       // 创建内容视图
    [self setupHeadView];           // 创建头部滚动视图
    [self createBottomView];        // 底部购物车,购买按钮
    [self createNavigationView];    // 自定义导航控制器视图
    
}

#pragma mark ---- 创建UI ----
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
    self.detailWebView.viewController = self;
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
- (void)setupHeadView {
    self.pageView = [[JMAutoLoopPageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HeaderScrolHeight)];
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    _pageView.isCreatePageControl = YES;
    [self.pageView registerCellWithClass:[JMGoodsLoopRollCell class] identifier:@"JMGoodsLoopRollCell"];
    self.pageView.scrollStyle = JMAutoLoopScrollStyleHorizontal;
    self.pageView.scrollDirectionStyle = JMAutoLoopScrollStyleAscending;
    self.pageView.scrollForSingleCount = NO;
    self.pageView.atuoLoopScroll = YES;
    self.pageView.scrollFuture = YES;
    self.pageView.autoScrollInterVal = 4.0f;
    self.tableView.tableHeaderView = self.pageView;
}

#pragma mark ---- 网络请求,数据处理
- (void)loadShareData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,self.goodsID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        self.shareModel.share_type = @"link";
        self.goodsShareView.model = self.shareModel;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)loadCatrsNumData {
    if ([NSString isStringEmpty:currentCartsType]) {
        return ;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_num?type=%@",Root_URL,currentCartsType];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        _cartsGoodsNum = [responseObject[@"result"] integerValue];
        if (_cartsGoodsNum == 0) {
            self.cartsLabel.hidden = YES;
        }else {
            self.cartsLabel.hidden = NO;
            self.cartsLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)lodaDataSource {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/modelproducts/%@",Root_URL,self.goodsID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:[urlString JMUrlEncodedString] WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchData:responseObject];
        [self loadCatrsNumData];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchData:(NSDictionary *)goodsDetailDic {
    detailContentDic = [NSDictionary dictionary];
    detailContentDic = goodsDetailDic[@"detail_content"];
    _goodsAddressLevel = [goodsDetailDic[@"source_type"] integerValue];
    
    NSString *waterMark = detailContentDic[@"watermark_op"];
    NSArray *imageArr = detailContentDic[@"head_imgs"];
    if ([NSString isStringEmpty:waterMark]) {
        for (NSString *imageUrl in imageArr) {
            NSString *imageUrlStr = [imageUrl imageNormalCompression];
            [self.topImageArray addObject:imageUrlStr];
        }
    }else {
        for (NSString *imageUrl in imageArr) {
            NSString *imageUrlStr = [NSString stringWithFormat:@"%@|%@",[imageUrl imageNormalCompression],waterMark];
            [self.topImageArray addObject:imageUrlStr];
        }
        
    }

    self.topImageArray = detailContentDic[@"head_imgs"];
    //    [self.goodsScrollView jm_reloadData];
    [self.pageView reloadData];
    NSDictionary *comparison = goodsDetailDic[@"comparison"];
    NSArray *attributes = comparison[@"attributes"];
    for (NSDictionary *dic in attributes) {
        JMDescLabelModel *model = [JMDescLabelModel mj_objectWithKeyValues:dic];
        [self.attributeArray addObject:model];
    }
    coustomInfoDic = [NSDictionary dictionary];
    coustomInfoDic = goodsDetailDic[@"custom_info"];
    goodsArray = goodsDetailDic[@"sku_info"];
    
    // 在这里拿到数据后先判断是否是团购商品 | 团购商品有teambuy_info字段 非团购无   --> 如果是团购商品,购买按钮为单人购买和团购
    if ([goodsDetailDic isKindOfClass:[NSDictionary class]] && [goodsDetailDic objectForKey:@"teambuy_info"]) {
        //        NSArray *teamNumBuy = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
        NSDictionary *dic = goodsDetailDic[@"teambuy_info"];
        NSInteger code1 = [dic[@"teambuy_person_num"] integerValue];
        if ([dic[@"teambuy"] boolValue]) {
            _isTeamBuyGoods = YES;
            self.groupBuyPersonal.hidden = NO;
            self.groupBuyTeam.hidden = NO;
            self.addCartButton.hidden = YES;
            self.buyNowButton.hidden = YES;
            CGFloat moneyValueTeam = [dic[@"teambuy_price"] floatValue];
            CGFloat moneyValuePersonal = [detailContentDic[@"lowest_agent_price"] floatValue];
            NSString *teamString = [NSString stringWithFormat:@"%ld人购 ¥%.1f", (long)code1, moneyValueTeam];
            NSString *personalString = [NSString stringWithFormat:@"单人购 ¥%.1f",moneyValuePersonal];
            [self.groupBuyTeam setTitle:teamString forState:UIControlStateNormal];
            [self.groupBuyPersonal setTitle:personalString forState:UIControlStateNormal];
        }else {
            _isTeamBuyGoods = NO;
            self.addCartButton.hidden = NO;
            self.buyNowButton.hidden = NO;
        }
    }else {
        _isTeamBuyGoods = NO;
        self.addCartButton.hidden = NO;
        self.buyNowButton.hidden = NO;
    }
    // === 显示商品出售状态 === //
    _isDirectBuyGoods = [detailContentDic[@"is_onsale"] boolValue];
    _isFineGoods = [detailContentDic[@"is_boutique"] boolValue];
    NSString *saleStatus = detailContentDic[@"sale_state"];
    
    if (_isFineGoods) {
//        [self.addCartButton setTitle:@"立即购买" forState:UIControlStateNormal];
        currentCartsType = @"5";
    }else {
        currentCartsType = @"0";
    }
    
    if (_isTeamBuyGoods) { // 团购
        currentCartsType = @"3";
        if ([saleStatus isEqual:@"on"]) {
            if ([detailContentDic[@"is_sale_out"] boolValue]) {
                [self getStatusButton:YES];
                [self.addCartButton setTitle:@"已抢光" forState:UIControlStateNormal];
                self.addCartButton.enabled = NO;
            }else {
                [self getStatusButton:NO];
            }
        }else if ([saleStatus isEqual:@"off"]) {
            [self getStatusButton:YES];
            [self.addCartButton setTitle:@"已下架" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }else if ([saleStatus isEqual:@"will"]) {
            [self getStatusButton:YES];
            [self.addCartButton setTitle:@"即将开售" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }else {
        }
    }else {
        if ([saleStatus isEqual:@"on"]) {
            if ([detailContentDic[@"is_sale_out"] boolValue]) {
                [self.addCartButton setTitle:@"已抢光" forState:UIControlStateNormal];
                self.addCartButton.enabled = NO;
            }else {
                self.addCartButton.enabled = YES;
            }
        }else if ([saleStatus isEqual:@"off"]) {
            [self.addCartButton setTitle:@"已下架" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }else if ([saleStatus isEqual:@"will"]) {
            [self.addCartButton setTitle:@"即将开售" forState:UIControlStateNormal];
            self.addCartButton.enabled = NO;
        }else {
        }
    }
    
    
    if (goodsArray.count == 0) {
        return ;
    }else {
        for (NSDictionary *itemDic in goodsArray) {
            NSArray *arr = itemDic[@"sku_items"];
            if (arr.count == 0) {
                continue;
            }else {
                if (arr.count == 1 && goodsArray.count == 1) {
                    popHeight = 220.f;
//                    self.popView.mj_h = popHeight;
                }
                NSDictionary *skuDic = arr[0];
                _paramer[@"item_id"] = itemDic[@"product_id"];
                _paramer[@"sku_id"] = skuDic[@"sku_id"];
                _paramer[@"num"] = @"1";
                [self.popView initTypeSizeView:goodsArray TitleString:detailContentDic[@"name"]];
                break;
            }
        }
//        NSDictionary *itemDic = goodsArray[0];
//        NSDictionary *skuDic = itemDic[@"sku_items"][0];
    }
    _buyCouponUrl = goodsDetailDic[@"buy_coupon_url"];
    
    if (!_isTeamBuyGoods) {
        if (_isDirectBuyGoods) {
            self.addCartButton.hidden = YES;
            self.buyNowButton.hidden = NO;
            kWeakSelf
            [self.buyNowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.shopCartButton.mas_right).offset(15);
                make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
                make.height.mas_equalTo(@40);
                make.width.mas_equalTo(@(SCREENWIDTH - 85));
            }];
        }
    }
    
    [self.tableView reloadData];
}
- (void)getStatusButton:(BOOL)isShow {
    if (isShow) {
        self.groupBuyPersonal.hidden = YES;
        self.groupBuyTeam.hidden = YES;
        self.addCartButton.hidden = NO;
        self.buyNowButton.hidden = NO;
    }else {
        self.groupBuyPersonal.hidden = NO;
        self.groupBuyTeam.hidden = NO;
        self.addCartButton.hidden = YES;
        self.buyNowButton.hidden = YES;
    }
}
#pragma mark ==== 导航栏点击事件 ====
- (void)navigationBarButton:(UIButton *)button {
    if (button.tag == 100 || button.tag == 102) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [MobClick event:@"GoodsDetail_share"];
        [[JMGlobal global] showpopBoxType:popViewTypeShare Frame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 340) ViewController:self.goodsShareView WithBlock:^(UIView *maskView) {
        }];
        self.goodsShareView.blcok = ^(UIButton *button) {
            [MobClick event:@"GoodsDetail_share_fail_clickCancelButton"];
        };
    }
}
#pragma mark --- UITableView 代理 ----
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
        if (_isFineGoods && _isFineGoodsHeightShow) {
            if (_goodsAddressLevel > 1) {
                CGFloat promptLabelHeight = [orderLevelInfo heightWithWidth:SCREENWIDTH - 10 andFont:12.].height + 20;
                return 190 + promptLabelHeight;
            }
            return 190;
        }
        
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
        cell.promptIndex = _goodsAddressLevel;
        cell.block = ^(UIButton *button) {
            if (button.tag == 100) {
                if ([[JMGlobal global] userVerificationLogin]) {
                    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/page_list?model_id=%@",Root_URL,self.goodsID];
                    //    urlString = [NSString stringWithFormat:@"%@?model_id=%@",urlString,model.fineCouponModelID];
                    JMPushingDaysController *pushVC = [[JMPushingDaysController alloc] init];
                    //                pushVC.isPushingDays = YES;
                    pushVC.pushungDaysURL = urlString;
                    pushVC.navTitle = @"文案精选";
                    [self.navigationController pushViewController:pushVC animated:YES];
                }else {
                    [[JMGlobal global] showLoginViewController];
                }
            }else {
                // webview跳转
                [JumpUtils jumpToLocation:_buyCouponUrl viewController:self];
                
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
#pragma mark ---- UIScrollView 代理 ----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.tableView) {
        self.pageView.mj_origin = CGPointMake(self.pageView.mj_origin.x, 0); // self.pageView.mj_origin.x --> self.goodsScrollView.contentSize
        if (self.tableView.contentOffset.y >= 0 &&  self.tableView.contentOffset.y <= HeaderScrolHeight) {
            self.pageView.mj_origin = CGPointMake(self.pageView.mj_origin.x, -offset / 2.0f);
            CGFloat scrolHeight = HeaderScrolHeight - 80;
            CGFloat yOffset = offset / scrolHeight;
            yOffset = MAX(0, MIN(1, yOffset));
            self.navigationView.alpha = yOffset;
            self.backToRootView.alpha = 0.7 - yOffset;
            self.shareView.alpha = 0.7 - yOffset;
        }else if (self.tableView.contentOffset.y <= 0 && self.tableView.contentOffset.y <= HeaderScrolHeight) {
            self.navigationView.alpha = 0.;
        }else { }
        if (offset <= self.tableView.contentSize.height - SCREENHEIGHT + RollHeight + BottomHeitht) {
            self.upViewLabel.text = @"继续拖动,查看图文详情";
        }else { }
    }else {
        self.downViewLabel.text = (offset<= - 60) ? @"释放返回商品详情" : @"下拉返回商品详情";
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

#pragma mark ---- 自定义弹出视图 (显示/隐藏) ----
- (void)showPopView {
    isTop = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.popView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.layer.transform = [JMPopViewAnimationDrop firstStepTransform];
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [JMPopViewAnimationDrop secondStepTransform];
            self.popView.transform = CGAffineTransformTranslate(self.popView.transform, 0, -popHeight);
        }];
    }];
}
- (void)hideMaskView {
    if (isTop) {
        isShowTop = NO;
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [JMPopViewAnimationDrop firstStepTransform];
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
#pragma mark -- 加入购物车选择商品属性回调
- (void)composeGoodsInfoView:(JMGoodsInfoPopView *)popView AttrubuteDic:(NSMutableDictionary *)attrubuteDic {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts?type=%@",Root_URL,currentCartsType];
//    if (_isDirectBuyGoods) {
        [MBProgressHUD showLoading:@""];
//    }else {
//        [MBProgressHUD showLoading:@"正在加入购物车~"];
//    }
//    if (_isFineGoods) {
        attrubuteDic[@"type"] = @"5";
//    }else {
//        attrubuteDic[@"type"] = @"0";
//    }
    [self addCartUrlString:urlString Paramer:attrubuteDic];
}
- (void)addCartUrlString:(NSString *)urlString Paramer:(NSMutableDictionary *)paramer {
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:paramer WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            NSInteger typeNumber = [paramer[@"type"] integerValue];
            if (typeNumber == 3) {
                [MobClick event:@"TeamAddShoppingCartSuccess"];
                [self getCartsFirstGoodsInfoGoodsTypeNumber:@(typeNumber) Parmer:paramer];
            }else if (typeNumber == 5 && _isUserClickAddCart == NO) {
                [MobClick event:@"TspecialAddShoppingCartSuccess"];
                [self getCartsFirstGoodsInfoGoodsTypeNumber:@(typeNumber) Parmer:paramer];
            }else {
                [MBProgressHUD showSuccess:@"加入购物车成功"];
                [MobClick event:@"AddShoppingCartSuccess"];
                self.cartsLabel.hidden = NO;
                self.popView.sureButton.enabled = YES;
                self.cartsLabel.text = [NSString stringWithFormat:@"%ld",_cartsGoodsNum];
                [self loadCatrsNumData];
            }
        }else {
            self.popView.sureButton.enabled = YES;
            [MBProgressHUD showWarning:responseObject[@"info"]];
            NSDictionary *temp_dict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
            [MobClick event:@"addShoppingCartFail" attributes:temp_dict];
        }
        if (!_isTeamBuyGoods) [self hideMaskView];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求失败,请检查网络后重试"];
        self.popView.sureButton.enabled = YES;
        if (!_isTeamBuyGoods) {
            [self hideMaskView];
            if (_isDirectBuyGoods) {
            }else {
                [MobClick event:@"addShoppingCartFail"];
            }
        }else {
            [MobClick event:@"TeamAddShoppingCartFail"];
        }
    } Progress:^(float progress) {
    }];
}
#pragma mark - LPAutoScrollViewDatasource,LPAutoScrollViewDelegate
#pragma mark 顶部视图滚动协议方法
- (NSUInteger)numberOfItemWithPageView:(JMAutoLoopPageView *)pageView {
    return self.topImageArray.count;
}
- (void)configCell:(__kindof UICollectionViewCell *)cell Index:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    JMGoodsLoopRollCell *testCell = cell;
    NSString *string = self.topImageArray[index];
    testCell.imageString = string;
}
- (NSString *)cellIndentifierWithIndex:(NSUInteger)index PageView:(JMAutoLoopPageView *)pageView {
    return @"JMGoodsLoopRollCell";
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidScrollToIndex:(NSUInteger)index {
}
- (void)JMAutoLoopPageView:(JMAutoLoopPageView *)pageView DidSelectedIndex:(NSUInteger)index {
}
//- (NSUInteger)jm_numberOfNewViewInScrollView:(JMAutoLoopScrollView *)scrollView {
//
//}
//- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView newViewIndex:(NSUInteger)index forRollView:(JMGoodsLoopRollView *)rollView {
//    rollView.imageString = self.topImageArray[index];
//}
//- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didSelectedIndex:(NSUInteger)index {
//}
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
    shopCartButton.tag = kBottomViewTag + 0;
    [shopCartButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.shopCartButton = shopCartButton;
    
    UIImageView *shopCartImage = [UIImageView new];
    [shopCartButton addSubview:shopCartImage];
    shopCartImage.image = [UIImage imageNamed:@"goodsDetailCarts"];
    
    self.cartsLabel = [UILabel new];
    [shopCartImage addSubview:self.cartsLabel];
    self.cartsLabel.font = [UIFont systemFontOfSize:11.];
    self.cartsLabel.textColor = [UIColor whiteColor];
    self.cartsLabel.backgroundColor = [UIColor redColor];
    self.cartsLabel.textAlignment = NSTextAlignmentCenter;
    self.cartsLabel.layer.cornerRadius = 8.;
    self.cartsLabel.layer.masksToBounds = YES;
    self.cartsLabel.hidden = YES;
    
    UIButton *addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:addCartButton];
    addCartButton.layer.cornerRadius = 20.;
    addCartButton.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    addCartButton.layer.borderWidth = 1.0f;
    addCartButton.tag = kBottomViewTag + 1;
    addCartButton.backgroundColor = [UIColor whiteColor];
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor buttonEnabledBackgroundColor] forState:UIControlStateNormal];
    addCartButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [addCartButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addCartButton = addCartButton;
    self.addCartButton.hidden = YES;
    
    UIButton *buyNowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:buyNowButton];
    buyNowButton.layer.cornerRadius = 20.;
    buyNowButton.tag = kBottomViewTag + 2;
    buyNowButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [buyNowButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyNowButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [buyNowButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.buyNowButton = buyNowButton;
    self.buyNowButton.hidden = YES;

    kWeakSelf
    [shopCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset(15);
        make.width.height.mas_equalTo(@40);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
    }];
    [shopCartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(shopCartButton.mas_centerX);
        make.centerY.equalTo(shopCartButton.mas_centerY);
        make.width.height.mas_equalTo(@40);
    }];
    [addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopCartButton.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(SCREENWIDTH / 2 - 50));
    }];
    [buyNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addCartButton.mas_right).offset(15);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@(SCREENWIDTH / 2 - 50));
    }];
    [self.cartsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopCartImage.mas_right).offset(-15);
        make.bottom.equalTo(shopCartImage.mas_top).offset(15);
        make.width.height.mas_equalTo(@16);
    }];
    
    // === 如果是团购商品 === //
    self.groupBuyPersonal = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.groupBuyPersonal];
    [self.groupBuyPersonal setNomalBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"个人购 ¥ xxx" TitleFont:14. CornerRadius:20.];
    self.groupBuyPersonal.backgroundColor = [UIColor whiteColor];
    self.groupBuyPersonal.tag = kBottomViewTag + 3;
    [self.groupBuyPersonal addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupBuyTeam = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.groupBuyTeam];
    [self.groupBuyTeam setNomalBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"团购 ¥ xxx" TitleFont:14. CornerRadius:20.];
    self.groupBuyTeam.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.groupBuyTeam.tag = kBottomViewTag + 4;
    [self.groupBuyTeam addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.groupBuyPersonal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomView).offset(70);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.width.mas_equalTo(@((SCREENWIDTH - 70) / 2 - 15));
        make.height.mas_equalTo(@40);
    }];
    [self.groupBuyTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bottomView).offset(-15);
        make.centerY.equalTo(weakSelf.bottomView.mas_centerY);
        make.width.mas_equalTo(@((SCREENWIDTH - 70) / 2 - 15));
        make.height.mas_equalTo(@40);
    }];
    self.groupBuyPersonal.hidden = YES;
    self.groupBuyTeam.hidden = YES;
}
#pragma mark 加入购物车按钮点击事件
- (void)cartButton:(UIButton *)button {
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:1.0f];
    BOOL isLogin = [JMUserDefaults boolForKey:kIsLogin];
    if (button.tag == kBottomViewTag + 0) {
        if (isLogin) {
            JMCartViewController *cartVC = [[JMCartViewController alloc] init];
            cartVC.cartType = currentCartsType;
            [self.navigationController pushViewController:cartVC animated:YES];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
    }else if (button.tag == kBottomViewTag + 1) {  // 加入购物车
        _isUserClickAddCart = YES;
        if (isLogin) {
            [self showPopView];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
    }else if (button.tag == kBottomViewTag + 2) {  // 立即购买
        _isUserClickAddCart = NO;
        if (isLogin) {
            [self showPopView];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
    }else if (button.tag == kBottomViewTag + 3) {
        if (isLogin) {
            _paramer[@"type"] = @"5";
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
            [self addCartUrlString:urlString Paramer:_paramer];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
    }else if (button.tag == kBottomViewTag + 4) {
        if (isLogin) {
            _paramer[@"type"] = @"3";
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
            [self addCartUrlString:urlString Paramer:_paramer];
        }else {
            [[JMGlobal global] showLoginViewController];
        }
    }else { }
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
- (void)getCartsFirstGoodsInfoGoodsTypeNumber:(NSNumber *)directBuyGoodsTypeNumber Parmer:(NSMutableDictionary *)parmer {
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts?type=%@",Root_URL,currentCartsType];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:parmer WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return ;
//        [MBProgressHUD showSuccess:@"加入购物车成功"];
        self.popView.sureButton.enabled = YES;
        [self fetchedCartData:responseObject DirectBuyGoodsTypeNumber:directBuyGoodsTypeNumber];
    } WithFail:^(NSError *error) {
        self.popView.sureButton.enabled = YES;
        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"加入购物车失败"];
    } Progress:^(float progress) {
    }];
}
- (void)fetchedCartData:(NSArray *)careArr DirectBuyGoodsTypeNumber:(NSNumber *)directBuyGoodsTypeNumber {
    if (careArr.count == 0) return ;
    JMPurchaseController *purchaseVC = [[JMPurchaseController alloc] init];
    NSMutableArray *cartArray = [NSMutableArray array];
    NSDictionary *dic = careArr[0];
    CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
    [cartArray addObject:model];
    purchaseVC.purchaseGoods = cartArray;
    purchaseVC.directBuyGoodsTypeNumber = directBuyGoodsTypeNumber;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}



@end












































// 收藏
/*
 BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
 if (login == NO) {
 button.selected = NO;
 JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
 [self.navigationController pushViewController:enterVC animated:YES];
 return;
 }else {
 if (button.selected == NO) {
 // 收藏
 [MBProgressHUD showLoading:@"添加收藏~"];
 NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
 NSMutableDictionary *param = [NSMutableDictionary dictionary];
 param[@"model_id"] = self.goodsID;
 [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
 if (!responseObject) return ;
 NSLog(@"%@",responseObject);
 NSInteger code = [responseObject[@"code"] integerValue];
 if (code == 0) {
 button.selected = YES;
 [MBProgressHUD showSuccess:@"收藏成功"];
 [MobClick event:@"addStoreUpSuccess"];
 }else {
 button.selected = NO;
 [MBProgressHUD showWarning:responseObject[@"info"]];
 NSDictionary *addStoreUpFaildict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
 [MobClick event:@"addStoreUpFail" attributes:addStoreUpFaildict];
 }
 } WithFail:^(NSError *error) {
 button.selected = NO;
 [MobClick event:@"addStoreUpFail"];
 } Progress:^(float progress) {
 
 }];
 }else {
 // 取消收藏
 [MBProgressHUD showLoading:@"取消收藏~"];
 NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
 NSMutableDictionary *param = [NSMutableDictionary dictionary];
 param[@"model_id"] = self.goodsID;
 [JMHTTPManager requestWithType:RequestTypeDELETE WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
 if (!responseObject) return ;
 NSLog(@"%@",responseObject);
 NSInteger code = [responseObject[@"code"] integerValue];
 if (code == 0) {
 button.selected = NO;
 [MBProgressHUD showSuccess:@"取消成功"];
 [MobClick event:@"cancleStoreUpSuccess"];
 }else {
 button.selected = YES;
 [MBProgressHUD showWarning:responseObject[@"info"]];
 NSDictionary *cancleStoreUpFaildict = @{@"code" : [NSString stringWithFormat:@"%ld",code]};
 [MobClick event:@"cancleStoreUpFail" attributes:cancleStoreUpFaildict];
 }
 } WithFail:^(NSError *error) {
 button.selected = YES;
 [MobClick event:@"cancleStoreUpFail"];
 } Progress:^(float progress) {
 }];
 }
 }
 */



















































