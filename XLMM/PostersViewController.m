//
//  ChildViewController.m
//  XLMM
//
//  Created by younishijie on 15/8/1.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "PostersViewController.h"
#import "PeopleCollectionCell.h"
#import "MMClass.h"
#import "CollectionModel.h"
#import "DetailsModel.h"
#import "CartViewController.h"
#import "PromoteModel.h"

#import "MMDetailsViewController.h"
#import "MMCollectionController.h"

#import "MJRefresh.h"
#import "WXApi.h"
#import "LogInViewController.h"

#import "UIViewController+NavigationBar.h"

#import "YoumengShare.h"
#import "SendMessageToWeibo.h"
#import "SVProgressHUD.h"

static NSString * ksimpleCell = @"simpleCell";

@interface PostersViewController ()<UIAlertViewDelegate> {
    
    NSMutableArray *_ModelListArray;
    UIActivityIndicatorView *activityIndicator;
    BOOL isOrder;
    NSInteger goodsCount;
    UILabel *countLabel;
    BOOL _isFirst;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *orderDataArray;
//遮罩层
@property (nonatomic, strong)UIView *backView;
//分享页面
@property (nonatomic, strong) YoumengShare *youmengShare;
//分享参数
@property (nonatomic, strong)NSString *titleStr;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)UIImage *shareImage;
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSData *imageD;


@end

@implementation PostersViewController

- (YoumengShare *)youmengShare {
    if (!_youmengShare) {
        self.youmengShare = [[YoumengShare alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _youmengShare;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    

}


- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;

    [super viewDidAppear:animated];
    if (_isFirst) {
        //集成刷新控件
        
        [self setupRefresh];
        self.childCollectionView.footerHidden=NO;
        self.childCollectionView.headerHidden=NO;
        [self.childCollectionView headerBeginRefreshing];
        _isFirst = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupRefresh{
    
    
    
    [self.childCollectionView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //[_childCollectionView addFooterWithTarget:self action:@selector(footerRereshing)];
    _childCollectionView.headerPullToRefreshText = NSLocalizedString(@"下拉可以刷新", nil);
    _childCollectionView.headerReleaseToRefreshText = NSLocalizedString (@"松开马上刷新",nil);
    _childCollectionView.headerRefreshingText = NSLocalizedString(@"正在帮你刷新中", nil);
    
    _childCollectionView.footerPullToRefreshText = NSLocalizedString(@"上拉可以加载更多数据", nil);
    _childCollectionView.footerReleaseToRefreshText = NSLocalizedString(@"松开马上加载更多数据", nil);
    _childCollectionView.footerRefreshingText = NSLocalizedString(@"正在帮你加载中", nil);
    
}

- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self reload];
        sleep(1.5);
        [_childCollectionView headerEndRefreshing];
        
    });
}


- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self loadMore];
        sleep(1.5);
        [_childCollectionView footerEndRefreshing];
        
    });
}

- (void)reload
{
    NSLog(@"reload");
    [self downloadData];
    
}

- (void)loadMore
{
    NSLog(@"loadmore");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    // Do any additional setup after loading the view from its nib.
    isOrder = NO;
    _isFirst = YES;
    _ModelListArray = [[NSMutableArray alloc] init];
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self.view addSubview:[[UIView alloc] init]];
    [self setLayout];
  
    self.view.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64);
    
    //  self.childCollectionView.bounces = NO;
    [self.childCollectionView registerClass:[PeopleCollectionCell class] forCellWithReuseIdentifier:ksimpleCell];
    self.childCollectionView.backgroundColor = [UIColor colorWithR:243 G:243 B:244 alpha:1];
    
    // [self downloadData];
   // [self createNavigationBarWithTitle:self.titleName selecotr:@selector(backBtnClicked:)];
    [self createInfo];
}

- (void)createInfo{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = self.titleName;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_image.png"]];
    imageView.frame = CGRectMake(-4, 14, 22, 22);
    [button addSubview:imageView];
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    NSString *imageName = nil;
    imageName = @"shareIconImage2.png";
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView1.frame = CGRectMake(20, 10, 25, 25);
    [button1 addSubview:imageView1];
    [button1 addTarget:self action:@selector(sharedMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharedMethod)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
}



- (void)sharedMethod{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin]) {
        
    } else {
        LogInViewController *loginVC = [[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        
        return;
    }
    NSString *shareUrlString = @"http://m.xiaolu.so/rest/v1/share/today";
    
    NSData *shareData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareUrlString]];
    if (shareData == nil) {
        return;
    }
    NSError *shareError = nil;
    NSDictionary *shareDic = [NSJSONSerialization JSONObjectWithData:shareData options:kNilOptions error:&shareError];
    
    
