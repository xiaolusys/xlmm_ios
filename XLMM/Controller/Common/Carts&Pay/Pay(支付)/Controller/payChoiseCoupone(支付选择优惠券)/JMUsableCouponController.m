//
//  JMUsableCouponController.m
//  XLMM
//
//  Created by zhang on 16/7/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMUsableCouponController.h"
#import "JMCouponRootCell.h"
#import "JMCouponModel.h"
#import "JMSelecterButton.h"
#import "CSTableViewPlaceHolderDelegate.h"
#import "JMReloadEmptyDataView.h"

@interface JMUsableCouponController ()<UITableViewDelegate,UITableViewDataSource,CSTableViewPlaceHolderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JMSelecterButton *disableButton;
@property (nonatomic, strong) JMReloadEmptyDataView *reload;


@end

@implementation JMUsableCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    if (dataSource.count == 0) {
//        [self emptyView];
    }else {
        
    }
    [self.tableView cs_reloadData];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 164) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 110;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    bottomView.frame = CGRectMake(0, SCREENHEIGHT - 164, SCREENWIDTH, 60);
    bottomView.backgroundColor = [UIColor sectionViewColor];
    
    self.disableButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    self.disableButton.frame = CGRectMake(15, 10, SCREENWIDTH - 30, 40);
    [bottomView addSubview:self.disableButton];
    [self.disableButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"不使用优惠券" TitleFont:14. CornerRadius:20.];
    self.disableButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.disableButton addTarget:self action:@selector(disableButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"JMUsableCouponController";
    JMCouponRootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMCouponRootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    JMCouponModel *couponModel = [[JMCouponModel alloc] init];
    couponModel = self.dataSource[indexPath.row];
    [cell configUsableData:couponModel IsSelectedYHQ:self.isSelectedYHQ SelectedID:self.selectedModelID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMCouponModel *couponModel = [[JMCouponModel alloc] init];
    couponModel = self.dataSource[indexPath.row];
    NSMutableArray *couponArray = [NSMutableArray array];
    if (self.couponNumber >= 1 && [self.directBuyGoodsTypeNumber isEqualToNumber:@5]) {
        NSInteger count = self.dataSource.count > self.couponNumber ? self.couponNumber : self.dataSource.count;
        for (int i = 0; i < count; i++) {
            [couponArray addObject:self.dataSource[i]];
        }
    }else {
        [couponArray addObject:couponModel];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanmodel:)]) {
        [self.delegate updateYouhuiquanmodel:couponArray];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)disableButtonClick:(UIButton *)button {
    button.enabled = NO;
    [self performSelector:@selector(changeButtonStatus:) withObject:button afterDelay:0.5f];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanmodel:)]) {
        [self.delegate updateYouhuiquanmodel:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)changeButtonStatus:(UIButton *)button {
    button.enabled = YES;
}
//- (void)emptyView {
//    kWeakSelf
//    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 80, SCREENWIDTH, SCREENHEIGHT - 240) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" BackImage:@"emptyYouhuiquanIcon" InfoStr:@"快去逛逛"];
//    [self.view addSubview:empty];
//    empty.block = ^(NSInteger index) {
//        if (index == 100) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    };
//}
- (UIView *)createPlaceHolderView {
    return self.reload;
}
- (JMReloadEmptyDataView *)reload {
    if (!_reload) {
        __block JMReloadEmptyDataView *reload = [[JMReloadEmptyDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) Title:@"您暂时还没有优惠券哦～" DescTitle:@"" ButtonTitle:@"快去逛逛" Image:@"emptyYouhuiquanIcon" ReloadBlcok:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        _reload = reload;
    }
    return _reload;
}


- (void)gotoLeadingView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end











































































































