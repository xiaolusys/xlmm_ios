//
//  JMCartViewController.m
//  XLMM
//
//  Created by zhang on 16/11/15.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMCartViewController.h"
#import "JMSelecterButton.h"
#import "CartListModel.h"
#import "JMPurchaseController.h"
#import "JMGoodsDetailController.h"
#import "JMEmptyView.h"
#import "JMRichTextTool.h"
#import "JMCartCurrentCell.h"
#import "JMCartHistoryCell.h"

#define kSectionHeaderAndFooterHeight 30.f

@interface JMCartViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, JMCartCurrentCellDelegate, JMCartHistoryCellDelegate> {
    BOOL currentCartDownLoad;
    BOOL historyCartDownLoad;
    BOOL isEmpty;
    float allPrice;
    NSInteger _currentRowIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) JMSelecterButton *sureButton;
@property (nonatomic, strong) UILabel *payMentMoneyLabel;

@property (nonatomic, strong) CartListModel *deleteModel;
@property (nonatomic, strong) NSMutableArray *currentCartDataSource;
@property (nonatomic, strong) NSMutableArray *historyCartDataSource;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) JMEmptyView *emptyView;

@end

@implementation JMCartViewController
- (NSMutableArray *)currentCartDataSource {
    if (!_currentCartDataSource) {
        _currentCartDataSource = [NSMutableArray array];
    }
    return _currentCartDataSource;
}
- (NSMutableArray *)historyCartDataSource {
    if (!_historyCartDataSource) {
        _historyCartDataSource = [NSMutableArray array];
    }
    return _historyCartDataSource;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ShoppingCart"];
    
    [[JMGlobal global] showWaitLoadingInView:self.view];
    isEmpty = YES;
    currentCartDownLoad = NO;
    historyCartDownLoad = NO;
    [self downloadCurrentCartData];
    [self downloadHistoryCartData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShoppingCart"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.isHideNavigationLeftItem) {
        [self createNavigationBarWithTitle:@"购物车" selecotr:nil];
    }else {
        [self createNavigationBarWithTitle:@"购物车" selecotr:@selector(backClick)];
    }
    
    
    [self createTableView];
    
    
    
    
}
//- (void)refreshCartData {
//    currentCartDownLoad = NO;
//    historyCartDownLoad = NO;
//    [self downloadCurrentCartData];
//    [self downloadHistoryCartData];
//    
//}
- (void)refreshCartData {

}
#pragma mark ======== 获取当前/历史购物车信息 ========
- (void)downloadCurrentCartData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingCartNumChange" object:nil];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts.json?type=5",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return ;
        [self fetchedCartData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[JMGlobal global] hideWaitLoading];
    } Progress:^(float progress) {
        
    }];
    
}
- (void)fetchedCartData:(NSArray *)careArr {
    currentCartDownLoad = YES;
    if (careArr.count > 0) {
        isEmpty = NO;
        [self dismissDefaultView];
    }
    if (careArr.count <= 0 && historyCartDownLoad && isEmpty) {
        [self displayDefaultView];
    }
    [self.currentCartDataSource removeAllObjects];
    allPrice = 0.0f;
    for (NSDictionary *dic in careArr) {
        CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
        allPrice += [model.total_fee floatValue];
        [self.currentCartDataSource addObject:model];
    }
//    self.totalPricelabel.text = [NSString stringWithFormat:@"¥%.2f", allPrice];
    NSString *allPriceString = [NSString stringWithFormat:@"¥%.2f", allPrice];
    NSString *allString = [NSString stringWithFormat:@"应付款金额%@",allPriceString];
    self.payMentMoneyLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allString SubStringArray:@[allPriceString]];
//    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
    if (currentCartDownLoad && historyCartDownLoad) {
        [[JMGlobal global] hideWaitLoading];
    }
    
}
- (void)downloadHistoryCartData {
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/show_carts_history.json?type=5",Root_URL];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        [MBProgressHUD hideHUD];
        if (!responseObject) return ;
        [self fetchedHistoryCartData:responseObject];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [[JMGlobal global] hideWaitLoading];
    } Progress:^(float progress) {
        
    }];
}
- (void)fetchedHistoryCartData:(NSArray *)array {
    historyCartDownLoad = YES;
    if (array.count > 0) {
        isEmpty = NO;
        [self dismissDefaultView];
    }
    if (array.count <= 0 && currentCartDownLoad && isEmpty) {
        [self displayDefaultView];
    }
    [self.historyCartDataSource removeAllObjects];
    for (NSDictionary *dic in array) {
        CartListModel *model = [CartListModel mj_objectWithKeyValues:dic];
        [self.historyCartDataSource addObject:model];
    }
//    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
    if (currentCartDownLoad && historyCartDownLoad) {
        [[JMGlobal global] hideWaitLoading];
    }
}
- (void)displayDefaultView {
    if (self.maskView) {
        return ;
    }
    kWeakSelf
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor whiteColor];
    self.emptyView = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, (SCREENHEIGHT - 240) / 2, SCREENWIDTH, 240) Title:@"你的购物车空空如也~快去装满它吧" DescTitle:@"快去挑选几件喜欢的宝贝吧~" BackImage:@"gouwucheemptyimage" InfoStr:@"随便逛逛"];
    [self.maskView addSubview:self.emptyView];
    self.emptyView.block = ^(NSInteger index) {
        if (index == 100) {
            if (weakSelf.isHideNavigationLeftItem) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
            }else {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    };
}
- (void)dismissDefaultView {
    if (self.maskView) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
}


