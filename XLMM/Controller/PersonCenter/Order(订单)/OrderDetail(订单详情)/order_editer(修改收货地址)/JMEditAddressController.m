//
//  JMEditAddressController.m
//  XLMM
//
//  Created by zhang on 16/5/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMEditAddressController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "JMEditAddressModel.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UIView+RGSize.h"
#import "JMSelecterButton.h"
#import "AFNetworking.h"

@interface JMEditAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) JMSelecterButton *sureButton;
@property (nonatomic,strong) JMSelecterButton *cancelButton;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UITextField *conSigneeTF;

@property (nonatomic,strong) UITextField *phoneNumTF;

@property (nonatomic,strong) UITextField *detailAddressTF;
/**
 *  显示修改后省市区信息
 */
@property (nonatomic,strong) UIImageView *addressImageView;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UILabel *proLabel;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UIView *maskView;

@property (nonatomic,strong) UIButton *editAddressBtn;

@property (nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong) UIPickerView *chooseAddressPick;

@property (nonatomic,strong) NSMutableDictionary *addressDic;
@end

@implementation JMEditAddressController {
    NSDictionary *_pickerDic;
    NSArray *_provinceArray;
    NSArray *_cityArray;
    NSArray *_townArray;
    NSArray *_selectedArray;
    NSString *nameStr;
    NSString *phoneStr;
    NSString *addStr;
    NSString *proStr;
    NSString *cityStr;
    NSString *disStr;
    
    NSString *referal_trade_id;
    NSString *logistic_company_code;
    
}
- (NSMutableDictionary *)addressDic {
    if (!_addressDic) {
        _addressDic = [NSMutableDictionary dictionary];
    }
    return _addressDic;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:@[@"收货人",@"手机号"]];
        [_dataSource addObject:@[@"所在地区",@"详细地址"]];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavigationBarWithTitle:@"修改地址" selecotr:@selector(btnClicked:)];
    [self getPickViewData];
    [self createTableView];
    [self createUITextField];
    [self createPickView];
    [self initView];
    
    referal_trade_id = _editDict[@"user_adress"][@"id"];
    logistic_company_code = _editDict[@"logistic_company_code"];
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 240) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
}
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:self.view.frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    //    [self.view addSubview:self.maskView];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView)]];
    
    self.bottomView.width = SCREENWIDTH;
    
    UIButton *sureButton = [[UIButton alloc] init];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(SCREENWIDTH - 30);
        make.height.mas_equalTo(@40);
    }];
    
}
#pragma mark ---- 确认修改信息按钮点击
- (void)sureButtonClick:(UIButton *)sender {
    NSDictionary *dic = [[NSDictionary alloc] init];
    JMEditAddressModel *model = [JMEditAddressModel new];
        model.receiver_state = proStr ? proStr : _addressDic[@"receiver_state"];
        model.receiver_city = cityStr ? cityStr : _addressDic[@"receiver_city"];
        model.receiver_district = disStr ? disStr : _addressDic[@"receiver_district"];
        model.receiver_name = nameStr ? nameStr : _addressDic[@"receiver_name"];
        model.receiver_mobile = phoneStr ? phoneStr : _addressDic[@"receiver_mobile"];
        model.receiver_address = addStr ? addStr : _addressDic[@"receiver_address"];
        dic = model.mj_keyValues;
    NSString *urlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/update",Root_URL,referal_trade_id];
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict setObject:referal_trade_id forKey:@"id"];  // === > 地址信息ID
    if (_editDict[@"logistic_company"] == nil) {
        [dict setObject:[NSNull null] forKey:@"logistic_company_code"];
    }else {
        [dict setObject:_editDict[@"logistic_company"] forKey:@"logistic_company_code"];
    }
    [dict setObject:_editDict[@"id"] forKey:@"referal_trade_id"]; // == > 订单ID
    
    [manage POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (!responseObject) return;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateEditerWithmodel:)]) {
        
            [self.delegate updateEditerWithmodel:dic];
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

#pragma mark ----  获取pickView的数据
- (void)getPickViewData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    _pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    _provinceArray = [_pickerDic allKeys];
    _selectedArray = [_pickerDic objectForKey:[[_pickerDic allKeys] objectAtIndex:0]];
    
    if (_selectedArray.count > 0) {
        _cityArray = [[_selectedArray objectAtIndex:0] allKeys];
    }
    if (_cityArray.count > 0) {
        _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
    }
    
}

