//
//  HuojiangListViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "HuojiangListViewController.h"
#import "UIViewController+NavigationBar.h"


@interface HuojiangListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation HuojiangListViewController{
    NSTimer *theTimer;
    BOOL _isFirst;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    _isFirst = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"获奖名单" selecotr:@selector(backClicked:)];
    [self.view addSubview:self.tableView];
    _isFirst = YES;
    theTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollTabelView) userInfo:nil repeats:YES];
    self.tableView.scrollEnabled = NO;
}

- (void)scrollTabelView{
    static CGFloat count = 0;
  
//    CGPoint point = self.tableView.contentOffset;
//    count = point.y;
    count += 3;
    if (count > self.tableView.contentSize.height - 400) {
        count = 0;
         [self.tableView setContentOffset:CGPointMake(0, count) animated:NO];
    }
    if (_isFirst) {
        [self.tableView setContentOffset:CGPointMake(0, count) animated:NO];
        _isFirst = NO;
    } else {
        [self.tableView setContentOffset:CGPointMake(0, count) animated:YES];

    }
    
   // NSLog(@"count = %f", count);
}



- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark --UITableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 24;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"13%d****%d%d%d%d", arc4random()%10, arc4random()%10, arc4random()%10, arc4random()%10, arc4random()%10];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:@"head_icon.png"];
    cell.imageView.frame = CGRectMake(0, 0, 16, 16);
    if (indexPath.row == 20) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    
    return cell;
}

@end
