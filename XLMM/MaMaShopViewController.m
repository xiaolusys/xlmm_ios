//
//  MaMaShopViewController.m
//  XLMM
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 上海己美. All rights reserved.
//


#import "MaMaShopViewController.h"
#import "UIViewController+NavigationBar.h"
#import "MMClass.h"
#import "AFNetworking.h"
#import "ProductSelectionListCell.h"
#import "MaMaSelectProduct.h"
#import "ShopPreviousViewController.h"
#import "WXApi.h"
#import "SVProgressHUD.h"
#import "MamaShareView.h"
#import "WeiboSDK.h"
#import "SendMessageToWeibo.h"




@interface MaMaShopViewController ()
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)BOOL isRequest;

@property (nonatomic, copy) NSString *shopShareLink;
@property (nonatomic, copy) NSString *shopShareName;
@property (nonatomic, strong) UIImage *shopShareImage;


@property (nonatomic, copy) NSString *productLink;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productDes;
@property (nonatomic, strong) UIImage *productImage;

@property (nonatomic, copy) NSString *productUrl;





@end

static NSString *cellIdentifier = @"SelectedListCell";
@implementation MaMaShopViewController{
    MamaShareView *shareView;
    MamaShareView *singleShareView;
    UIView *backView;
    
    UIImageView *mamaHeadImageView;
    UILabel *mamaShopLabel;
    
    
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isRequest = NO;
    
    [self createNavigationBarWithTitle:@"我的精选" selecotr:@selector(backClickAction)];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(previewAction)];

    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItems = @[rightItem2, rightItem1];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 118;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
    
    [tableHeaderView addSubview:[self createTableHeadView]];
    
    
    
    self.tableView.tableHeaderView = tableHeaderView;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductSelectionListCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    
    [self createBackView];

    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros", Root_URL];
    [[AFHTTPRequestOperationManager manager] GET:url parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dealData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    NSString *shareString = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushop/customer_shop", Root_URL];
    NSLog(@"url = %@", shareString);
    [self downLoadWithURLString:shareString andSelector:@selector(fetchedShareData:)];
}

- (UIView *)createTableHeadView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"mamaJingxuan" owner:nil options:nil];
    NSLog(@"%@", views);
    
    NSLog(@"%@", [views[0] subviews]);
    UIView *view = views[0];
    
    view.frame = CGRectMake(0, 0, SCREENWIDTH, 180);
    
    UIView *whiteView = [view viewWithTag:200];
    mamaShopLabel = [view viewWithTag:100];
    whiteView.layer.cornerRadius = 30;
    mamaHeadImageView = [whiteView.subviews objectAtIndex:0];
    mamaHeadImageView.layer.cornerRadius = 27;
    mamaHeadImageView.layer.borderColor = [UIColor colorWithR:50 G:12 B:8 alpha:1].CGColor;
    mamaHeadImageView.layer.borderWidth = 1.5;
    mamaHeadImageView.layer.masksToBounds = YES;
    
    MMLOG(mamaHeadImageView);
    MMLOG(mamaShopLabel);
    
    
    
    
    return view;
    
    
    
    
}

- (void)fetchedShareData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    self.shopShareName = dic[@"shop_info"][@"name"];

    if ([dic[@"shop_info"][@"name"] class] == [NSNull class]) {
        self.shopShareName = @"小鹿妈妈";

    }
    self.shopShareLink = [dic[@"shop_info"] objectForKey:@"shop_link"];
    
    self.shopShareImage = [UIImage imageNamed:@"logo.png"];
    
    
    MMLOG(_shopShareLink);
    MMLOG(_shopShareName);
    
}



//预览
- (void)previewAction {
    ShopPreviousViewController *previous = [[ShopPreviousViewController alloc] init];
    [self.navigationController pushViewController:previous animated:YES];
}

//分享
- (void)shareAction {
    shareView = [MamaShareView new];
    
    
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MamaShareView" owner:shareView options:nil];
    shareView = array[0];
    shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    NSLog(@"shareView  = %@", shareView.subviews);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = self.view.bounds;
    }];
    backView.hidden = NO;
    [self.view addSubview:shareView];
    
    
    
    
    
    
    [self createShareButtonTarget];
}

