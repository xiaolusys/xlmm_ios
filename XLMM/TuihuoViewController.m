//
//  TuihuoViewController.m
//  XLMM
//
//  Created by younishijie on 15/9/9.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "TuihuoViewController.h"
#import "MMClass.h"
#import "TuihuoModel.h"
#import "TuihuoCollectionCell.h"
#import "OrderModel.h"
#import "UIViewController+NavigationBar.h"
#import "UIImageView+WebCache.h"
#import "NSString+URL.h"
#import "RefundDetailsViewController.h"



@interface TuihuoViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation TuihuoViewController{
    NSInteger downloadCount;
    NSInteger count;
}

static NSString * const reuseIdentifier = @"tuihuoCell";




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    downloadCount = 0;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"我的退货/款";
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[TuihuoCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
    //[self createInfo];
    [self createNavigationBarWithTitle:@"退款退货" selecotr:@selector(backBtnClicked:)];

    [self downlaodData];

}

- (void)downlaodData{
    
   // http://m.xiaolu.so/rest/v1/refunds
    NSString *urlstring = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"url = %@", urlstring);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
        [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
        
        
    });
    
}
//  退货款列表分页下载


-(void)displayDefaultView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"EmptyDefault" owner:nil options:nil];
    UIView *defaultView = views[0];
    UIButton *button = [defaultView viewWithTag:100];
    button.layer.cornerRadius = 15;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor buttonEnabledBackgroundColor].CGColor;
    UILabel *label = (UILabel *)[defaultView viewWithTag:300];
    label.text = @"亲,您暂时还没有退货(款)订单哦～快去看看吧!";
    
    [button addTarget:self action:@selector(gotoLandingPage) forControlEvents:UIControlEventTouchUpInside];
    
    defaultView.frame = CGRectMake(0,0,SCREENWIDTH,SCREENHEIGHT);
    [self.view addSubview:defaultView];
    
}

-(void)gotoLandingPage{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)fetchedWaipayData:(NSData *)data{
    NSLog(@"11");
    
    if (data == nil) {
        return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"json = %@", json);
    if ([[json objectForKey:@"count"] integerValue] == 0) {
        NSLog(@"您的退货列表为空");
        [self displayDefaultView];
        return;
    }
    
  
//    [self.dataArray removeAllObjects];
    
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *dic in array) {
        TuihuoModel *model = [TuihuoModel new];
        model.ID = [[dic objectForKey:kID] integerValue];
        model.url = [dic objectForKey:kURL];
        model.refund_no = [dic objectForKey:kRefund_NO];
        model.trade_id = [[dic objectForKey:kTrade_ID] integerValue];
        model.order_id = [[dic objectForKey:kOrder_ID] integerValue];
        model.buyer_id = [[dic objectForKey:kBuyer_ID] integerValue];
        model.item_id = [[dic objectForKey:kItem_ID] integerValue];
        model.title = [dic objectForKey:kTitle];
        model.sku_id = [[dic objectForKey:kSku_ID] integerValue];
        model.sku_name = [dic objectForKey:kSku_Name];
        model.refund_num = [[dic objectForKey:kRefund_Num] integerValue];
        model.buyer_nick = [dic objectForKey:kBuyer_Nick];
        model.mobile = [dic objectForKey:kMobile];
        model.phone = [dic objectForKey:kPhone];
        model.total_fee = [[dic objectForKey:kTotal_Fee] floatValue];
        model.payment = [[dic objectForKey:kPayment] floatValue];
        model.created = [dic objectForKey:kCreated];
        model.modified = [dic objectForKey:kModified];
        model.company_name = [dic objectForKey:kCompany_Name];
        model.sid = [dic objectForKey:kSID];
        model.reason = [dic objectForKey:kReason];
        model.pic_path = [dic objectForKey:kPic_Path];
        model.desc = [dic objectForKey:kDesc];
        model.feedback = [dic objectForKey:kFeedback];
        model.has_good_return = [[dic objectForKey:kHas_Good_Return] boolValue];
        model.has_good_change = [[dic objectForKey:kHas_Good_Change] boolValue];
        model.good_status = [[dic objectForKey:kGood_status] integerValue];
        model.status = [[dic objectForKey:kStatus] integerValue];
        model.refund_fee = [[dic objectForKey:kRefune_Fee] floatValue];
        model.status_display = [dic objectForKey:kStatus_Display];
        if ([[dic objectForKey:@"proof_pic"] isKindOfClass:[NSArray class]]) {
            model.proof_pic = [dic objectForKey:@"proof_pic"];
            
        } else {
            model.proof_pic = @[];
        }
        
        
        
        for (__unused NSString *imageUrl in model.proof_pic) {
            NSLog(@"imageUrl = %@", imageUrl);
            
        }
        [self.dataArray addObject:model];
    
    }
    
    
    if ([[json objectForKey:@"next"] class] == [NSNull class]) {
        // 下一页为空
    } else {
        // 下载下一页内容
        
        NSString *string = [json objectForKey:@"next"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"url = %@", string);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string]];
            [self performSelectorOnMainThread:@selector(fetchedWaipayData:) withObject:data waitUntilDone:YES];
            
            
        });
        
    }
    
    NSLog(@"dataArray = %@", self.dataArray);
    
    [self.collectionView reloadData];
    
    
    
    
        
        
}




- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"我的退货(款)";
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
    
    NSLog(@"back to root");
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.dataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TuihuoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    

    
    TuihuoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.pic_path == nil || [model.pic_path class] == [NSNull class] || [model.pic_path isEqualToString:@""]) {
        cell.myImageView.image = nil;
    } else {
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[model.pic_path URLEncodedString]]];
        cell.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        cell.myImageView.layer.masksToBounds = YES;
        cell.myImageView.layer.cornerRadius = 5;
        cell.myImageView.layer.borderWidth = 0.5;
        cell.myImageView.layer.borderColor = [UIColor colorWithR:218 G:218 B:218 alpha:1].CGColor;
        
    }
    cell.titleLabel.text = model.title;
    cell.numberLabel.text = [NSString stringWithFormat:@"x%ld", (long)model.refund_num];
    cell.sizeLabel.text = model.sku_name;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%.1f", model.payment];
    if ([model.status_display isEqualToString:@"买家已经申请退款"] || [model.status_display isEqualToString:@"买家已经退货"]) {
        model.status_display = @"卖家处理中";
    }
    if ([model.status_display isEqualToString:@"卖家已经同意退款"]) {
        model.status_display = @"审核通过";
        
    }
    cell.infoLabel.text = model.status_display;
    cell.bianhao.text = [NSString stringWithFormat:@"%@", model.refund_no];
    cell.jine.text = [NSString stringWithFormat:@"¥%.2f", model.refund_fee];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 10, 0);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREENWIDTH, 174);
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TuihuoModel *model = [self.dataArray objectAtIndex:indexPath.row];
   
    
    RefundDetailsViewController *xiangqingVC = [[RefundDetailsViewController alloc] init];

    xiangqingVC.model = model;
    
    NSLog(@"refundmodel = %@", xiangqingVC.model);
    
    
    [self.navigationController pushViewController:xiangqingVC animated:YES];
    


}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