#pragma mark -- weixin share
    NSString *shareTitle = [shareDic objectForKey:@"title"];
    NSString *shareDesc = [shareDic objectForKey:@"desc"];
    NSString *shareLink = [shareDic objectForKey:@"share_link"];
    
    NSString *imageUrlString = [shareDic objectForKey:@"share_img"];
    NSData *imageData = nil;

    do {
        NSLog(@"下载图片");
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
        if (imageData != nil) {
           
            NSLog(@"图片下载成功");
            break;
        }
        NSLog(@"图片下载失败，重新下载！");
       
    } while (YES);

    UIImage *image = [UIImage imageWithData:imageData];
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.backView];
    [self.backView addSubview:self.youmengShare];
    self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    
    // 点击分享后弹出自定义的分享界面
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240);
    }];
    
    
    // 分享页面事件处理
    [self.youmengShare.cancleShareBtn addTarget:self action:@selector(cancleShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.weixinShareBtn addTarget:self action:@selector(weixinShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.friendsShareBtn addTarget:self action:@selector(friendsShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqshareBtn addTarget:self action:@selector(qqshareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqspaceShareBtn addTarget:self action:@selector(qqspaceShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.weiboShareBtn addTarget:self action:@selector(weiboShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.linkCopyBtn addTarget:self action:@selector(linkCopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.titleStr = shareTitle;
    self.des = shareDesc;
    self.shareImage = image;
    self.url = shareLink;
    self.imageD = imageData;
}

#pragma mark --分享按钮事件
- (void)cancleShareBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}
- (void)weixinShareBtnClick:(UIButton *)btn{
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
    
    [self cancleShareBtnClick:nil];

}

- (void)friendsShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
    
    [self cancleShareBtnClick:nil];
    
}

- (void)qqshareBtnClick:(UIButton *)btn {
//    BOOL isInstall = 0;
//    isInstall = [QQApiInterface isQQInstalled];
//    NSLog(@"%d", isInstall);
//    if ( !isInstall ) {
////        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertView *alterView = [[UIAlertView alloc]  initWithTitle:@"温馨提示" message:@"您的设备没有安装QQ" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alterView show];
//        NSLog(@"------------");
//        return;
//    }
    
    [UMSocialData defaultData].extConfig.qqData.url = self.url;
    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
    
    [self cancleShareBtnClick:nil];
}

- (void)qqspaceShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr  ;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.des image:self.shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
    [self cancleShareBtnClick:nil];
}

- (void)weiboShareBtnClick:(UIButton *)btn {
    NSString *sinaContent = [NSString stringWithFormat:@"%@%@",self.titleStr, self.url];
    [SendMessageToWeibo sendMessageWithText:sinaContent andPicture:self.imageD];
    
    [self cancleShareBtnClick:nil];
}

- (void)linkCopyBtnClick:(UIButton *)btn {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *str = self.url;
    [pab setString:str];
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"请重新复制"];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
    }
    [self cancleShareBtnClick:nil];
}


- (void)backBtnClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake((SCREENWIDTH - 4)/2, (SCREENWIDTH - 4)/2*7/6 + 60)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; flowLayout.sectionInset = UIEdgeInsetsMake(4, 0, 0, 0);
    [self.childCollectionView setCollectionViewLayout:flowLayout];
    self.childCollectionView.showsVerticalScrollIndicator = NO;
}


- (void)downLoadWithURLString:(NSString *)url andSelector:(SEL)aSeletor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data == nil) {
            return ;
        }
        [self performSelectorOnMainThread:aSeletor withObject:data waitUntilDone:YES];
        
    });
}

- (void)downloadData{
    [self downLoadWithURLString:self.urlString andSelector:@selector(fatchedChildListData:)];
    
    NSLog(@"url = %@", self.urlString);
}

- (void)fatchedChildListData:(NSData *)responseData{
    NSError *error;
    //NSLog(@"responsedata = %@", responseData);
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"数据解析失败");
        return;
    }
    NSArray *array = [json objectForKey:@"results"];
    if (array.count == 0) {
        NSLog(@"数据解析失败");
        return;
    }
    
    [self.dataArray removeAllObjects];
    
    
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [self fillModel:ladyInfo];
        
        [_dataArray addObject:model];
        
    }
    
    
    [self.childCollectionView reloadData];
    
    
}

