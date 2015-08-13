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

#define MAINSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINSCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface AddressViewController ()<UITableViewDataSource, UITableViewDelegate, AddAddressDelegate>
{
    NSMutableArray *dataArray;
    
}

@property (nonatomic, strong)UITableView *addressTableView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"收货地址";
    dataArray = [[NSMutableArray alloc] init];
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    [self.view addSubview:_addressTableView];
    
    
    
}


#pragma mark --AddAddressDelegate--

- (void)updateAddressList:(AddressModel *)model{
    NSLog(@"up data");
    [dataArray addObject:model];
    NSLog(@"dataArray = %@", dataArray);
    [self.addressTableView reloadData];
    
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
        return 60;
    }
}

- (UIView *)createHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 80)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 140, 40)];
    label.text = @"收货地址";
    label.font = [UIFont systemFontOfSize:24];
    [headView addSubview:label];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, 180, 40)];
    label2.text = @"新增收货地址";
    label2.font = [UIFont systemFontOfSize:24];
    [headView addSubview:label2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    UIImageView *btnImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia.png"]];
    btnImage.frame = CGRectMake(8, 8, 24, 24);
    
    [button addSubview:btnImage];
    [button addTarget:self action:@selector(addAdress:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(MAINSCREENWIDTH - 60, 36, 44, 44);
    [headView addSubview:button];
    return headView;
}

- (void)addAdress:(UIButton *)button{
    NSLog(@"新增地址");
    AddAdressViewController *addAdVC = [[AddAdressViewController alloc] initWithNibName:@"AddAdressViewController" bundle:nil];
    addAdVC.delegate = self;
    [self.navigationController pushViewController:addAdVC animated:YES];
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
    }
    if (indexPath.row == 0) {
        
        [cell.contentView addSubview:[self createHeadView]];
        
        return cell;
    }
    AddressModel *model = [dataArray objectAtIndex:indexPath.row -1];
    NSString *address = [NSString stringWithFormat:@"%@-%@-%@-%@", model.provinceName, model.cityName, model.countyName, model.streetName];
    
    cell.detailTextLabel.text = address;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:18];
    NSLog(@"%@", address);
    
    NSString *buyerInfo = [NSString stringWithFormat:@"%@ %@", model.buyerName, model.phoneNumber];
    cell.textLabel.text = buyerInfo;
    cell.textLabel.font= [UIFont systemFontOfSize:24];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
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

@end
