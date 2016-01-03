//
//  MaMaCenterViewController.m
//  XLMM
//
//  Created by younishijie on 15/12/31.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MaMaCenterViewController.h"
#import "MaMaOrderTableViewCell.h"

@interface MaMaCenterViewController ()

@end

@implementation MaMaCenterViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mamaTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    headView.backgroundColor = [UIColor lightGrayColor];
    
    self.mamaTableView.tableHeaderView = headView;
    
    [self.mamaTableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    
    self.mamaTableView.delegate = self;
    self.mamaTableView.dataSource = self;
    [self.view addSubview:self.mamaTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark --TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else {
        return 80;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MaMaOrder";
    
    
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"折线图";
        
    } else {
//        cell.textLabel.text = @"今日订单";
        
    }
    return cell;
    
    
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
