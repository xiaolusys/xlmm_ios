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
#import "SVProgressHUD.h"



static NSString *const cellIdentifier = @"YixuanCell";

@interface YixuanTableViewController ()<ProductxiajiaDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, getter=isTableViewEdit) BOOL tableViewEdit;

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
    [SVProgressHUD show];
    
    
    [self createNavigationBarWithTitle:@"已选" selecotr:@selector(backClicked:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/shop_product?page_size=200", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [self createRightItem];
    

}

- (void)createRightItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)editClick{
    
    if (!self.isTableViewEdit) {
        self.navigationItem.rightBarButtonItem.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
        self.tableViewEdit = YES;
        
    } else {
        self.tableViewEdit = NO;
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
    }
    
}

#pragma mark --数据处理
- (void)dealData:(NSDictionary *)data {
    NSLog(@"data = %@", data);
    NSArray *array = [data objectForKey:@"results"];
    
    for ( NSDictionary *pdt in array) {
        
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        
        
        [productM setValuesForKeysWithDictionary:pdt];
        
        
        [self.dataArr addObject:productM];
    }
    
    if (self.dataArr.count == 0) {
        [SVProgressHUD dismiss];
        [self createDefaultView];
    } else {
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }
}
- (void)createDefaultView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    // 已选列表为空时默认图片。。。。。
    
    [self.tableView addSubview:view];
    
    
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
    NSLog(@"model = %@", model.productId);
    

    [cell fillData:model];
    cell.delegate = self;
    
    
    return cell;
}

-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //打开编辑
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //允许移动
    return YES;
}



-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
    MaMaSelectProduct *newModel = self.dataArr[newPath.row];
    MaMaSelectProduct *oldModel = self.dataArr[oldPath.row];
    
    NSString *change_id = [oldModel.productId stringValue];
    
    NSString *target_id = [newModel.productId stringValue];
    
    

    [self.dataArr removeObjectAtIndex:oldPath.row];
    [self.dataArr insertObject:oldModel atIndex:newPath.row];
    
    //[self.dataArr exchangeObjectAtIndex:newPath.row withObjectAtIndex:oldPath.row];
    ///rest/v1/pmt/cushoppros/change_pro_position
    NSString  *string = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/change_pro_position", Root_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
    
    
    
    NSDictionary *parameters = @{@"change_id":change_id,
                                 @"target_id":target_id
                                 };
    
    NSLog(@"params = %@", parameters);
    
    [manager POST:string parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //  NSError *error;
              NSLog(@"JSON: %@", responseObject);
              NSLog(@"%@", [responseObject objectForKey:@"message"]);
              
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              
              
          }];

    
    
    NSLog(@"%@ --> %@", change_id, target_id);
    
    for (MaMaSelectProduct *modle in self.dataArr) {
        NSLog(@"model id = %@", modle.productId);
    }
    
    
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}




- (void)productxiajiaBtnClick:(YixuanTableViewCell *)cell btn:(UIButton *)btn {
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
    NSDictionary *parameters = @{@"product":cell.pdtID};
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *rows = [NSArray arrayWithObject:indexPath];
    [self.dataArr removeObject:cell.model];
    [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    
    [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res = %@", responseObject);
        
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
