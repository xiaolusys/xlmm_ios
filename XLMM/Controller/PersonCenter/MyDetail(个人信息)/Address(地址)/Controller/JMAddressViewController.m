
//
//  JMAddressViewController.m
//  XLMM
//
//  Created by zhang on 17/2/21.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMAddressViewController.h"
#import "JMAddressModel.h"
#import "JMModifyAddressController.h"
#import "JMEmptyView.h"
#import "JMAddressCell.h"




@interface JMAddressViewController () <UITableViewDelegate, UITableViewDataSource, JMAddressCellDelegate>

@property (nonatomic, strong) JMEmptyView *empty;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMAddressModel *addressModel;
@property (nonatomic, strong) UIButton *addAddressButton;

@end

static NSString *JMAddressCellIdentifier = @"JMAddressCellIdentifier";

@implementation JMAddressViewController

- (JMAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[JMAddressModel alloc] init];
    }
    return _addressModel;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 124) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[JMAddressCell class] forCellReuseIdentifier:JMAddressCellIdentifier];
        _tableView.rowHeight = 90;
    }
    return _tableView;
}
- (UIButton *)addAddressButton {
    if (!_addAddressButton) {
        _addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAddressButton.frame = CGRectMake(15, 10, SCREENWIDTH - 30, 40);
        _addAddressButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
        _addAddressButton.layer.masksToBounds = YES;
        _addAddressButton.layer.cornerRadius = 20.f;
        [_addAddressButton setTitle:@"添加地址" forState:UIControlStateNormal];
        [_addAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addAddressButton.titleLabel.font = [UIFont systemFontOfSize:15.];
        [_addAddressButton addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addAddressButton;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAddressData];
    [MobClick beginLogPageView:@"JMAddressViewController"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMAddressViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBarWithTitle:@"收货地址" selecotr:@selector(backClick)];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView addSubview:self.addAddressButton];
    [self.view addSubview:self.tableView];
    
    
    
    
    
    
    
    

}
#pragma mark 网络请求,数据处理
- (void)loadAddressData {
    [MBProgressHUD showLoading:@""];
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:kAddress_List_URL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject)return ;
        [self.dataSource removeAllObjects];
        [self fatchedAddressData:responseObject];
        [self.tableView reloadData];
        [MBProgressHUD hideHUD];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
    }];
}
- (void)fatchedAddressData:(NSArray *)allArr {
    if (allArr.count == 0) {
        self.empty.hidden = NO;
        return ;
    }
    self.empty.hidden = YES;
    for (NSDictionary *dic in allArr) {
        JMAddressModel *model = [JMAddressModel mj_objectWithKeyValues:dic];
        [self.dataSource addObject:model];
    }
}
- (void)deleteAddress:(JMAddressModel *)model {
    NSString *deleteurlString = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL,model.addressID];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:deleteurlString WithParaments:nil WithSuccess:^(id responseObject) {
        [self loadAddressData];
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}


#pragma mark 代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:JMAddressCellIdentifier];
    if (!cell) {
        cell = [[JMAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JMAddressCellIdentifier];
    }
    JMAddressModel *model = self.dataSource[indexPath.row];
    if ([model.defaultValue boolValue] == 1) {
        cell.defaultLabel.hidden = NO;
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(70);
        }];
    }else {
        cell.defaultLabel.hidden = YES;
        [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
        }];
    }
    cell.nameLabel.text = model.receiver_name;
    cell.phoneLabel.text = model.receiver_mobile;
    cell.descAddressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.receiver_state, model.receiver_city, model.receiver_district, model.receiver_address];
    if (self.isSelected) {
        cell.selectedImageView.hidden = NO;
        cell.modifyButton.hidden = NO;
        cell.rightImageView.hidden = YES;
        [cell.descAddressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(40);
            make.width.mas_equalTo(SCREENWIDTH - 140);
        }];
        if (self.dataSource.count == 1) {
            cell.selectedImageView.image = [UIImage imageNamed:@"mamaNewcomer_selector"];
        }
        if ([self.addressID integerValue] == [model.addressID integerValue]) {
            cell.selectedImageView.image = [UIImage imageNamed:@"mamaNewcomer_selector"];
        }else {
            cell.selectedImageView.image = [UIImage imageNamed:@"mamaNewcomer_normal"];
        }
    }
    cell.addressModel = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMAddressModel *model = self.dataSource[indexPath.row];
    if (self.isSelected) {
        if (_delegate && [_delegate respondsToSelector:@selector(addressView:model:)]) {
            [_delegate addressView:self model:model];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        JMModifyAddressController *addVC = [[JMModifyAddressController alloc] init];
        addVC.isAdd = NO;
        addVC.cartsPayInfoLevel = self.cartsPayInfoLevel;
        addVC.addressLevel = [model.personalinfo_level integerValue];
//        addVC.isBondedGoods = self.isBondedGoods;
        addVC.addressModel = model;
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.addressModel = [self.dataSource objectAtIndex:indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //调用删除接口。。。。。。
        [self deleteAddress:self.addressModel];
        
    }
}
- (void)modifyAddress:(JMAddressModel *)model{
    JMModifyAddressController *addAdVC = [[JMModifyAddressController alloc] init];
    addAdVC.isAdd = NO;
//    addAdVC.isBondedGoods = self.isBondedGoods;
    addAdVC.cartsPayInfoLevel = self.cartsPayInfoLevel;
    addAdVC.addressLevel = [model.personalinfo_level integerValue];
    addAdVC.addressModel = model;
    [self.navigationController pushViewController:addAdVC animated:YES];
}





#pragma mark 空视图
- (void)emptyView {
    //    kWeakSelf
    JMEmptyView *empty = [[JMEmptyView alloc] initWithFrame:CGRectMake(0, 120, SCREENWIDTH, SCREENHEIGHT - 240) Title:@"您还没有添加收货地址哦～" DescTitle:@"" BackImage:@"empty_address_icon" InfoStr:@""];
    [self.view addSubview:empty];
    empty.block = ^(NSInteger index) {
        if (index == 100) {
            UIButton *button = (UIButton *)[self.view viewWithTag:100];
            button.hidden = YES;
        }
    };
    self.empty = empty;
    self.empty.hidden = YES;
}


#pragma mark 处理点击事件
- (void)addAddressClick {
    JMModifyAddressController *addVC = [[JMModifyAddressController alloc] init];
    addVC.isAdd = YES;
//    addVC.isBondedGoods = self.isBondedGoods;
    addVC.cartsPayInfoLevel = self.cartsPayInfoLevel;
    addVC.addressLevel = 0;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}













@end




























































