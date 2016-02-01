//
//  FensiListViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "FensiListViewController.h"
#import "UIViewController+NavigationBar.h"
#import "FensiTableViewCell.h"
#import "MMClass.h"
#import "FanceModel.h"


@interface FensiListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation FensiListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"粉丝列表" selecotr:@selector(backClicked:)];
    [self.view addSubview:self.tableView];
    
    [self downloadData];
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/fanlist", Root_URL];
    NSLog(@"string = %@", string);
    [self downLoadWithURLString:string andSelector:@selector(fetchedData:)];
    
}

- (void)fetchedData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error == nil) {
        if (array.count == 0) {
            NSLog(@"您的粉丝列表为空");
        } else {
            //生成粉丝列表。。。
            [self createFanlistWithArray:array];
        }
    } else {
        NSLog(@"error = %@", error);
    }
    
}

- (void)createFanlistWithArray:(NSArray *)array{
    for (NSDictionary *dic in array) {
        FanceModel *fan = [[FanceModel alloc] initWithInfo:dic];
        [self.dataArray addObject:fan];
    }
    NSLog(@"dataArray = %@", self.dataArray);
    [self.tableView reloadData];
}



- (void)backClicked:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentify = @"CellIdentify";
    
    FensiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FensiTableViewCell" owner:self options:nil] lastObject];
    }
    FanceModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell fillData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    return cell;
}









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