- (void)createShareButtonTarget{
    UIView *view = (UIView *)[shareView.subviews objectAtIndex:0];
    view.layer.cornerRadius = 20;
    // shareView.cancleBtn.layer.masksToBounds = YES;
    shareView.cancleBtn.layer.cornerRadius = 20;
    shareView.cancleBtn.layer.borderWidth = 1;
    shareView.cancleBtn.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    
    [shareView.cancleBtn addTarget:self action:@selector(cancleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    shareView.weixinBtn.tag = 100;
    [shareView.weixinBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    shareView.friendBtn.tag = 101;
    shareView.qqBtn.tag = 102;
    shareView.spaceBtn.tag = 103;
    shareView.weiboBtn.tag = 104;
    shareView.fuzhiBtn.tag = 105;
    shareView.wxkuaizhaoBtn.tag = 106;
    shareView.wxkuaizhaoBtn.hidden = YES;
    shareView.friendkuaizhaoBtn.tag = 107;
    shareView.friendkuaizhaoBtn.hidden = YES;
    
    [shareView.weixinBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.friendBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.qqBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.spaceBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.weiboBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.fuzhiBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.wxkuaizhaoBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shareView.friendkuaizhaoBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
}

- (void)shareClicked:(UIButton *)button{
    if (self.shopShareLink == nil) {
        [self cancleBtnClicked:nil];
        return;
    }
    switch (button.tag) {
        case 100:{
            NSLog(@"微信");
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shopShareName image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            
            [self cancleBtnClicked:nil];
            break;
        }
        case 101:{
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shopShareName image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            
            
            [self cancleBtnClicked:nil];
            break;
        }
        case 102:{
            
            [UMSocialData defaultData].extConfig.qqData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.qqData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shopShareName image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
                       [self cancleBtnClicked:nil];
            
            break;
        }
        case 103:{
            [UMSocialData defaultData].extConfig.qzoneData.title = self.shopShareName;
            [UMSocialData defaultData].extConfig.qzoneData.url = self.shopShareLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.shopShareName image:self.shopShareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
                      [self cancleBtnClicked:nil];
            
            break;
        }
        case 104:{
          
            NSLog(@"微博");
            NSData *data = UIImagePNGRepresentation(self.shopShareImage);
            
            NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.shopShareName, self.shopShareLink];
            
            [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:data];
            
              [self cancleBtnClicked:nil];
            
            break;
        }
        case 105:{
            
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *str = self.shopShareLink;
            [pab setString:str];
            if (pab == nil) {
                [SVProgressHUD showErrorWithStatus:@"请重新复制"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"已复制"];
            }
            [self cancleBtnClicked:nil];
            
            NSLog(@"复制");
            
          
            [self cancleBtnClicked:nil];
            
            NSLog(@"复制");
            break;
        }
        case 106:{
            NSLog(@"微信快照");
            break;
        }
        case 107:{
            NSLog(@"朋友圈快照");
            break;
        }
        default:{
            NSLog(@"其他");
            break;
        }
            
    }
}

- (void)cancleSingleBtnClicked:(UIButton *)button{
    NSLog(@"quxiao");
    [UIView animateWithDuration:0.3 animations:^{
        singleShareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        
        [singleShareView removeFromSuperview];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        backView.hidden = YES;
    }];
}

- (void)cancleBtnClicked:(UIButton *)button{
    NSLog(@"quxiao");
    [UIView animateWithDuration:0.3 animations:^{
        shareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    } completion:^(BOOL finished) {
        
        [shareView removeFromSuperview];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        backView.hidden = YES;
    }];
    
    
    
}


- (void)createBackView{
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.alpha = 0.3;
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    backView.hidden = YES;
    
}

#pragma mark --数据处理
- (void)dealData:(NSArray *)data {
    for ( NSDictionary *pdt in data) {
        MaMaSelectProduct *productM = [[MaMaSelectProduct alloc] init];
        [productM setValuesForKeysWithDictionary:pdt];
        [self.dataArr addObject:productM];
    }
    [self.tableView reloadData];
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- uitableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductSelectionListCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MaMaSelectProduct *product = self.dataArr[indexPath.row];
    if (!cell) {
        cell = [[ProductSelectionListCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell fillMyChoice:product];
    return cell;
}

#pragma mark-- cell的代理方法
- (void)productSelectionListBtnClick:(ProductSelectionListCell *)cell btn:(UIButton *)btn {
    if (self.isRequest)return;
    self.isRequest = YES;
    //网络请求
    NSString *url = [NSString stringWithFormat:@"%@/rest/v1/pmt/cushoppros/remove_pro_from_shop", Root_URL];
    NSDictionary *parameters = @{@"product":cell.pdtID};
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray *rows = [NSArray arrayWithObject:indexPath];
    
    [[AFHTTPRequestOperationManager manager] POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.isRequest = NO;
        [self.dataArr removeObject:cell.pdtModel];
        [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationRight];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"店铺－－Error: %@", error);
    }];

}

- (void)productSelectionShareClick:(ProductSelectionListCell *)cell btn:(UIButton *)btn{
  //  NSLog(@"share");
    singleShareView = [MamaShareView new];
    
    NSLog(@"id = %@", cell.pdtID);
    
    self.productUrl = [NSString stringWithFormat:@"%@/rest/v1/share/product?product_id=%@", Root_URL, cell.pdtID];
    NSLog(@"url = %@", self.productUrl);
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.productUrl]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    MMLOG(dic);
    self.productName = dic[@"title"];
    self.productImage = [UIImage imagewithURLString:dic[@"share_img"]];
    self.productLink = dic[@"share_link"];
    self.productDes = dic[@"desc"];
    
    
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MamaShareView" owner:singleShareView options:nil];
    singleShareView = array[0];
    singleShareView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
 //   NSLog(@"shareView  = %@", singleShareView.subviews);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        singleShareView.frame = self.view.bounds;
    }];
    backView.hidden = NO;
    [self.view addSubview:singleShareView];
    
    
    
    
    
    
    [self createShareSingleTarget];
}

