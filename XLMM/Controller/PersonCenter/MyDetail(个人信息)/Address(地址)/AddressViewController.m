//
//  AddressViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddressViewController.h"
#import "AddAdressViewController.h"
#import "AddressModel.h"
#import "MMClass.h"
#import "AddressTableCell.h"


#define MAINSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINSCREENHEIGHT [UIScreen mainScreen].bounds.size.height




@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate, AddressDelegate>
{
    NSMutableArray *dataArray;
    AddressModel *deleteModel;
    
    
}

@property (nonatomic, strong)UITableView *addressTableView;


@end

@implementation AddressViewController{
    AddressTableCell *selectCell;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if (dataArray.count != 0) {
        [dataArray removeAllObjects];
    }
    [self downloadAddressData];
    
    [MobClick beginLogPageView:@"AddressViewController"];

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"AddressViewController"];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.addressTableView reloadData];
    selectCell.backgroundView.backgroundColor = [UIColor whiteColor];
    selectCell.firstLabel.textColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"收货地址";
    
    [self createNavigationBarWithTitle:@"收货地址" selecotr:@selector(backBtnClicked:)];
    dataArray = [[NSMutableArray alloc] init];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120) style:UITableViewStylePlain];
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    [self.view addSubview:self.addressTableView];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    
    
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addressTableView.backgroundColor = [UIColor backgroundlightGrayColor];
    //self.addressTableView.d
}



- (void)backBtnClicked:(UIButton *)button{
    NSLog(@"fanhui");
    [self.navigationController popViewControllerAnimated:YES];
}

//下载数据
//- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        if (data == nil) {
//            return ;
//        }
//        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
//        
//    });
//}

- (void)downloadAddressData{
//    [self downLoadWithURLString:kAddress_List_URL andSelector:@selector(fatchedAddressData:)];
    //2016.7.13 modify to afn
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:kAddress_List_URL parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (!responseObject)return ;
              [self fatchedAddressData:responseObject];              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

}
- (void)fatchedAddressData:(NSArray *)dic{
    NSArray *addressArray = dic;

    NSLog(@"addArray = %@", addressArray);
    if (addressArray.count == 0) {
        NSLog(@"数据下载错误");
        [self displayEmptyAddressView];
        [self.addressTableView reloadData];
        return;
    }
    for (NSDictionary *dic in addressArray) {
        AddressModel *model = [[AddressModel alloc] init];
        model.addressID = [dic objectForKey:@"id"];
        model.addressURL = [dic objectForKey:@"url"];
        model.buyerID = [dic objectForKey:@"cus_uid"];
        model.buyerName = [dic objectForKey:@"receiver_name"];
        model.cityName = [dic objectForKey:@"receiver_city"];;
        model.provinceName = [dic objectForKey:@"receiver_state"];
        model.countyName = [dic objectForKey:@"receiver_district"];
        model.streetName = [dic objectForKey:@"receiver_address"];
        model.phoneNumber = [dic objectForKey:@"receiver_mobile"];
        model.isDefault = [[dic objectForKey:@"default"]boolValue];
        [dataArray addObject:model];
    }
    MMLOG(dataArray);
    
    [self.addressTableView reloadData];
    
}

//   13816404857
#pragma mark --AddAddressDelegate--




#pragma mark --UITableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:888];
        [view removeFromSuperview];
    }
    return dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  static NSString *CellIdentifier = @"CellIdentifier";
   
 
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:nil options:nil];
    AddressTableCell *cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.addressModel = [dataArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    if (self.isSelected == YES) {
        
        cell.modifyAddressButton.layer.borderWidth = 0.5;
        cell.modifyAddressButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
        cell.modifyAddressButton.layer.cornerRadius = 15;
        
    } else {
        cell.modifyAddressButton.hidden = YES;
        
    }
    if (indexPath.row == -1) {
        cell.leadingWidth.constant = 40;
        cell.addressImageView.hidden = NO;
        cell.lineView.hidden = NO;
    } else {
        
        cell.leadingWidth.constant = 8;
        cell.addressImageView.hidden = YES;
        cell.lineView.hidden = YES;
        if (indexPath.row == 0) {
            cell.leadingWidth.constant = 60;
            cell.morenLabel.hidden = NO;
            cell.morenLabel.layer.borderWidth = 0.5;
            cell.morenLabel.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
            
        } else {
            cell.morenLabel.hidden = YES;
            cell.leadingWidth.constant = 8;
        }
    }
  
    AddressModel *model = [dataArray objectAtIndex:indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", model.provinceName, model.cityName, model.countyName, model.streetName];
    
    cell.secondLabel.text = address;
    cell.delegate = self;
    cell.addressModel = model;
    
    NSString *buyerInfo = [NSString stringWithFormat:@"%@    %@", model.buyerName, model.phoneNumber];
    cell.firstLabel.text = buyerInfo;
   
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSLog(@"%ld", (long)indexPath.row);
    
    if((dataArray == nil) || (dataArray.count == 0)) return;
    
    
    AddressModel *model = [dataArray objectAtIndex:indexPath.row];
    
    if (self.isSelected == YES) {
        if (_delegate && [_delegate respondsToSelector:@selector(addressView:model:)]) {
            [self.delegate addressView:self model:model];
        }
//        [self.delegate addressView:self model:model];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } else {
    
        AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
        addVC.isAdd = NO;
        addVC.addressModel = [dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:addVC animated:YES];
    }

    
    
    
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.addressTableView setEditing:editing animated:animated];
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        deleteModel = [dataArray objectAtIndex:indexPath.row];
        [dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //调用删除接口。。。。。。
        
       [self deleteAddress:deleteModel];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)displayEmptyAddressView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyAddressView" owner:nil options:nil];
    UIView *view = views[0];
    view.tag = 888;
    view.frame = CGRectMake(0, SCREENHEIGHT/2-100, SCREENWIDTH, 140);
    [self.view addSubview:view];
}



#pragma mark --AddressDelegate--

- (void)deleteAddress:(AddressModel*)model{
    NSLog(@"删除地址-----");
    
    NSLog(@"address id = %@", model.addressID);
    NSString *deleteurlString = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL,model.addressID];
    NSLog(@"deleteURL = %@", deleteurlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:deleteurlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              [dataArray removeAllObjects];
              [self downloadAddressData];
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];
}




- (void)modifyAddress:(AddressModel*)model{
    NSLog(@"修改地址-----");
    
    
    NSLog(@"address id = %@", model.addressID);

    AddAdressViewController *addAdVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    addAdVC.isAdd = NO;
    addAdVC.addressModel = model;
    [self.navigationController pushViewController:addAdVC animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addButtonClicked:(id)sender {
    
    AddAdressViewController *addVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    addVC.isAdd = YES;
    [self.navigationController pushViewController:addVC animated:YES];
}
@end
