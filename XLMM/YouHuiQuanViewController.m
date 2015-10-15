//
//  YouHuiQuanViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/20.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "YouHuiQuanViewController.h"
#import "AddYouhuiquanViewController.h"
#import "MMClass.h"
#import "YHQCollectionCell.h"
#import "YHQModel.h"
#import "UIViewController+NavigationBar.h"

@interface YouHuiQuanViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, retain) UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

static NSString *ksimpleCell = @"youhuiCell";

@implementation YouHuiQuanViewController{
    YHQModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    model = [YHQModel new];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createInfo];
   // [self createNavigationBarWithTitle:@"" selecotr:@selector(backBtnClicked:)];
     [self createCollectionView];
   // self.containerView.hidden = YES;
    
    [self downLoadData];
}

- (void)downLoadData{
    NSString *urlString = [NSString stringWithFormat:@"%@", KUserCoupins_URL];
    NSLog(@"url = %@", urlString);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if (data == nil) {
        return;
    }
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"array = %@", array);
    for (NSDictionary *dic in array) {
        if (self.isSelectedYHQ == YES) {
            if ([[dic objectForKey:@"status"] integerValue] == 0 && [[dic objectForKey:@"poll_status"] integerValue ]!= 2) {
                
         
                YHQModel *model1 = [YHQModel new];
                model1.ID = [dic objectForKey:@"id"];
                model1.coupon_no = [dic objectForKey:@"coupon_no"];
                model1.coupon_type = [dic objectForKey:@"coupon_type"];
                model1.coupon_value = [dic objectForKey:@"coupon_value"];
                model1.created = [dic objectForKey:@"created"];
                model1.customer = [dic objectForKey:@"customer"];
                model1.deadline = [dic objectForKey:@"deadline"];
                model1.poll_status = [dic objectForKey:@"poll_status"];
                
                model1.sale_trade = [dic objectForKey:@"sale_trade"];
                model1.status = [dic objectForKey:@"status"];
                model1.title = [dic objectForKey:@"title"];
                model1.valid = [dic objectForKey:@"valid"];
                [self.dataArray addObject:model1];
            }
            
        } else {
            YHQModel *model1 = [YHQModel new];
            model1.ID = [dic objectForKey:@"id"];
            model1.coupon_no = [dic objectForKey:@"coupon_no"];
            model1.coupon_type = [dic objectForKey:@"coupon_type"];
            model1.coupon_value = [dic objectForKey:@"coupon_value"];
            model1.created = [dic objectForKey:@"created"];
            model1.customer = [dic objectForKey:@"customer"];
            model1.deadline = [dic objectForKey:@"deadline"];
            model1.poll_status = [dic objectForKey:@"poll_status"];
            
            model1.sale_trade = [dic objectForKey:@"sale_trade"];
            model1.status = [dic objectForKey:@"status"];
            model1.title = [dic objectForKey:@"title"];
            model1.valid = [dic objectForKey:@"valid"];
            [self.dataArray addObject:model1];
            
           
            for (int i = 0, j = 0; j<self.dataArray.count; i++, j++) {
                YHQModel *model3 = [self.dataArray objectAtIndex:i];
                if ([model3.poll_status integerValue] == 2) {
                    [self.dataArray removeObjectAtIndex:i];
                    [self.dataArray addObject:model3];
                    i--;
                    
                }
              
                
                
                
            }
            
            
        }
    }
    [self.myCollectionView reloadData];
    
}
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    
    self.myCollectionView.backgroundColor = [UIColor whiteColor];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    
    [self.myCollectionView registerClass:[YHQCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
   
    [self.containerView addSubview:self.myCollectionView];
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHQCollectionCell *cell = (YHQCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    YHQModel *model2 = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([model2.status integerValue] == 1 || [model2.poll_status integerValue] == 2) {
        cell.myimageView.image = [UIImage imageNamed:@"yhq_not_valid.jpg"];
    }
    else {
        cell.myimageView.image = [UIImage imageNamed:@"yhq_valid.jpg"];
    }
    cell.name1.text = model2.title;
    if ([model2.poll_status integerValue] == 2) {
         cell.name2.text = @"已过期";
    }else{
    cell.name2.text = @"";
    }
//    cell.name2.text = @"";
    cell.time1.text = model2.created;
    cell.time2.text = model2.deadline;
    
    
    
    
       return cell;;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENWIDTH, SCREENWIDTH*164/590);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectedYHQ == YES) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath = %@", indexPath);
    model = [self.dataArray objectAtIndex:indexPath.row];
   
  
 
    NSInteger couponType = [model.coupon_type integerValue];
    NSLog(@"couponType = %ld", (long)couponType);
    
    
    if (couponType == 2) {
        if (self.payment < 150 ) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"商品价格不足优惠券使用金额哦~" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        
    } else if(couponType ==3){
        
        if (self.payment < 259) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"商品价格不足优惠券使用金额哦~" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定选择这样优惠券吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"是的， 我要使用这样优惠券");
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
            NSLog(@"更新优惠券");
            [self.delegate updateYouhuiquanWithmodel:model];
            NSLog(@"model = %@", model);
            NSLog(@"model.title = %@, %@-%@.\nid = %@", model.title, model.deadline, model.created, model.ID);
        }
        //记录选择的优惠券 并返回上一个界面。。。。
        [self.navigationController popViewControllerAnimated:YES];
    }
}






- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"优惠券";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-fanhui.png"]];
    imageView.frame = CGRectMake(8, 14, 10, 17);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia.png"]];
    imageView2.frame = CGRectMake(8, 14, 20, 20);
    [button2 addSubview:imageView2];
    [button2 addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)addBtnClicked:(UIButton *)button{
    NSLog(@"获得优惠券");
    
    AddYouhuiquanViewController *addVC = [[AddYouhuiquanViewController alloc] initWithNibName:@"AddYouhuiquanViewController" bundle:nil];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (void)backBtnClicked:(UIButton *)button{
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

@end
