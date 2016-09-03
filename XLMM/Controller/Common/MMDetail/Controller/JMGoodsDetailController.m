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
#import "JMSelecterButton.h"
#import "CartListModel.h"
#import "JMPurchaseController.h"

#define BottomHeitht 60.0
#define RollHeight 20.0
#define HeaderScrolHeight SCREENHEIGHT * 0.65
#define POPHeight SCREENHEIGHT * 0.6
#define NavigationMaskWH 36
#define kBottomViewTag 100

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
    
    NSMutableDictionary *_paramer;
    
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
@property (nonatomic, strong) UIButton *shopCartButton;
@property (nonatomic, strong) UIButton *addCartButton;
@property (nonatomic, strong) JMSelecterButton *groupBuyPersonal;
@property (nonatomic, strong) JMSelecterButton *groupBuyTeam;
@end

@implementation JMGoodsDetailController {
    NSMutableArray *goodsArray; // 商品属性数据
    NSInteger _cartsGoodsNum;   // 购物车数量
    BOOL _isAddcart;            // 判断商品是否即将开售
    BOOL _isTeamBuyGoods;       // 判断商品是否可以团购
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [MobClick beginLogPageView:@"JMGoodsDetailController"];
    [self loadCatrsNumData];
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
    
    _paramer = [NSMutableDictionary dictionary];
    
    [self lodaDataSource];          // 商品详情数据源
    [self loadShareData];           // 分享数据
    [self createContentView];       // 创建内容视图
    [self setupHeadView];           // 创建头部滚动视图
    [self createBottomView];        // 底部购物车,购买按钮
    [self createNavigationView];    // 自定义导航控制器视图

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
- (void)setupHeadView {
    JMAutoLoopScrollView *scrollView = [[JMAutoLoopScrollView alloc] initWithStyle:JMAutoLoopScrollStyleHorizontal];
    self.goodsScrollView = scrollView;
    scrollView.jm_scrollDataSource = self;
    scrollView.jm_scrollDelegate = self;
    scrollView.frame = CGRectMake(0, 0, SCREENWIDTH, HeaderScrolHeight);
    scrollView.jm_isStopScrollForSingleCount = NO;
    scrollView.jm_autoScrollInterval = 3.;
    [scrollView jm_registerClass:[JMGoodsLoopRollView class]];
    self.tableView.tableHeaderView = scrollView;
}
- (void)loadShareData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/share/model?model_id=%@",Root_URL,self.goodsID];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        self.shareModel = [JMShareModel mj_objectWithKeyValues:responseObject];
        self.shareModel.share_type = @"link";
    } WithFail:^(NSError *error) {
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
            self.cartsLabel.hidden = NO;
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
        [self fetchData:responseObject];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchData:(NSDictionary *)goodsDetailDic {
    detailContentDic = [NSDictionary dictionary];
    detailContentDic = goodsDetailDic[@"detail_content"];
    self.topImageArray = detailContentDic[@"head_imgs"];
    [self.goodsScrollView jm_reloadData];

    NSDictionary *comparison = goodsDetailDic[@"comparison"];
    NSArray *attributes = comparison[@"attributes"];
    for (NSDictionary *dic in attributes) {
        JMDescLabelModel *model = [JMDescLabelModel mj_objectWithKeyValues:dic];
        [self.attributeArray addObject:model];
    }
    coustomInfoDic = [NSDictionary dictionary];
    coustomInfoDic = goodsDetailDic[@"custom_info"];
    goodsArray = goodsDetailDic[@"sku_info"];
    
    NSString *saleStatus = detailContentDic[@"sale_state"];
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
    // 在这里拿到数据后先判断是否是团购商品 | 团购商品有teambuy_info字段 非团购无   --> 如果是团购商品,购买按钮为单人购买和团购
    if ([goodsDetailDic isKindOfClass:[NSDictionary class]] && [goodsDetailDic objectForKey:@"teambuy_info"]) {
        NSDictionary *dic = goodsDetailDic[@"teambuy_info"];
        if ([dic[@"teambuy"] boolValue]) {
            _isTeamBuyGoods = YES;
            self.groupBuyPersonal.hidden = NO;
            self.groupBuyTeam.hidden = NO;
            self.addCartButton.hidden = YES;
            CGFloat moneyValueTeam = [dic[@"teambuy_price"] floatValue];
            CGFloat moneyValuePersonal = [detailContentDic[@"lowest_agent_price"] floatValue];
            NSString *teamString = [NSString stringWithFormat:@"%@人购 ¥%.1f",dic[@"teambuy_person_num"],moneyValueTeam];
            NSString *personalString = [NSString stringWithFormat:@"单人购 ¥%.1f",moneyValuePersonal];
            [self.groupBuyTeam setTitle:teamString forState:UIControlStateNormal];
            [self.groupBuyPersonal setTitle:personalString forState:UIControlStateNormal];
        }else {
            _isTeamBuyGoods = NO;
            self.addCartButton.hidden = NO;
        }
    }else {
        _isTeamBuyGoods = NO;
        self.addCartButton.hidden = NO;
    }
    if (goodsArray.count == 0) {
        return ;
    }else {
        NSDictionary *itemDic = goodsArray[0];
        NSDictionary *skuDic = itemDic[@"sku_items"][0];
        _paramer[@"item_id"] = itemDic[@"product_id"];
        _paramer[@"sku_id"] = skuDic[@"sku_id"];
        _paramer[@"num"] = @"1";
        [self.popView initTypeSizeView:goodsArray TitleString:detailContentDic[@"name"]];
    }
    [self.tableView reloadData];
}
- (void)navigationBarButton:(UIButton *)button {
    if (button.tag == 100 || button.tag == 102) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        JMShareViewController *shareView = [[JMShareViewController alloc] init];
        self.goodsShareView = shareView;
        self.goodsShareView.model = self.shareModel;
        JMShareView *cover = [JMShareView show];
        cover.delegate = self;
        JMPopView *menu = [JMPopView showInRect:CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240)];
        menu.contentView = self.goodsShareView.view;
    }
}
#pragma mark --- 点击隐藏弹出视图
- (void)coverDidClickCover:(JMShareView *)cover {
    [JMPopView hide];
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
        cell.block = ^(UIButton *button) {
            BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
            if (login == NO) {
                button.selected = NO;
                JMLogInViewController *enterVC = [[JMLogInViewController alloc] init];
                [self.navigationController pushViewController:enterVC animated:YES];
                return;
            }else {
                if (button.selected == NO) {
                    // 收藏
                    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/favorites",Root_URL];
                    NSMutableDictionary *param = [NSMutableDictionary dictionary];
                    param[@"model_id"] = self.goodsID;
                    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:param WithSuccess:^(id responseObject) {
                        if (!responseObject) return ;
                        NSLog(@"%@",responseObject);
                        NSInteger code = [responseObject[@"code"] integerValue];
                        if (code == 0) {
                            button.selected = YES;
                            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                        }else {
                            button.selected = NO;
                            [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
                        }
                    } WithFail:^(NSError *error) {
                        button.selected = NO;
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
                            button.selected = NO;
                            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                        }else {
                            button.selected = YES;
                            [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
                        }
                    } WithFail:^(NSError *error) {
                        button.selected = YES;
                    } Progress:^(float progress) {
                    }];
                }
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
        }else { }
        if (offset <= self.tableView.contentSize.height - SCREENHEIGHT + RollHeight + BottomHeitht) {
            self.upViewLabel.text = @"继续拖动,查看图文详情";
        }else { }
    }else {
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
- (void)composeGoodsInfoView:(JMGoodsInfoPopView *)popView AttrubuteDic:(NSMutableDictionary *)attrubuteDic {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
    [self addCartUrlString:urlString Paramer:attrubuteDic];
}
- (void)addCartUrlString:(NSString *)urlString Paramer:(NSMutableDictionary *)paramer {
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:paramer WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        NSLog(@"%@",responseObject);
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            if ([paramer isKindOfClass:[NSMutableDictionary class]] && [paramer objectForKey:@"type"]) {
                [self getCartsFirstGoodsInfo];
            }else {
                [MBProgressHUD showSuccess:@"加入购物车成功"];
            }
            self.cartsLabel.hidden = NO;
            self.cartsLabel.text = [NSString stringWithFormat:@"%ld",_cartsGoodsNum];
            [self loadCatrsNumData];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
        if (!_isTeamBuyGoods) [self hideMaskView];
    } WithFail:^(NSError *error) {
        if (!_isTeamBuyGoods) {
            [self hideMaskView];
            [MBProgressHUD showError:@"加入购物车失败"];
        }else {
            [MBProgressHUD showError:@"拼团失败"];
        }
    } Progress:^(float progress) {
    }];
}
#pragma mark - LPAutoScrollViewDatasource,LPAutoScrollViewDelegate
- (NSUInteger)jm_numberOfNewViewInScrollView:(JMAutoLoopScrollView *)scrollView {
    return self.topImageArray.count;
}
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView newViewIndex:(NSUInteger)index forRollView:(JMGoodsLoopRollView *)rollView {
    rollView.imageString = self.topImageArray[index];
}
- (void)jm_scrollView:(JMAutoLoopScrollView *)scrollView didSelectedIndex:(NSUInteger)index {
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
    addCartButton.tag = kBottomViewTag + 1;
    addCartButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addCartButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [addCartButton addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    self.addCartButton = addCartButton;
    self.addCartButton.hidden = YES;
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
        make.width.mas_equalTo(@(SCREENWIDTH - 85));
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
    self.groupBuyPersonal.tag = kBottomViewTag + 2;
    [self.groupBuyPersonal addTarget:self action:@selector(cartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.groupBuyTeam = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.groupBuyTeam];
    [self.groupBuyTeam setNomalBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"团购 ¥ xxx" TitleFont:14. CornerRadius:20.];
    self.groupBuyTeam.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.groupBuyTeam.tag = kBottomViewTag + 3;
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
- (void)cartButton:(UIButton *)button {
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defalts boolForKey:kIsLogin];
    if (button.tag == kBottomViewTag + 0) {
        if (isLogin) {
            CartViewController *cartVC = [[CartViewController alloc] init];
            [self.navigationController pushViewController:cartVC animated:YES];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (button.tag == kBottomViewTag + 1) {
        if (isLogin) {
            [self showPopView];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (button.tag == kBottomViewTag + 2) {
        if (isLogin) {
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
            [self addCartUrlString:urlString Paramer:_paramer];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else if (button.tag == kBottomViewTag + 3) {
        if (isLogin) {
            _paramer[@"type"] = @"3";
            NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts",Root_URL];
            [self addCartUrlString:urlString Paramer:_paramer];
        }else {
            JMLogInViewController *loginVC = [[JMLogInViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }else { }
}
- (void)getCartsFirstGoodsInfo {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"tyoe"] = @"3";
//    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts.json",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kCart_URL WithParaments:_paramer WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
        [self fetchedCartData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"拼团失败,请稍后重试"];
    } Progress:^(float progress) {
    }];
}
- (void)fetchedCartData:(NSArray *)careArr {
    if (careArr.count == 0) return ;
    JMPurchaseController *purchaseVC = [[JMPurchaseController alloc] init];
    NSMutableArray *cartArray = [NSMutableArray array];
    NSDictionary *dic = careArr[0];
    CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
    [cartArray addObject:model];
    purchaseVC.purchaseGoodsArr = cartArray;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}

@end
































































































