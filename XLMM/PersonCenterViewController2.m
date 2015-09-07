//
//  PersonCenterViewController2.m
//  XLMM
//
//  Created by younishijie on 15/8/3.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PersonCenterViewController2.h"
#import "MMClass.h"

#define kSimpleCellIdentifier @"simpleCell"

@interface PersonCenterViewController2 ()

@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation PersonCenterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"待收货订单";
     [self.collectionView registerClass:[ShouHuoCollectionViewCell class] forCellWithReuseIdentifier:kSimpleCellIdentifier];
    [self createInfo];
    
    [self downlaodData];
   // [self.view addSubview:[[UIView alloc] init]];
    
    
}

- (void)downlaodData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kWaitsend_List_URL]];
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}

- (void)fetchedWaipayData:(NSData *)data{
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"无待支付列表");
        return;
    }
    
    self.dataArray = [json objectForKey:@"results"];
    NSLog(@"dataArray = %@", self.dataArray);
    //self.collectionView.contentSize = CGSizeMake(SCREENWIDTH, 120*self.dataArray.count);
    [self.collectionView reloadData];
    
    
    
}






- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"待收货订单";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 12, 12, 22);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
}



- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----CollectionViewDelegate-----

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 140);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShouHuoCollectionViewCell *cell = (ShouHuoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSimpleCellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    [cell.myimageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"order_pic"]]];
    
    NSMutableString *string = [[NSMutableString alloc]initWithString:[dic objectForKey:@"created"]];
    NSRange range = [string rangeOfString:@"T"];
    //    [string deleteCharactersInRange:range];
    //    [string insertString:@" " atIndex:range.location];
    [string replaceCharactersInRange:range withString:@" "];
    range = [string rangeOfString:@"-"];
    [string replaceCharactersInRange:range withString:@"/"];
    range = [string rangeOfString:@"-"];
    [string replaceCharactersInRange:range withString:@"/"];
    cell.xiadanshijianLabel.text = string;
    cell.zhuangtaiLabel.text = [dic objectForKey:@"status_display"];
    cell.jineLabel.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"payment"]];
    cell.biaohaoLabel.text = [dic objectForKey:@"tid"];
    
    
    
    return cell;

 
    
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
