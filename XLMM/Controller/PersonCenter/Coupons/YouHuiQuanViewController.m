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
#import "YHQHeadView.h"

@interface YouHuiQuanViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property (nonatomic, retain) UICollectionView *myCollectionView;
//存储3类优惠券的数据。。。。


@property (nonatomic, strong) NSMutableArray *canUsedArray;
@property (nonatomic, strong) NSMutableArray *expiredArray;
@property (nonatomic, strong) NSMutableArray *usedArray;
@property (nonatomic, strong) NSMutableArray *disableUsedArray;







@end

static NSString *ksimpleCell = @"youhuiCell";
static NSString *ksimpleHeadView = @"YHQHeadView";


@implementation YouHuiQuanViewController{
    YHQModel *model;
   
    
    UIView *emptyView;
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
    NSLog(@"Youhuiquanviewcontroller viewDidLoad");
    
    self.canUsedArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.expiredArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.usedArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.disableUsedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    model = [YHQModel new];
    
    self.buyongBUtton.layer.cornerRadius = 20;
    self.buyongBUtton.layer.borderWidth = 1;
    self.buyongBUtton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    //  展示优惠券列表时 隐藏地步按钮。
    if (self.isSelectedYHQ == YES) {
        
    } else{
        self.bottomView.hidden = YES;
    }
    
    
    [self createNavigationBarWithTitle:@"优惠券" selecotr:@selector(backBtnClicked:)];
    
    [self createCollectionView];
    [self downLoadData];
    [self downLoadOtherDate];
    [self displayEmptyView];
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
    model1.use_fee = [dic objectForKey:@"use_fee"];
    model1.coupon_type_display = [dic objectForKey:@"coupon_type_display"];
    model1.use_fee_des = [dic objectForKey:@"use_fee_des"];
    model1.pros_desc = [dic objectForKey:@"pros_desc"];

    model1.isSelected = NO;
    
    return model1;
}
//获取已过期的优惠券
- (void)downLoadOtherDate{
    
     //  http://192.168.1.31:9000/rest/v1/usercoupons/list_past_coupon.json
    
    NSString *urlString;
    urlString = [NSString stringWithFormat:@"%@/rest/v1/usercoupons/list_past_coupon", Root_URL];
    NSLog(@"url = %@", urlString);
    while (true) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
     //   NSLog(@"data = %@", data);
        if (data == nil) {
       //     NSLog(@"下载失败");
            break;
        } else{
            NSLog(@"已过期优惠券 下载成功");
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSLog(@"json = %@", dictionary);
        NSArray *array = [dictionary objectForKey:@"results"];
        for (NSDictionary *dic in array) {
            YHQModel *model1 = [self fillModelWithData:dic];
            [self.expiredArray addObject:model1];
            
        }
        urlString = [dictionary objectForKey:@"next"];
        if ([[dictionary objectForKey:@"next"]class] == [NSNull class]) {
            NSLog(@"已过期下页为空");
            break;
        }
    }
    [self.myCollectionView reloadData];
}
// 获取可用已用优惠券
- (void)downLoadData{
    NSString *urlString = [NSString stringWithFormat:@"%@", KUserCoupins_URL];
    NSLog(@"url = %@", urlString);
    while (true) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if (data == nil) {
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
      //  NSLog(@"json = %@", dictionary);
        NSArray *array = [dictionary objectForKey:@"results"];
        
        for (NSDictionary *dic in array) {

            // 可用优惠券
             if ([[dic objectForKey:@"status"] integerValue] == 0) {
                 YHQModel *model1 = [self fillModelWithData:dic];
                 
                 [self.canUsedArray addObject:model1];
             }
            // 已用优惠券
            if ([[dic objectForKey:@"status"] integerValue] == 1) {
                YHQModel *model1 = [self fillModelWithData:dic];
                [self.usedArray addObject:model1];
            }
            // 不可用优惠券  已冻结状态
            if ([[dic objectForKey:@"status"] integerValue] == 2) {
                YHQModel *model1 = [self fillModelWithData:dic];
                [self.disableUsedArray addObject:model1];
            }
        }
        urlString = [dictionary objectForKey:@"next"];
        if ([[dictionary objectForKey:@"next"]class] == [NSNull class]) {
            NSLog(@"可用已用 下页为空");
            break;
        }
    }
  //  NSLog(@"self.dataArray = %@", self.canUsedArray);
}
// 创建优惠券集合视图
- (void)createCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0);
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundColor = [UIColor backgroundlightGrayColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    [self.myCollectionView registerClass:[YHQCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    [self.myCollectionView registerClass:[YHQHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksimpleHeadView];
    [self.containerView addSubview:self.myCollectionView];
}

- (void)displayEmptyView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyYHQView" owner:nil options:nil];
    UIView *empty = views[0];
    UIButton *button = (UIButton *)[empty viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    [button addTarget:self action:@selector(gotoLeadingView) forControlEvents:UIControlEventTouchUpInside];
    emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    emptyView.backgroundColor = [UIColor backgroundlightGrayColor];
    emptyView.hidden = YES;
    [self.containerView addSubview:emptyView];
    empty.frame = CGRectMake(0, SCREENHEIGHT/2 - 100, SCREENWIDTH, 220);
    [emptyView addSubview:empty];
}
- (void)gotoLeadingView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //购买选择优惠券返回 2 查看优惠券列表返回 4
    
    if (self.isSelectedYHQ == YES) {
        return 2;
    }
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (section == 0) {
        
        // 可用优惠券为0 显示空界面。
        if (self.canUsedArray.count == 0 && self.disableUsedArray.count == 0
            && self.expiredArray.count == 0 && self.usedArray.count == 0) {
            emptyView.hidden = NO;
        }
        return self.canUsedArray.count;
    } else if (section == 1){
        return self.disableUsedArray.count;
    } else if (section == 3){
         return self.expiredArray.count;
    } else {
        return self.usedArray.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YHQCollectionCell *cell = (YHQCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    YHQModel *yhqModel;
    NSString *imageName;
    if (indexPath.section == 0) {//可用优惠券
        yhqModel = [self.canUsedArray objectAtIndex:indexPath.row];
        
        cell.valueLabel.textColor = [UIColor colorWithR:240 G:80 B:80 alpha:1];
        if (self.isSelectedYHQ == YES) {
           //显示选中优惠券的图片 。。。。
            NSLog(@"%@  %@", self.selectedModelID,  yhqModel.ID);
            if ([self.selectedModelID isEqualToString:[NSString stringWithFormat:@"%@",yhqModel.ID]]) {
                imageName = @"newyouhuiquanxuanzhongbg.png";
                
            } else {
           
                imageName = @"newyouhuiquankeyongbg.png";
            }
        } else {
     
            imageName = @"newyouhuiquankeyongbg.png";
        }
        
      
        
        
    } else if (indexPath.section == 1){//冻结优惠券
        yhqModel = [self.disableUsedArray objectAtIndex:indexPath.row];
        imageName = @"newyouhuiquanbukeyongbg.png";
        cell.valueLabel.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];
        
    } else if (indexPath.section == 3){//过期优惠券
        yhqModel = [self.expiredArray objectAtIndex:indexPath.row];
        imageName = @"yiguoqiyouhuiquan.png";
        cell.valueLabel.textColor = [UIColor colorWithR:216 G:216 B:216 alpha:1];

    }else{//已用优惠券
        yhqModel = [self.usedArray objectAtIndex:indexPath.row];
        imageName = @"newyouhuiquanyiyongbg.png";
        cell.valueLabel.textColor = [UIColor colorWithR:74 G:74 B:74 alpha:1];


    }
    cell.myimageView.image = [UIImage imageNamed:imageName];
    [cell fillCellWithYHQModel:yhqModel];

    return cell;;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        YHQHeadView * headerView = (YHQHeadView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksimpleHeadView forIndexPath:indexPath];
        headerView.headLabel.text = @"可使用优惠券";
        return headerView;
    } else if (indexPath.section == 1){
        YHQHeadView * headerView = (YHQHeadView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksimpleHeadView forIndexPath:indexPath];
        headerView.headLabel.text = @"不可用优惠券";
        return headerView;
    }
    else if (indexPath.section == 3){
        YHQHeadView * headerView = (YHQHeadView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksimpleHeadView forIndexPath:indexPath];
        headerView.headLabel.text = @"已过期优惠券";
        return headerView;
    }else{
        YHQHeadView * headerView = (YHQHeadView *) [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ksimpleHeadView forIndexPath:indexPath];
        headerView.headLabel.text = @"已使用优惠券";
        return headerView;
    }
    
    
  
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREENWIDTH, SCREENWIDTH*220/720);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.canUsedArray.count == 0) {
            return CGSizeZero;
        } else {
            return CGSizeMake(SCREENWIDTH, 40);
        }
        
    } else if (section == 1){
        if (self.disableUsedArray.count == 0) {
            return CGSizeZero;
        } else {
            return CGSizeMake(SCREENWIDTH, 40);
        }
    } else if (section == 2){
        if (self.usedArray.count == 0) {
            return CGSizeZero;
        } else {
            return CGSizeMake(SCREENWIDTH, 40);
        }
    } else if (section == 3){
        if (self.expiredArray.count == 0) {
            return CGSizeZero;
        } else {
            return CGSizeMake(SCREENWIDTH, 40);
        }
    } else {
        return CGSizeZero;
    }
    
    
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(SCREENWIDTH, 40);
    }
    else{
        return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isSelectedYHQ == YES) {
        if (indexPath.section == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath = %@", indexPath);
    model = [self.canUsedArray objectAtIndex:indexPath.row];
    
    
   
  
 
    NSInteger couponType = [model.coupon_type integerValue];
    NSLog(@"couponType = %ld", (long)couponType);
    
    

    
    NSLog(@"是的， 我要使用这样优惠券");
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
        NSLog(@"更新优惠券");
        [self.delegate updateYouhuiquanWithmodel:model];
        
        
        
        
     
    }
    //记录选择的优惠券 并返回上一个界面。。。。
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"是的， 我要使用这样优惠券");
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
            NSLog(@"更新优惠券");
            [self.delegate updateYouhuiquanWithmodel:model];
//            NSLog(@"model = %@", model);
//            NSLog(@"model.title = %@, %@-%@.\nid = %@", model.title, model.deadline, model.created, model.ID);
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

- (IBAction)buyongClicked:(id)sender {
    NSLog(@"quxiao ");

    if (self.delegate && [self.delegate respondsToSelector:@selector(updateYouhuiquanWithmodel:)]) {
        NSLog(@"取消优惠券");
        [self.delegate updateYouhuiquanWithmodel:nil];
       
       
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