#pragma mark ======== 创建列表,底部购买按钮 ========
- (void)createTableView {
    kWeakSelf
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor countLabelColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 110;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[JMCartCurrentCell class] forCellReuseIdentifier:JMCartCurrentCellIdentifier];
    [self.tableView registerClass:[JMCartHistoryCell class] forCellReuseIdentifier:JMCartHistoryCellIdentifier];
    
    UIView *bottomView = [UIView new];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];

    CGFloat hideNavigationLeftItemHeight = 0;
    if (self.isHideNavigationLeftItem) {
        hideNavigationLeftItemHeight = 49.;
    }else {
    }
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(64);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.bottom.equalTo(bottomView.mas_top);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-hideNavigationLeftItemHeight);
        make.width.mas_equalTo(@(SCREENWIDTH));
        make.height.mas_equalTo(@(0));
    }];
    
    self.sureButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"确定" TitleFont:15. CornerRadius:20.];
    self.sureButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.bottomView addSubview:self.sureButton];
    [self.sureButton addTarget:self action:@selector(purchaseClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.sureButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.payMentMoneyLabel = [UILabel new];
    self.payMentMoneyLabel.font = [UIFont systemFontOfSize:13.];
    self.payMentMoneyLabel.textColor = [UIColor settingBackgroundColor];
    [self.bottomView addSubview:self.payMentMoneyLabel];
    
    [self.payMentMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(20));
        make.centerX.equalTo(weakSelf.bottomView.mas_centerX);
        make.top.equalTo(weakSelf.bottomView).offset(10);
//        make.height.mas_equalTo(@(20));
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.bottomView).offset(40);
        make.width.mas_equalTo(@(SCREENWIDTH - 30));
        make.height.mas_equalTo(@(40));
        make.bottom.equalTo(weakSelf.bottomView).offset(-10);
        make.centerX.equalTo(weakSelf.bottomView.mas_centerX);
        
    }];
    
    
}

#pragma mark ======== 列表代理方法 ========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentCartDataSource.count;
    }else if (section == 1) {
        return self.historyCartDataSource.count;
    }else {
        return 0;
    }
}
// ============================== //
//         cell 的删除操作
// ============================== //
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.deleteModel = [self.currentCartDataSource objectAtIndex:indexPath.row];
        _currentRowIndex = indexPath.row;
        [self deleteClicked];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JMCartCurrentCell *cell = [tableView dequeueReusableCellWithIdentifier:JMCartCurrentCellIdentifier];
        if (!cell) {
            cell = [[JMCartCurrentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMCartCurrentCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.cartModel = self.currentCartDataSource[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        JMCartHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:JMCartHistoryCellIdentifier];
        if (!cell) {
            cell = [[JMCartHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMCartHistoryCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.cartModel = self.historyCartDataSource[indexPath.row];
        return cell;
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.currentCartDataSource.count == 0) {
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(0));
            }];
            [self.sureButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(0));
            }];
            [self.payMentMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(0));
            }];
            return 260;
            
        } else {
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(90));
            }];
            [self.sureButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(40));
            }];
            [self.payMentMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(20));
            }];
            return kSectionHeaderAndFooterHeight;
        }
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return kSectionHeaderAndFooterHeight;
    }
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if (self.currentCartDataSource.count == 0 && currentCartDownLoad) {
            kWeakSelf
            JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 260) Title:@"你的购物车空空如也~快去装满它吧" DescTitle:@"快去挑选几件喜欢的宝贝吧~" BackImage:@"gouwucheemptyimage" InfoStr:@"随便逛逛"];
            empty.block = ^(NSInteger index) {
                if (index == 100) {
                    if (self.isHideNavigationLeftItem) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kuaiquguangguangButtonClick" object:nil];
                    }else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            };
            return empty;
        } else {
            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kSectionHeaderAndFooterHeight)];
            footView.backgroundColor = [UIColor countLabelColor];
            UILabel *allPicLabel = [UILabel new];
            [footView addSubview:allPicLabel];
            allPicLabel.textColor = [UIColor settingBackgroundColor];
            allPicLabel.font = [UIFont systemFontOfSize:13.];
            allPicLabel.hidden = self.currentCartDataSource.count == 0 ? YES : NO;
            NSString *allPriceString = [NSString stringWithFormat:@"¥%.2f", allPrice];
            NSString *allString = [NSString stringWithFormat:@"总金额%@",allPriceString];
            allPicLabel.attributedText = [JMRichTextTool cs_changeFontAndColorWithSubFont:[UIFont systemFontOfSize:16.] SubColor:[UIColor buttonEnabledBackgroundColor] AllString:allString SubStringArray:@[allPriceString]];
            [allPicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(footView.mas_centerY);
                make.left.equalTo(footView).offset(15);
            }];
            return footView;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        if (self.historyCartDataSource.count != 0 && historyCartDownLoad) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, kSectionHeaderAndFooterHeight)];
            headerView.backgroundColor = [UIColor countLabelColor];
            UILabel *canAgainBuy = [UILabel new];
            [headerView addSubview:canAgainBuy];
            canAgainBuy.textColor = [UIColor settingBackgroundColor];
            canAgainBuy.font = [UIFont systemFontOfSize:13.];
            canAgainBuy.text = @"可重新购买的商品";
            [canAgainBuy mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView.mas_centerY);
                make.left.equalTo(headerView).offset(15);
            }];
            if (self.historyCartDataSource.count == 0) {
                canAgainBuy.hidden = YES;
            } else{
                canAgainBuy.hidden = NO;
            }
            return headerView;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}