#pragma mark --- 实现 UITableViewDelegate 与 UITableViewDataSource 协议方法

/**
 *  组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

/**
 *  行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataSource[section] count];
}
/**
 *  行高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

/**
 *  cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSString *name = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14.];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
/**
 *  组头
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

#pragma mark ---- 创建文本框
- (void)createUITextField {
    
    _addressDic = _editDict[@"user_adress"];
    JMEditAddressModel *editModel = [JMEditAddressModel mj_objectWithKeyValues:_addressDic];
    
    UITextField *conSigneeTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 35, SCREENWIDTH - 100, 20)];
    self.conSigneeTF = conSigneeTF;
    [self.view addSubview:self.conSigneeTF];
    self.conSigneeTF.tag = 100;
    self.conSigneeTF.delegate = self;
    self.conSigneeTF.keyboardType = UIKeyboardTypeDefault;
    self.conSigneeTF.leftViewMode = UITextFieldViewModeAlways;
    self.conSigneeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.conSigneeTF.font = [UIFont systemFontOfSize:13.];
    self.conSigneeTF.text = editModel.receiver_name;
    [self.conSigneeTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 85, SCREENWIDTH - 100, 20)];
    self.phoneNumTF = phoneNumTF;
    [self.view addSubview:self.phoneNumTF];
    self.phoneNumTF.tag = 101;
    self.phoneNumTF.delegate = self;
    self.phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTF.font = [UIFont systemFontOfSize:13.];
    self.phoneNumTF.text = editModel.receiver_mobile;
    [self.phoneNumTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 205, SCREENWIDTH - 100, 20)];
    self.detailAddressTF = detailAddressTF;
    [self.view addSubview:self.detailAddressTF];
    self.detailAddressTF.tag = 102;
    self.detailAddressTF.delegate = self;
    self.detailAddressTF.keyboardType = UIKeyboardTypeDefault;
    self.detailAddressTF.leftViewMode = UITextFieldViewModeAlways;
    self.detailAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailAddressTF.font = [UIFont systemFontOfSize:13.];
    self.detailAddressTF.text = editModel.receiver_address;
    [self.detailAddressTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *addressImageView = [[UIImageView alloc] init];
    addressImageView.frame = CGRectMake(90, 155, SCREENWIDTH - 100, 20);
    [self.view addSubview:addressImageView];
    self.addressImageView = addressImageView;
    self.addressImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageViewClick:)];
    [self.addressImageView addGestureRecognizer:tap];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    self.addressLabel = addressLabel;
    [self.addressImageView addSubview:addressLabel];
    self.addressLabel.text = editModel.receiver_district;
    self.addressLabel.font = [UIFont systemFontOfSize:13.];
    
    UILabel *proLabel = [[UILabel alloc] init];
    self.proLabel = proLabel;
    [self.addressImageView addSubview:proLabel];
    self.proLabel.text = editModel.receiver_state;
    self.proLabel.font = [UIFont systemFontOfSize:13.];
    
    UILabel *cityLabel = [[UILabel alloc] init];
    self.cityLabel = cityLabel;
    [self.addressImageView addSubview:cityLabel];
    self.cityLabel.text = editModel.receiver_city;
    self.cityLabel.font = [UIFont systemFontOfSize:13.];
    kWeakSelf
    [self.proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.addressImageView);
        make.centerY.equalTo(weakSelf.addressImageView.mas_centerY);
    }];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.proLabel.mas_right);
        make.centerY.equalTo(weakSelf.addressImageView.mas_centerY);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.cityLabel.mas_right);
        make.centerY.equalTo(weakSelf.addressImageView.mas_centerY);
    }];
    
    
}
- (void)textFieldEditChanged:(UITextField *)textField {
    if (textField.tag == 100) {
        nameStr = textField.text;
    }else if (textField.tag == 101) {
        phoneStr = textField.text;
    }else {
        addStr = textField.text;
    }
    
}
#pragma mark ----- 点击选择地址的图片手势
- (void)ImageViewClick:(UITapGestureRecognizer *)tap {
    [self.conSigneeTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.bottomView];
    self.maskView.alpha = 0;
    self.bottomView.top = self.view.height - 150;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.1;
        self.bottomView.bottom = self.view.height;
    }];
}
/**
 *  隐藏
 */
