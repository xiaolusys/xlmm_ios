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
#import "JMProvince.h"
#import "JMEditAddressModel.h"
#import "MJExtension.h"
#import "UIColor+RGBColor.h"
#import "Masonry.h"

@interface JMEditAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UITextField *conSigneeTF;

@property (nonatomic,strong) UITextField *phoneNumTF;

@property (nonatomic,strong) UITextField *detailAddressTF;

@property (nonatomic,strong) UIButton *editAddressBtn;

@property (nonatomic,strong) UIPickerView *chooseAddressPick;

@property (nonatomic,strong) NSMutableArray *dataSourcePick;

@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UILabel *proLabel;

@property (nonatomic,strong) UILabel *cityLabel;

@property (nonatomic,strong) UIImageView *addressImageView;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) JMEditAddressModel *editModel;

@end

@implementation JMEditAddressController {
    NSString *selectedProvince;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    NSArray *selectedArray; //储存对应省份的城市
    NSString *proStr;
    NSString *cityStr;
    NSString *disStr;
    NSString *nameStr;
    NSString *phoneStr;
    NSString *addStr;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:@[@"收货人",@"手机号"]];
        [_dataSource addObject:@[@"所在地区",@"详细地址"]];
    }
    return _dataSource;
}
- (JMEditAddressModel *)editModel {
    if (_editModel == nil) {
        _editModel = [JMEditAddressModel new];
    }
    return _editModel;
}
- (NSMutableArray *)dataSourcePick {
    if (_dataSourcePick == nil) {
        _dataSourcePick = [JMProvince provinceList];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area.plist" ofType:nil];
        areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        province = self.dataSourcePick[0];
        city = self.dataSourcePick[1];
        district = self.dataSourcePick[2];
        
        selectedProvince = [province objectAtIndex:0];
    }
    return _dataSourcePick;
}
- (void)setEditDict:(NSMutableDictionary *)editDict {
    
    _editDict = editDict;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"修改地址" selecotr:@selector(btnClicked:)];
    [self createPickView];