- (void)createShareSingleTarget{
    
    UIView *view = (UIView *)[singleShareView.subviews objectAtIndex:0];
    view.layer.cornerRadius = 20;
    // shareView.cancleBtn.layer.masksToBounds = YES;
    singleShareView.cancleBtn.layer.cornerRadius = 20;
    singleShareView.cancleBtn.layer.borderWidth = 1;
    singleShareView.cancleBtn.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    
    [singleShareView.cancleBtn addTarget:self action:@selector(cancleSingleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    singleShareView.weixinBtn.tag = 100;
    singleShareView.friendBtn.tag = 101;
    singleShareView.qqBtn.tag = 102;
    singleShareView.spaceBtn.tag = 103;
    singleShareView.weiboBtn.tag = 104;
    singleShareView.fuzhiBtn.tag = 105;
    singleShareView.wxkuaizhaoBtn.tag = 106;
    singleShareView.wxkuaizhaoBtn.hidden = YES;
    singleShareView.friendkuaizhaoBtn.tag = 107;
    singleShareView.friendkuaizhaoBtn.hidden = YES;
    
    [singleShareView.weixinBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.friendBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.qqBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.spaceBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.weiboBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.fuzhiBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.wxkuaizhaoBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    [singleShareView.friendkuaizhaoBtn addTarget:self action:@selector(singleShareClicked:) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)singleShareClicked:(UIButton *)button{
    
    switch (button.tag) {
        case 100:{
            NSLog(@"单品微信");
            
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.productName;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.productLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.productDes image:self.productImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];

            
            [self cancleSingleBtnClicked:nil];
            break;
        }
        case 101:{
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.productName;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.productLink;
            NSLog(@"link = %@", self.productLink);
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.productDes image:self.productImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            
            
            
            [self cancleSingleBtnClicked:nil];
            break;
        }
        case 102:{
            
            [UMSocialData defaultData].extConfig.qqData.title = self.productName;
            [UMSocialData defaultData].extConfig.qqData.url = self.productLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.productDes image:self.productImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            [self cancleSingleBtnClicked:nil];
            
            break;
        }
        case 103:{
            
            [UMSocialData defaultData].extConfig.qzoneData.title = self.productName;
            [UMSocialData defaultData].extConfig.qzoneData
            .url = self.productLink;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.productDes image:self.productImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                
            }];
            [self cancleSingleBtnClicked:nil];
            
            break;
        }
        case 104:{
            NSData *data = UIImagePNGRepresentation(self.productImage);
            
            NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.productName, self.productLink];
            
            [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:data];
            

            
            [self cancleSingleBtnClicked:nil];
            
            break;
        }
        case 105:{
            
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            NSString *str = self.productLink;
            [pab setString:str];
            if (pab == nil) {
                [SVProgressHUD showErrorWithStatus:@"请重新复制"];
            }else
            {
                [SVProgressHUD showSuccessWithStatus:@"已复制"];
            }
            
            [self cancleSingleBtnClicked :nil];
            
            NSLog(@"复制");
            break;
        }
        case 106:{
            NSLog(@"微信快照");
            break;
        }
        case 107:{
            NSLog(@"朋友圈快照");
            break;
        }
        default:{
            NSLog(@"其他");
            break;
        }
            
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
