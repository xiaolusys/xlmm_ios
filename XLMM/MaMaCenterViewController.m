//
//  MaMaCenterViewController.m
//  XLMM
//
//  Created by younishijie on 15/12/31.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "MaMaCenterViewController.h"
#import "MaMaOrderTableViewCell.h"
#import "MaMaChartTableViewCell.h"
#import "MMClass.h"

@interface MaMaCenterViewController ()

@end

@implementation MaMaCenterViewController{
    UIButton *backButton;
    UILabel *jineLabel;
    UILabel *levelLabel;
    UILabel *jiluLabel;
    UILabel *shouyiLabel;
    
}


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
    self.mamaTableView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:244/255.0 alpha:1];
    UIView *headView;
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"MaMaHeadView" owner:nil options:nil];
    headView = views[0];
    headView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 245);
    self.mamaTableView.showsVerticalScrollIndicator = NO;
    backButton = [headView viewWithTag:100];
    levelLabel = [headView viewWithTag:200];
    jineLabel = [headView viewWithTag:300];
    jiluLabel = [headView viewWithTag:400];
    shouyiLabel = [headView viewWithTag:500];
    
    [backButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    levelLabel.text = @"12";
    jineLabel.text = @"300";
    jiluLabel.text = @"400";
    shouyiLabel.text = @"500";
    
    
    
    
    self.mamaTableView.tableHeaderView = headView;
    
    [self.mamaTableView registerNib:[UINib nibWithNibName:@"MaMaOrderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MaMaOrder"];
    [self.mamaTableView registerClass:[MaMaChartTableViewCell class] forCellReuseIdentifier:@"MaMaChart"];
    
    self.mamaTableView.delegate = self;
    self.mamaTableView.dataSource = self;
    [self.view addSubview:self.mamaTableView];
    
    [self downloadData];
    
}

- (void)downloadData{
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/xlmm", Root_URL];
    [self downloadDataWithUrlString:string selector:@selector(fetchedMaMaData:)];
    [self downloadDataWithUrlString:[NSString stringWithFormat:@"%@/rest/v1/xlmm/agency_info", Root_URL] selector:@selector(fetchedInfoData:)];
}
- (void)fetchedInfoData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSLog(@"dicJson = %@", dicJson);
       
    }
    
}

- (void)fetchedMaMaData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSError *error = nil;
    NSArray *arrJson = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        NSLog(@"dicJson = %@", arrJson);
        NSDictionary *dic = [arrJson objectAtIndex:0];
        levelLabel.text = [NSString stringWithFormat:@"%ld", [[dic objectForKey:@"agencylevel"] integerValue]];
        jineLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"get_cash_display"] floatValue]];
    }
    
}

- (void)downloadDataWithUrlString:(NSString *)urlString selector:(SEL)aSelector{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:aSelector withObject:data waitUntilDone:YES];
        
    });
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
    
    NSString *CellIdentifier = nil;
    if (0 == indexPath.row) {
        CellIdentifier = @"MaMaChart";
    }else {
        CellIdentifier = @"MaMaOrder";
    }
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
//        cell.textLabel.text = @"折线图";
        
    } else {
//        cell.textLabel.text = @"今日订单";
        
    }
    return cell;
    
    
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