//    [self loadDataSourceEdite];
    [self createTableView];
    [self createUITextField];
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64 - 120) style:UITableViewStylePlain];
   
    
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
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
    cell.textLabel.font = [UIFont systemFontOfSize:14.];
    cell.textLabel.textColor = [UIColor titleDarkGrayColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


#pragma mark ---- 创建文本框
- (void)createUITextField {
    
    JMEditAddressModel *editModel = [JMEditAddressModel mj_objectWithKeyValues:_editDict];

    UITextField *conSigneeTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 35, SCREENWIDTH - 100, 20)];
    self.conSigneeTF = conSigneeTF;
    [self.view addSubview:self.conSigneeTF];
    self.conSigneeTF.tag = 100;
    self.conSigneeTF.delegate = self;
    self.conSigneeTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.conSigneeTF.leftViewMode = UITextFieldViewModeAlways;
    self.conSigneeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.conSigneeTF.font = [UIFont systemFontOfSize:13.];
    self.conSigneeTF.text = editModel.receiver_name;
    
    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 85, SCREENWIDTH - 100, 20)];
    self.phoneNumTF = phoneNumTF;
    [self.view addSubview:self.phoneNumTF];
    self.phoneNumTF.tag = 101;
    self.phoneNumTF.delegate = self;
    self.phoneNumTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTF.font = [UIFont systemFontOfSize:13.];
    self.phoneNumTF.text = editModel.receiver_mobile;
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 205, SCREENWIDTH - 100, 20)];
    self.detailAddressTF = detailAddressTF;
    [self.view addSubview:self.detailAddressTF];
    self.detailAddressTF.tag = 102;
    self.detailAddressTF.delegate = self;
    self.detailAddressTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.detailAddressTF.leftViewMode = UITextFieldViewModeAlways;
    self.detailAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailAddressTF.font = [UIFont systemFontOfSize:13.];
    self.detailAddressTF.text = editModel.receiver_address;
    
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

    UIButton *sureButton = [[UIButton alloc] init];
    sureButton.frame = CGRectMake(15, 320, SCREENWIDTH - 30, 40);
    [sureButton setBackgroundImage:[UIImage imageNamed:@"success_purecolor"] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    self.sureButton = sureButton;
    
    
    
}
#pragma mark ---- 确认修改信息按钮点击
- (void)sureButtonClick:(UIButton *)sender {
    JMEditAddressModel *model = [JMEditAddressModel new];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateEditerWithmodel:)]) {
        model.receiver_state = proStr;
        model.receiver_city = cityStr;
        model.receiver_district = disStr;
        model.receiver_name = nameStr;
        model.receiver_mobile = phoneStr;
        model.receiver_address = addStr;
        
        [self.delegate updateEditerWithmodel:model];
    }
    
    
}
#pragma mark ----  实现 UITextField 的协议方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    switch (textField.tag) {
//        case 100:
//            nameStr = textField.text;
//            break;
//            
//            case 101:
//            phoneStr = textField.text;
//            break;
//            
//            case 102:
//            addStr = textField.text;
//            break;
//            
//        default:
//            break;
//    }

    return YES;
}
#pragma mark -----UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.chooseAddressPick.hidden = YES;
    [textField becomeFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
// 结束编辑时调用
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            nameStr = textField.text;
            break;
            case 101:
            phoneStr = textField.text;
            break;
            case 102:
            addStr = textField.text;
            break;
        default:
            break;
    }
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark ----- 点击选择地址的图片手势
- (void)ImageViewClick:(UITapGestureRecognizer *)tap {
    self.chooseAddressPick.hidden = NO;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.chooseAddressPick.hidden = YES;
}
#pragma mark ---- 创建pickView
- (void)createPickView {
    UIPickerView *chooseAddressPick = [[UIPickerView alloc] init];
    self.chooseAddressPick = chooseAddressPick;
    [self.view addSubview:self.chooseAddressPick];
    self.chooseAddressPick.frame = CGRectMake(0, SCREENHEIGHT - 120, SCREENWIDTH, 120);
    self.chooseAddressPick.delegate = self;
    self.chooseAddressPick.dataSource = self;
    self.chooseAddressPick.hidden = YES;
    
    
    
}
#pragma mark ----- UIPickerViewDataSource代理方法
/**
 *  列
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return self.dataSourcePick.count;
    
}
/**
 *  行
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return province.count;
    }else if (component == 1) {
        return city.count;
    }else {
        return district.count;
    }

}
#pragma mark --- UIPickerViewDelegate代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    if (component == 0) {
        return [province objectAtIndex:row];
    }else if (component == 1) {
        return [city objectAtIndex:row];
    }else {
        return [district objectAtIndex:row];
    }

}
/**
 *  选中
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [self.chooseAddressPick selectRow: 0 inComponent: 1 animated: YES];
        [self.chooseAddressPick selectRow: 0 inComponent: 2 animated: YES];
        [self.chooseAddressPick reloadComponent: 1];
        [self.chooseAddressPick reloadComponent: 2];
        
        proStr = province[row];
        self.proLabel.text = proStr;
        self.cityLabel.text = cityStr;
        self.addressLabel.text = disStr;
    }
    else if (component == 1) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%ld", [province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.chooseAddressPick selectRow: 0 inComponent: 2 animated: YES];
        [self.chooseAddressPick reloadComponent: 2];
        
        cityStr = city[row];
        self.cityLabel.text = cityStr;
        
    }else {
        
        disStr = city[row];
        self.addressLabel.text = disStr;
        
    }
    
    
}

//设置列里边组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = SCREENWIDTH / 3;
    if (component == 0) {
        return width;
    } else if (component == 1) {
        return width;
    } else {
        return width;
    }
    
}
//设置列里边组件的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if (component == 0) {
        return 20;
    } else if (component == 1) {
        return 25;
    } else {
        return 30;
        
    }
    
}

@end

/**
 *  if (component == 0) {
 selectedProvince = [province objectAtIndex:row];
 NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
 NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
 selectedArray = [dic objectForKey:[province objectAtIndex:row]];
 if (selectedArray.count > 0) {
 city = [[selectedArray objectAtIndex:0] allKeys];
 }else {
 city = nil;
 }
 if (city.count > 0) {
 district = [[selectedArray objectAtIndex:0] objectForKey:[city objectAtIndex:0]];
 }else {
 district = nil;
 }
 [self.chooseAddressPick reloadComponent:1];
 
 
 
 }else if (component == 1) {
 
 if (selectedArray.count > 0 && city.count > 0) {
 district = [[selectedArray objectAtIndex:0] objectForKey:[city objectAtIndex:row]];
 }else {
 district = nil;
 }
 [self.chooseAddressPick selectRow:1 inComponent:2 animated:YES];
 }
 
 [self.chooseAddressPick reloadComponent:2];

 */



























