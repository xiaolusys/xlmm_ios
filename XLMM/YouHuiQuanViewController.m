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
//存储3类优惠券的数据。。。。


@property (nonatomic, strong) NSMutableArray *canUsedArray;
@property (nonatomic, strong) NSMutableArray *expiredArray;
@property (nonatomic, strong) NSMutableArray *usedArray;



@end

static NSString *ksimpleCell = @"youhuiCell";

@implementation YouHuiQuanViewController{
    YHQModel *model;
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
    // Do any additional setup after loading the view from its nib.
    
    self.canUsedArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.expiredArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.usedArray = [[NSMutableArray alloc] initWithCapacity:0];
    model = [YHQModel new];
    
   [self createNavigationBarWithTitle:@"优惠券" selecotr:@selector(backBtnClicked:)];
     [self createCollectionView];
    
    [self downLoadData];
    if (self.isSelectedYHQ == YES) {
        [self.myCollectionView reloadData];
    } else {
        [self downLoadOtherDate];
        
    }
    
    
    
    
}
- (void)downLoadOtherDate{
    
     //  http://192.168.1.31:9000/rest/v1/usercoupons/list_past_coupon.json
    
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/list_past_coupon", Root_URL];
    NSLog(@"url = %@", urlString);
    while (true) {
       
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        NSLog(@"data = %@", data);
        if (data == nil) {
            NSLog(@"下载失败");
            break;
        } else{
            NSLog(@"下载成功");
        }
    
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"json = %@", dictionary);
        
       urlString = [dictionary objectForKey:@"next"];
        
        
        NSArray *array = [dictionary objectForKey:@"results"];
        for (NSDictionary *dic in array) {
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
  //          [self.dataArray addObject:model1];
        }
        if ([[dictionary objectForKey:@"next"]class] == [NSNull class]) {
            NSLog(@"下页为空");
            break;
        }
        
    }
  //  NSLog(@"dataArray = %ld", (long)self.dataArray.count);
    
    
    
    
    
    
    
    [self.myCollectionView reloadData];

    
    
}

- (void)downLoadData{
    NSString *urlString = [NSString stringWithFormat:@"%@", KUserCoupins_URL];
    NSLog(@"url = %@", urlString);
    while (true) {
        
    
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (data == nil) {
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"json = %@", dictionary);
        NSArray *array = [dictionary objectForKey:@"results"];
        for (NSDictionary *dic in array) {
            if (self.isSelectedYHQ == YES) {
                if ([[dic objectForKey:@"status"] integerValue] == 0 && [[dic objectForKey:@"poll_status"] integerValue ] == 1) {
                    YHQModel *model1 = [self fillModelWithData:dic];
                    [self.canUsedArray addObject:model1];
                }
                
            } else {
                YHQModel *model1 = [self fillModelWithData:dic];
              [self.canUsedArray addObject:model1];
            }
        }
        urlString = [dictionary objectForKey:@"next"];
        if ([[dictionary objectForKey:@"next"]class] == [NSNull class]) {
            NSLog(@"下页为空");
            break;
        }
    }
    NSLog(@"self.dataArray = %@", self.canUsedArray);
    
    
    
    
    
    
}

- (YHQModel *)fillModelWithData:(NSDictionary *)dic{
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
    return model1;
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

  //  return self.dataArray.count;
    return 10;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHQCollectionCell *cell = (YHQCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
  //  YHQModel *model2 = [self.dataArray objectAtIndex:indexPath.row];
//    
//    if ([model2.status integerValue] == 1 || [model2.poll_status integerValue] == 2) {
//        cell.myimageView.image = [UIImage imageNamed:@"yhq_not_valid.jpg"];
//    }
//    else {
//        cell.myimageView.image = [UIImage imageNamed:@"yhq_valid.jpg"];
//    }
//    if ([model2.status integerValue] == 1) {
//        //优惠券已使用
//    } else {
//        //优惠券未使用
//        if ([model2.poll_status integerValue] == 2) {
//            //优惠券已过期
//        }else{
//            //
//        }
//    }
//   

    
    
    
    
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
 //   model = [self.dataArray objectAtIndex:indexPath.row];
   
  
 
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
