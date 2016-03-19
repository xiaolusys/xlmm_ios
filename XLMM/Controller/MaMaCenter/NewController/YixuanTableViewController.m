//
//  YixuanTableViewController.m
//  XLMM
//
//  Created by younishijie on 16/3/19.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "YixuanTableViewController.h"
#import "UIViewController+NavigationBar.h"
#import "YixuanTableViewCell.h"
#import "AFNetworking.h"
#import "MMClass.h"
#import "MaMaSelectProduct.h"



static NSString *const cellIdentifier = @"YixuanCell";

@interface YixuanTableViewController ()<ProductxiajiaDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation YixuanTableViewController{
    
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
    self.dataArr = [[NSMutableArray alloc] init];
    
    [self createNavigationBarWithTitle:@"已选" selecotr:@selector(backClicked:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark --数据处理
- (void)dealData:(NSArray *)data {
    NSLog(@"data = %@", data);
    for ( NSDictionary *pdt in data) {
        
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        
        
        [productM setValuesForKeysWithDictionary:pdt];
        
        
        [self.dataArr addObject:productM];
    }
    
    if (self.dataArr.count == 0) {
        [self createDefaultView];
    } else {
        
        [self.tableView reloadData];
    }
}
- (void)createDefaultView{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已选列表为空，快去加入一些商品" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YixuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[YixuanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    MaMaSelectProduct *model = self.dataArr[indexPath.row];
    NSLog(@"model = %@", model);

    [cell fillData:model];
    cell.delegate = self;
    
    
    return cell;
}


- (void)productxiajiaBtnClick:(YixuanTableViewCell *)cell btn:(UIButton *)btn {
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
    NSDictionary *parameters = @{@"product":cell.pdtID};
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *rows = [NSArray arrayWithObject:indexPath];
    
    [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataArr removeObject:cell.model];
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"店铺－－Error: %@", error);
    }];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
