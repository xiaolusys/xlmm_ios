//
//  JMChoiseLogisController.m
//  XLMM
//
//  Created by 崔人帅 on 16/6/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMChoiseLogisController.h"
#import "JMSelecterButton.h"
#import "JMPopLogistcsCell.h"

@interface JMChoiseLogisController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) JMSelecterButton *canelButton;

@property (nonatomic,strong) UITableView *tableView;



@end

@implementation JMChoiseLogisController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}
- (void)setCount:(NSInteger)count {
    _count = count;
}
- (void)createUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH - 20, _count * 60) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    
    JMSelecterButton *cancelButton = [[JMSelecterButton alloc] init];
    self.canelButton = cancelButton;
    [self.canelButton setSelecterBorderColor:[UIColor buttonEnabledBackgroundColor] TitleColor:[UIColor whiteColor] Title:@"取消" TitleFont:13. CornerRadius:15];
    self.canelButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [self.canelButton addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.canelButton.frame = CGRectMake(10, _count * 60 + 10, SCREENWIDTH - 20, 40);
    [self.view addSubview:self.canelButton];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    JMPopLogistcsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[JMPopLogistcsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    JMPopLogistcsModel *model = self.dataSource[indexPath.row];
    [cell configWithModel:model Index:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中cell时无色
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMPopLogistcsModel *model = self.dataSource[indexPath.row];

    if (_delegate && [_delegate respondsToSelector:@selector(ClickLogistics:Model:)]) {
        [_delegate ClickLogistics:self Model:model];
    }
    
    [self cancelBtnClick];
}
- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
}
- (void)cancelBtnClick {
    
    [JMShareView hide];
    
    [JMPopView hide];
    
    
}
@end






































