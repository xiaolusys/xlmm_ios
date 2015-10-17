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
#import "AFNetworking.h"
#import "AFNetworking.h"
#import "UIViewController+NavigationBar.h"


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


}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [self.addressTableView reloadData];
    selectCell.backgroundView.backgroundColor = [UIColor whiteColor];
    selectCell.firstLabel.textColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.title = @"收货地址";
    
    [self createNavigationBarWithTitle:@"收货地址" selecotr:@selector(backBtnClicked:)];
    dataArray = [[NSMutableArray alloc] init];
    
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    [self.view addSubview:_addressTableView];
   
}



- (void)backBtnClicked:(UIButton *)button{
    NSLog(@"fanhui");
    [self.navigationController popViewControllerAnimated:YES];
}

//下载数据
- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

- (void)downloadAddressData{
    [self downLoadWithURLString:kAddress_List_URL andSelector:@selector(fatchedAddressData:)];
    
    
}
- (void)fatchedAddressData:(NSData *)responsedata{
    NSError *error = nil;
    
    NSArray *addressArray = [NSJSONSerialization JSONObjectWithData:responsedata options:kNilOptions error:&error];
    if (error != nil) {
        return;
    }
    NSLog(@"addArray = %@", addressArray);
    if (addressArray.count == 0) {
        NSLog(@"数据下载错误");
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



- (UIView *)createHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 80)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 140, 40)];
    label.text = @"收货地址";
    label.font = [UIFont systemFontOfSize:16];
    [headView addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, 180, 40)];
    label2.text = @"新增收货地址";
    label2.font = [UIFont systemFontOfSize:16];
    [headView addSubview:label2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    UIImageView *btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia.png"]];
    btnImage.frame = CGRectMake(8, 8, 24, 24);
    
    [button addSubview:btnImage];
    [button addTarget:self action:@selector(addAdress) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(MAINSCREENWIDTH - 60, 36, 44, 44);
    [headView addSubview:button];
    return headView;
}

- (void)addAdress{
    NSLog(@"新增地址");
    AddAdressViewController *addAdVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    addAdVC.isAdd = YES;
    [self.navigationController pushViewController:addAdVC animated:YES];
    
    
}

#pragma mark --UITableViewDelegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count + 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
        
    }
    else
    {
        return 96;
    }
}



- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  static NSString *CellIdentifier = @"CellIdentifier";
    if (indexPath.row == 0) {
        
        UITableViewCell *cell =(UITableViewCell *) [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
        [cell.contentView addSubview:[self createHeadView]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        return cell;
    }
 
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:nil options:nil];
      AddressTableCell *cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  
    AddressModel *model = [dataArray objectAtIndex:indexPath.row -1];
    NSString *address = [NSString stringWithFormat:@"%@-%@-%@-%@", model.provinceName, model.cityName, model.countyName, model.streetName];
    
    cell.secondLabel.text = address;
    NSLog(@"%@", address);
    cell.delegate = self;
    cell.addressModel = model;
    
    NSString *buyerInfo = [NSString stringWithFormat:@"%@ %@", model.buyerName, model.phoneNumber];
    cell.firstLabel.text = buyerInfo;
    cell.firstLabel.userInteractionEnabled = NO;
    cell.secondLabel.userInteractionEnabled = NO;
    cell.frontImageView.userInteractionEnabled = NO;
    cell.firstLabel.textColor = [UIColor blackColor];
    cell.backgroundView.backgroundColor = [UIColor whiteColor];

    if (indexPath.row == 1) {
        cell.frontImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
        //cell.bgView.backgroundColor = [UIColor redColor];
        cell.firstLabel.textColor = [UIColor redColor];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", (long)indexPath.row);
    if (indexPath.row == 0) {
        
        
        return;
    }
    
    
    AddressTableCell *cell = (AddressTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.frontImageView.image = [UIImage imageNamed:@"icon-radio.png"];
    cell.bgView.backgroundColor = [UIColor whiteColor];
    cell.firstLabel.textColor = [UIColor blackColor];
    
    

    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        [self addAdress];
        return;
    }
    NSIndexPath *indexpathDefaule = [NSIndexPath indexPathForRow:1 inSection:0];
    
    if (indexPath.row != 1) {
        AddressTableCell *cell = (AddressTableCell *)[tableView cellForRowAtIndexPath:indexpathDefaule];
        cell.frontImageView.image = [UIImage imageNamed:@"icon-radio.png"];
        cell.bgView.backgroundColor = [UIColor whiteColor];
        cell.firstLabel.textColor = [UIColor blackColor];
    }
    
    AddressTableCell *cell = (AddressTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.frontImageView.image = [UIImage imageNamed:@"icon-radio-select.png"];
    //cell.bgView.backgroundColor = [UIColor redColor];
    cell.firstLabel.textColor = [UIColor redColor];
    selectCell = cell;

    
  //  http://192.168.1.61:8000/rest/v1/address/%@/change_default
    
    
    NSString *addID = [[dataArray objectAtIndex:indexPath.row-1] addressID];
    NSLog(@"addid = %@", addID);
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_default", Root_URL, addID];
    NSLog(@"url = %@", urlString);
    
   
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    
    [manager POST:urlString parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"JSON: %@", responseObject);
              
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              NSLog(@"Error: %@", error);
              
          }];

    
    
    
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
        deleteModel = [dataArray objectAtIndex:indexPath.row - 1];
        [dataArray removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        //调用删除接口。。。。。。
        
       [self deleteAddress:deleteModel];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