/**
 *  减少一件商品
 */
- (void)jianNumber:(CartListModel *)cartModel{
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/minus_product_carts", Root_URL,cartModel.cartID];
    NSLog(@"url = %@", urlString);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [self downloadCurrentCartData];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败,请稍后重试~!"];
    } Progress:^(float progress) {
        
    }];
}
/**
 *  添加一件商品
 */
- (void)addNumber:(CartListModel *)cartModel{
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/plus_product_carts", Root_URL,cartModel.cartID];
    NSLog(@"url = %@", urlString);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [self downloadCurrentCartData];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败,请稍后重试~!"];
    } Progress:^(float progress) {
        
    }];
}
- (void)deleteCart:(CartListModel *)cartModel{
    self.deleteModel = cartModel;
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self deleteClicked];
    }
}
/**
 *  删除购物车操作
 */
- (void)deleteClicked{
    [MBProgressHUD showLoading:@""];
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v2/carts/%ld/delete_carts", Root_URL,self.deleteModel.cartID];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code == 0) {
            [self downloadCurrentCartData];
            [self downloadHistoryCartData];
            [self.currentCartDataSource removeObjectAtIndex:_currentRowIndex];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentRowIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败,请稍后重试~!"];
    } Progress:^(float progress) {
        
    }];
    
}
/**
 *  购买按钮
 */
- (void)purchaseClicked:(JMSelecterButton *)button {
    [MobClick event:@"purchase"];
    JMPurchaseController *purchaseVC = [[JMPurchaseController alloc] init];
    purchaseVC.purchaseGoods = self.currentCartDataSource;
    [self.navigationController pushViewController:purchaseVC animated:YES];
}
#pragma mark ---- 重新购买按钮点击
- (void)addCart:(CartListModel *)model {
    [MBProgressHUD showLoading:@""];
    [MobClick event:@"buy_again_click"];
    NSDictionary *parameters = @{@"item_id": model.item_id,
                                 @"sku_id":model.sku_id,
                                 @"cart_id":[NSString stringWithFormat:@"%ld",model.cartID],
                                 @"type":@"5"
                                 };
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:kCart_URL WithParaments:parameters WithSuccess:^(id responseObject) {
        NSInteger codeNum = [responseObject[@"code"] integerValue];
        if (codeNum == 0) {
            [MobClick event:@"cart_buy_again_success"];
            [self downloadCurrentCartData];
            [self downloadHistoryCartData];
            if (self.currentCartDataSource.count >= 18) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:0 inSection:0];
                [self.tableView scrollToRowAtIndexPath:(indexpath) atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
            }
        }else {
            NSDictionary *buy_again = @{@"code" : [NSString stringWithFormat:@"%ld",codeNum]};
            [MobClick event:@"cart_buy_again_fail" attributes:buy_again];
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"加入购物车失败，请检查网络或者注销后重新登录。"];
    } Progress:^(float progress) {
        
    }];
}
#pragma mark == 点击进入商品详情
- (void)tapActionHistory:(CartListModel *)model {
    [self pushGoodsDetailWithCartListModel:model];
}
- (void)tapActionNumber:(CartListModel *)model {
    [self pushGoodsDetailWithCartListModel:model];
}
- (void)pushGoodsDetailWithCartListModel:(CartListModel *)model {
    JMGoodsDetailController *detailVC = [[JMGoodsDetailController alloc] init];
    detailVC.goodsID = model.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}







@end




































































































