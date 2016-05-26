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


@interface JMEditAddressController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UITextField *conSigneeTF;

@property (nonatomic,strong) UITextField *phoneNumTF;

@property (nonatomic,strong) UITextField *detailAddressTF;

@property (nonatomic,strong) UIButton *editAddressBtn;

@end

@implementation JMEditAddressController

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
    [self createNavigationBarWithTitle:@"修改地址" selecotr:@selector(btnClicked:)];
    [self createTableView];
    
    [self createUITextField];
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 280 + 64) style:UITableViewStylePlain];
   
    
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
    
    return 60;
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
    UITextField *conSigneeTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    self.conSigneeTF = conSigneeTF;
    [self.view addSubview:self.conSigneeTF];
    self.conSigneeTF.tag = 100;
    self.conSigneeTF.delegate = self;
    self.conSigneeTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.conSigneeTF.leftViewMode = UITextFieldViewModeAlways;
    self.conSigneeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.conSigneeTF.font = [UIFont systemFontOfSize:13.];
    self.conSigneeTF.placeholder = @"请输入收货人姓名";
    
    UITextField *phoneNumTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 160, 200, 30)];
    self.phoneNumTF = phoneNumTF;
    [self.view addSubview:self.phoneNumTF];
    self.phoneNumTF.tag = 101;
    self.phoneNumTF.delegate = self;
    self.phoneNumTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.phoneNumTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumTF.font = [UIFont systemFontOfSize:13.];
    self.phoneNumTF.placeholder = @"请输入手机号";
    
    UITextField *detailAddressTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 200, 30)];
    self.detailAddressTF = detailAddressTF;
    [self.view addSubview:self.detailAddressTF];
    self.detailAddressTF.tag = 102;
    self.detailAddressTF.delegate = self;
    self.detailAddressTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.detailAddressTF.leftViewMode = UITextFieldViewModeAlways;
    self.detailAddressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailAddressTF.font = [UIFont systemFontOfSize:13.];
    self.detailAddressTF.placeholder = @"请输入详细地址";
    
    
    
}

#pragma mark ----  实现 UITextField 的协议方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    switch (textField.tag) {
        case 100:
            NSLog(@"111111111111111111");
            
            break;
            
            case 101:
            NSLog(@"222222222222222222");
            
            break;
            
            case 102:
            NSLog(@"333333333333333333");
            
            break;
            
        default:
            break;
    }
    
    
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"当前方法 名字 %s，开始编辑",__func__);
    //如果返回YES，可以编辑。如果返回NO，就不能编辑
    
    //发送通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"keybordstartedit" object:@"object2"];
    
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"已经开始编辑");
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSLog(@" %s",__func__);
    //返回yes 的话，就允许结束编辑
    //返回no的话，就是不允许编辑
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"已经结束编辑");
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    NSLog(@"删除了11111111");
    //是否允许删除
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //是否允许 return
    NSLog(@"点击return了");
    //在这里做
    return YES;
}
- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
@end





























