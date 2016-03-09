//
//  MaMaHuoyueduViewController.m
//  XLMM
//
//  Created by younishijie on 16/3/9.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "MaMaHuoyueduViewController.h"
#import "MMClass.h"
#import "UIViewController+NavigationBar.h"
#import "HuoyuezhiTableViewCell.h"




@interface MaMaHuoyueduViewController ()

@property (nonatomic, copy) NSArray *dataArray;


@end

@implementation MaMaHuoyueduViewController

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
    
    [self createNavigationBarWithTitle:@"活跃值" selecotr:@selector(backClicked:)];
    
    
    //  http://192.168.1.13:8000/rest/v2/mama/activevalue
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/mama/activevalue", Root_URL];
    MMLOG(string);
    
    [self downLoadWithURLString:string andSelector:@selector(fetchListData:)];
    
    [self.tableView registerClass:[HuoyuezhiTableViewCell class] forCellReuseIdentifier:@"HuoyueZhiCell"];
    
    
    
}

- (void)fetchListData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    
    self.dataArray = [dic objectForKey:@"activevalue_list"];
    NSLog(@"self.dataArray = %@", self.dataArray);
    
    
    
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HuoyuezhiTableViewCell" owner:nil options:nil];
    HuoyuezhiTableViewCell *cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
