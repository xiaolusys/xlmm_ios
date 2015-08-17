//
//  CartViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/17.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableCellTableViewCell.h"
#import "MMClass.h"
#import "ShoppingCartModel.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"购物车";
    self.dataArray = [[NSMutableArray alloc] init];
    [self createInfo];
    [self downloadData];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)createInfo{
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    navLabel.text = @"购物车";
    navLabel.textColor = [UIColor blackColor];
    navLabel.font = [UIFont boldSystemFontOfSize:30];
    navLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = navLabel;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 29, 33);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon-gerenzhongxin.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(peopleCenter:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 18, 31);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"icon-fanhui.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
}

- (void)downloadData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCart_URL]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:@selector(fetchedCartData:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)fetchedCartData:(NSData *)responseData{
    if (responseData == nil) {
        return;
    }
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSLog(@"json = %@", json);
    for (NSDictionary *dic in json) {
        ShoppingCartModel *model = [ShoppingCartModel new];
        model.imageURL = [dic objectForKey:@"pic_path"];
        model.name = [dic objectForKey:@"title"];
        model.price = [dic objectForKey:@"price"];
        model.oldPrice = [dic objectForKey:@"std_sale_price"];
        model.sizeName = [dic objectForKey:@"sku_name"];
        model.cartID = [dic objectForKey:@"id"];
        model.number = [[dic objectForKey:@"num"] integerValue];
        model.buyerID = [dic objectForKey:@"buyer_id"];
        
        [self.dataArray addObject:model];
    }
    NSLog(@"%@", self.dataArray);
    
    [self.cartTableView reloadData];
    
    
}

- (void)peopleCenter:(UIButton *)button{
    NSLog(@"个人中心");
}

- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --UITableViewDelegate--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"simpleCellID";
    CartTableCellTableViewCell *cell = (CartTableCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CartTableCellTableViewCell" owner:nil options:nil];
        cell = [array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    ShoppingCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    
    cell.nameLabel.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)model.number];
    cell.oldPriceLabel.text = [NSString stringWithFormat:@"¥%@", model.oldPrice];
    cell.sizeLabel.text = model.sizeName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
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