#pragma mark  -----CollectionViewDelete----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isOrder) {
        return self.orderDataArray.count;
        
    }else{
        return self.dataArray.count;
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREENWIDTH-4)/2, (SCREENWIDTH-4)/2 *8/6+ 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCollectionCell *cell = (PeopleCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ksimpleCell forIndexPath:indexPath];
    
    if (isOrder) {
        PromoteModel *model = [_orderDataArray objectAtIndex:indexPath.row];
        
        [cell fillData:model];
        
    }else{
        PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        [cell fillData:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == 0) {
        return;
    }
    if (isOrder) {
        
        PromoteModel *model = [_orderDataArray objectAtIndex:indexPath.row];
        
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailsVC.urlString = string;
            detailsVC.childClothing = self.childClothing;
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSLog(@"没有集合页面");
                NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailsVC.urlString = string;
                 detailsVC.childClothing = self.childClothing;
                [self.navigationController pushViewController:detailsVC animated:YES];
                
            } else {
                NSString * string = [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json", Root_URL, [model.productModel objectForKey:@"id"]];
                NSLog(@"stringURL -> = %@", string);
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = string;
                 collectionVC.childClothing = self.childClothing;
                [self.navigationController pushViewController:collectionVC animated:YES];
                
                
            }

        }
    } else {
        PromoteModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (model.productModel == nil) {
            NSLog(@"没有集合页面");
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
            MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
            detailsVC.urlString = string;
             detailsVC.childClothing = self.childClothing;
            [self.navigationController pushViewController:detailsVC animated:YES];
        } else{
            if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
                NSLog(@"没有集合页面");
                NSString *string = [NSString stringWithFormat:@"%@/rest/v1/products/%@/details.json",Root_URL,model.ID ];
                MMDetailsViewController *detailsVC = [[MMDetailsViewController alloc] initWithNibName:@"MMDetailsViewController" bundle:nil];
                detailsVC.urlString = string;
                 detailsVC.childClothing = self.childClothing;
                [self.navigationController pushViewController:detailsVC animated:YES];
                
                
            } else {
                NSString * string = [NSString stringWithFormat:@"%@/rest/v1/products/modellist/%@.json", Root_URL, [model.productModel objectForKey:@"id"]];
                NSLog(@"stringURL -> = %@", string);
                MMCollectionController *collectionVC = [[MMCollectionController alloc] initWithNibName:@"MMCollectionController" bundle:nil];
                collectionVC.urlString = string;
                 collectionVC.childClothing = self.childClothing;
                [self.navigationController pushViewController:collectionVC animated:YES];
            }
        }
    }
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}




- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 1) {
        NSLog(@"推荐排序");
        isOrder = NO;
        [self.jiageButton setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
        [self.tuijianButton setTitleColor:[UIColor colorWithR:252 G:185 B:22 alpha:1] forState:UIControlStateNormal];
        
        [self.childCollectionView reloadData];
        
        
        
        
    } else if (sender.tag == 2){
        NSLog(@"价格排序");
        isOrder = YES;
        
        [self downloadOrderData];
        
        [self.tuijianButton setTitleColor:[UIColor colorWithR:74 G:74 B:74 alpha:1] forState:UIControlStateNormal];
        [self.jiageButton setTitleColor:[UIColor colorWithR:252 G:185 B:22 alpha:1] forState:UIControlStateNormal];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.backgroundColor = [UIColor clearColor];
        [activityIndicator startAnimating];
        activityIndicator.center = CGPointMake(SCREENWIDTH/2, SCREENWIDTH/2 - 80);
        [self.childCollectionView addSubview:activityIndicator];
        
        [self.childCollectionView reloadData];
    }
    
}

- (void)downloadOrderData{
    [self downLoadWithURLString:self.orderUrlString andSelector:@selector(fatchedOrderLadyListData:)];
}

- (void)fatchedOrderLadyListData:(NSData *)responseData{
    NSError *error;
    self.orderDataArray = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    // MMLOG(json);
    NSArray *array = [json objectForKey:@"results"];
    for (NSDictionary *ladyInfo in array) {
        PromoteModel *model = [self fillModel:ladyInfo];
        
        
        [self.orderDataArray addObject:model];
        
    }
    [activityIndicator removeFromSuperview];
    [self.childCollectionView reloadData];
}

- (PromoteModel *)fillModel:(NSDictionary *)dic{
    PromoteModel *model = [PromoteModel new];
    model.ID = [dic objectForKey:@"id"];
    
    model.name = [dic objectForKey:@"name"];
    model.Url = [dic objectForKey:@"url"];
    model.agentPrice = [dic objectForKey:@"lowest_price"];
    model.stdSalePrice = [dic objectForKey:@"std_sale_price"];
    model.outerID = [dic objectForKey:@"outer_id"];
    model.isSaleopen = [dic objectForKey:@"is_saleopen"];
    model.isSaleout = [dic objectForKey:@"is_saleout"];
    model.category = [dic objectForKey:@"category"];
    model.remainNum = [dic objectForKey:@"remain_num"];
    model.saleTime = [dic objectForKey:@"sale_time"];
    model.wareBy = [dic objectForKey:@"ware_by"];
    model.productModel = [dic objectForKey:@"product_model"];
     
    
    if ([model.productModel class] == [NSNull class]) {
        model.picPath = [dic objectForKey:@"head_img"];
        model.productModel = nil;
        NSLog(@"productModel is null.");
        return model;
    }

    if ([[model.productModel objectForKey:@"is_single_spec"] boolValue] == YES) {
        //  NSLog(@"没有集合页");
        model.picPath = [dic objectForKey:@"head_img"];
    } else{
        model.picPath = [[model.productModel objectForKey:@"head_imgs"] objectAtIndex:0];
        model.name = [model.productModel objectForKey:@"name"];
        //  NSLog(@"----集合页----");
    }
    return model;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
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