- (void)hidePickerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.bottomView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.bottomView removeFromSuperview];
    }];
}

#pragma mark ----  实现 UITextField 的协议方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
        case 100:
            nameStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            break;
        case 101:
            phoneStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            break;
        case 102:
            addStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.conSigneeTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
    [self.detailAddressTF resignFirstResponder];
}
- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- 创建pickView
- (void)createPickView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 150, SCREENWIDTH, 150)];
    self.bottomView = bottomView;
    //    [self.view addSubview:self.bottomView];
    
    UIPickerView *chooseAddressPick = [[UIPickerView alloc] init];
    self.chooseAddressPick = chooseAddressPick;
    [self.bottomView addSubview:self.chooseAddressPick];
    self.chooseAddressPick.delegate = self;
    self.chooseAddressPick.dataSource = self;
//    self.chooseAddressPick.showsSelectionIndicator = YES;
//    self.chooseAddressPick.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.sureButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.sureButton];
    [self.sureButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"确定" TitleFont:13. CornerRadius:10.];
    [self.sureButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [JMSelecterButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.cancelButton];
    [self.cancelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor buttonEnabledBackgroundColor] Title:@"取消" TitleFont:13. CornerRadius:10.];
    [self.cancelButton addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView);
        make.width.mas_equalTo(@80);
        make.height.mas_equalTo(@30);
    }];
    
    [self.chooseAddressPick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureButton.mas_bottom);
        make.left.equalTo(self.bottomView);
        make.width.mas_equalTo(SCREENWIDTH);
        make.height.mas_equalTo(@120);
    }];
    
}
#pragma mark ---- 确定按钮与取消按钮的点击
- (void)sureBtnClick:(UIButton *)sender {
    
    proStr = [_provinceArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:0]];
    cityStr = [_cityArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:1]];
    disStr = [_townArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:2]];
    
    self.proLabel.text = [_provinceArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:0]];
    self.cityLabel.text = [_cityArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:1]];
    self.addressLabel.text = [_townArray objectAtIndex:[self.chooseAddressPick selectedRowInComponent:2]];
    [self hidePickerView];
}
- (void)cancelBtnClick:(UIButton *)sender {
    [self hidePickerView];
}

#pragma mark ----- UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _provinceArray.count;
    }else if (component == 1) {
        return _cityArray.count;
    }else {
        return _townArray.count;
    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [_provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [_cityArray objectAtIndex:row];
    } else {
        return [_townArray objectAtIndex:row];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return SCREENWIDTH / 3;
    } else if (component == 1) {
        return SCREENWIDTH / 3;
    } else {
        return SCREENWIDTH / 3;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    self.proLabel.text = nil;
//    self.cityLabel.text = nil;
//    self.addressLabel.text = nil;
    
    if (component == 0) {
        proStr = _provinceArray[row];
        _selectedArray = [_pickerDic objectForKey:[_provinceArray objectAtIndex:row]];
        if (_selectedArray.count > 0) {
            _cityArray = [[_selectedArray objectAtIndex:0] allKeys];
            cityStr = _cityArray[0];
        } else {
            _cityArray = nil;
        }
        if (_cityArray.count > 0) {
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
            disStr = _townArray[0];
        } else {
            _townArray = nil;
        }
        [pickerView selectedRowInComponent:1];
        [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
//        self.proLabel.text = proStr;
//        self.cityLabel.text = cityStr;
//        self.addressLabel.text = disStr;
    }
    
    
    else if (component == 1) {
        disStr = nil;
//        self.proLabel.text = proStr;
        if (_selectedArray.count > 0 && _cityArray.count > 0) {
            cityStr = _cityArray[row];
//            self.cityLabel.text = cityStr;
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:row]];
            disStr = _townArray[0];
        } else {
            _townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
//        self.addressLabel.text = disStr;
    }else {
//        self.proLabel.text = proStr;
//        self.cityLabel.text = cityStr;
        disStr = _townArray[row];
        [pickerView reloadComponent:2];
        
//        self.addressLabel.text = disStr;
        
    }
    
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        
//        pickerLabel.font = [UIFont systemFontOfSize:14.];
//        
//    }
//
//    return pickerLabel;
//    
//    
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"EditAddress"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"EditAddress"];
}

@end














































