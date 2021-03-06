//
//  JMChooseLogisticsController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/1.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChooseLogisticsController.h"
#import "JMGroupLogistics.h"
#import "JMLogistics.h"

@interface JMChooseLogisticsController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray * groups;  // 保存所有的数据
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *textF;

@end

@implementation JMChooseLogisticsController

- (NSMutableArray *)groups {
    if (!_groups) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Logistics.plist" ofType:nil];
        NSArray * arrayDicts = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *arrayModels = [NSMutableArray array];
        
        for(NSDictionary *dict  in arrayDicts)
        {
            // 新建model对象
            JMGroupLogistics *group = [JMGroupLogistics groupLogisticsWithDict:dict];
            [arrayModels addObject:group];
        }
        _groups = arrayModels;
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBarWithTitle:@"选择物流" selecotr:@selector(btnClicked:)];

    [self createTableView];
    [self createRightButonItem];
}


- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
}
////取消状态栏
//- (BOOL) prefersStatusBarHidden {
//    return YES;
//}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JMGroupLogistics * group = self.groups[section];
    return group.logistics.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMGroupLogistics *group = self.groups[indexPath.section];
    JMLogistics *car = group.logistics[indexPath.row];
    
    
    static NSString *ID = @"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 设置单元格内容
    cell.textLabel.text = car.name;
    
    return cell;
}
// 添加数据源协议中的方法，实现添加表头
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    JMGroupLogistics *group = self.groups[section];
    return  group.title;
}

// 利用代理中的方法添加右侧索引标题栏
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //    NSMutableArray *arrayIndex = [NSMutableArray array];
    //    for(CZGroup *group in self.groups)
    //    {
    //        [arrayIndex addObject:group.title];
    //    }
    //    return arrayIndex;
    //
    return [self.groups valueForKeyPath:@"title"];
}

#pragma mark ---- 导航栏右侧体现历史
- (void) createRightButonItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [rightBtn addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"填写物流公司" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightClicked:(UIButton *)button{
   
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入一个物流公司" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textF = [alert textFieldAtIndex:0];
    self.textF = textF;
    self.textF.placeholder = @"请输入物流公司";
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            //取消
            
        }else {
            NSString *str = self.textF.text;
            if (_delegate && [_delegate respondsToSelector:@selector(ClickChoiseLogis:Title:)]) {
                [_delegate ClickChoiseLogis:self Title:str];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    }
    
}
// 点击了哪一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMGroupLogistics *group = self.groups[indexPath.section];
    JMLogistics *car = group.logistics[indexPath.row];
    
    NSLog(@"%@",car.name);
    if (_delegate && [_delegate respondsToSelector:@selector(ClickChoiseLogis:Title:)]) {
        [_delegate ClickChoiseLogis:self Title:car.name];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)btnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"JMChooseLogisticsController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"JMChooseLogisticsController"];
}


@end














































































