//
//  JMPushingDaysController.m
//  XLMM
//
//  Created by zhang on 16/10/10.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMPushingDaysController.h"
#import "WXApi.h"
#import "JMPushSaveModel.h"
#import "NSArray+Reverse.h"
#import "JMPhotoBrowesView.h"
#import "JMSystemPermissionsManager.h"      
#import "JMSharePicModel.h"
#import "NSString+CSCommon.h"
#import "JMPushingDaysCell.h"
#import "JMPushingDaysHeaderView.h"
#import "JMPushingDaysFooterView.h"
#import "CountdownView.h"
#import "JMStoreManager.h"

#define CELLWIDTH (([UIScreen mainScreen].bounds.size.width - 24)/3)

static NSString *JMPushingDaysCellIdentifier       = @"JMPushingDaysCellIdentifier";
static NSString *JMPushingDaysHeaderViewIdentifier = @"JMPushingDaysHeaderViewIdentifier";
static NSString *JMPushingDaysFooterViewIdentifier = @"JMPushingDaysFooterViewIdentifier";

@interface JMPushingDaysController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate, JMPhotoBrowesViewDatasource, JMPhotoBrowesViewDelegate, JMPushingDaysFooterViewDelegate> {
    NSTimer         *_theTimer;               // 定时器 (整点刷新)
    BOOL            _isPullDown;              // 下拉标志
    BOOL            _isLoadMore;              // 上拉标志
    NSString        *_nextPageUrlString;      // 分页数据(下一页)
    NSString        *_qrCodeUrlString;        // 二维码图片URL
    NSInteger       _qrCodeRequestDataIndex;  // 二维码图片请求次数
    NSArray         *imageUrlArray;           // 图片预览数组
    NSNumber        *_currentSaveIndex;       // 当前保存图片 的ID 标志位
    NSMutableArray  *sharImageArray;          // 分享图片的数组
    BOOL            _isNeedAleartMessage;     // 是否需要弹出提示框
    NSString        *_getBeforeDayFive;
    NSInteger       _cellNum;
    
}
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) UIView                *watchesView;
@property (nonatomic, strong) UIView                *bottomView;
@property (nonatomic, strong) CountdownView         *countdowmView;

@property (nonatomic, strong) NSMutableArray        *dataSource;
@property (nonatomic, strong) NSMutableArray        *currentArr;
@property (nonatomic, strong) NSMutableDictionary   *imageDict;
@property (nonatomic, strong) NSMutableArray        *images;
@property (nonatomic, strong) JMPushSaveModel       *pushSaveModel;
@property (nonatomic, strong) JMSharePicModel       *picModel;

@end

@implementation JMPushingDaysController

#pragma mark -- 懒加载 --
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1.5f;
        layout.minimumLineSpacing = 1.5f;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JMPushingDaysCell class] forCellWithReuseIdentifier:JMPushingDaysCellIdentifier];
        [_collectionView registerClass:[JMPushingDaysHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:JMPushingDaysHeaderViewIdentifier];
        [_collectionView registerClass:[JMPushingDaysFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:JMPushingDaysFooterViewIdentifier];
        NSInteger hour = [[NSString getCurrentTimeWithHour] integerValue];
        if (hour >= 6) {
            _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else {
            _collectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
            [_collectionView addSubview:self.watchesView];
        }
        
    }
    return _collectionView;
}
- (UIView *)watchesView {
    if (!_watchesView) {
        _watchesView = [UIView new];
        _watchesView.frame           = CGRectMake(0, -200, SCREENWIDTH, 200);
        _watchesView.backgroundColor = [UIColor backgroundlightGrayColor];
        [_watchesView addSubview:self.bottomView];
    }
    return _watchesView;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 2, SCREENWIDTH, 180)];
        _bottomView.backgroundColor = [UIColor backgroundlightGrayColor];
        [_bottomView addSubview:self.countdowmView];
    }
    return _bottomView;
}
- (UIView *)countdowmView {
    if (!_countdowmView) {
        _countdowmView = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        _countdowmView.center = CGPointMake(SCREENWIDTH * 0.5, 100);
        _theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:_countdowmView selector:@selector(updateTimeView) userInfo:nil repeats:YES];
    }
    return _countdowmView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableDictionary *)imageDict {
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}
- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}
- (JMSharePicModel *)picModel {
    if (!_picModel) {
        _picModel = [[JMSharePicModel alloc] init];
    }
    return _picModel;
}
- (JMPushSaveModel *)pushSaveModel {
    if (!_pushSaveModel) {
        _pushSaveModel = [[JMPushSaveModel alloc] init];
    }
    return _pushSaveModel;
}

#pragma mark -- 生命周期函数 --
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMPushingDaysController"];
    NSArray *arr = [JMPushSaveModel findAll];
    for (int i = 0; i < arr.count; i++) {
        self.pushSaveModel = arr[i];
        if ([self compareData:_getBeforeDayFive SaveData:self.pushSaveModel.currentTime] == -1) {
            // 删除此条数据
            [JMPushSaveModel deleteObjectsByCriteria:[self.pushSaveModel.pushID stringValue]];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMPushingDaysController"];
    if ([_theTimer isValid]) {
        [_theTimer invalidate];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([NSString isStringEmpty:self.navTitle]) {
        self.navTitle = @"每日推送";
    }
    [self createNavigationBarWithTitle:self.navTitle selecotr:@selector(backClicked)];
    _qrCodeRequestDataIndex = 0;
    sharImageArray = [NSMutableArray array];
    _isNeedAleartMessage = YES;
    _getBeforeDayFive = [NSString getBeforeDay:-5];
    
    [self.view addSubview:self.collectionView];
    [self timeRefresh];
    _qrCodeUrlString = [JMStoreManager getDataString:@"qrCodeUrlString.txt"];
    if ([NSString isStringEmpty:_qrCodeUrlString]) {
        [self loaderweimaData];
    }else {
        [self loadPicData];
    }
    [self createPullHeaderRefresh];
    [self createPullFooterRefresh];
    [self.collectionView.mj_header beginRefreshing];
    
}
#pragma mrak 刷新界面
- (void)createPullHeaderRefresh {
    kWeakSelf
    self.collectionView.mj_header = [MJAnimationHeader headerWithRefreshingBlock:^{
        _isPullDown = YES;
        [self.collectionView.mj_footer resetNoMoreData];
        [weakSelf loadPicData];
    }];
}
- (void)createPullFooterRefresh {
    kWeakSelf
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [weakSelf loadPicMoreData];
    }];
}
- (void)endRefresh {
    if (_isPullDown) {
        _isPullDown = NO;
        [self.collectionView.mj_header endRefreshing];
    }
    if (_isLoadMore) {
        _isLoadMore = NO;
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark -- 网络请求, 数据处理 --
- (void)loaderweimaData {     // 加载二维码网络请求
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v2/qrcode/get_wxpub_qrcode");
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        [self fetchErweimaData:responseObject];
        [self loadPicData];
    } WithFail:^(NSError *error) {
        _qrCodeRequestDataIndex ++;
        if (_qrCodeRequestDataIndex <= 3) {
            [self performSelector:@selector(loaderweimaData) withObject:nil afterDelay:0.5];
        }else {
            [self loadPicData];
        }
    } Progress:^(float progress) {
    }];
}
- (void)loadPicData {
    if ([NSString isStringEmpty:self.pushungDaysURL]) {
        self.pushungDaysURL = CS_DSTRING(Root_URL,@"/rest/v1/pmt/ninepic");
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:self.pushungDaysURL WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [self endRefresh];
            return ;
        }
        NSArray *arrPic;
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"results"]) {
            arrPic = responseObject[@"results"];
            _nextPageUrlString = responseObject[@"next"];
        }else {
            arrPic = responseObject;
        }
        [self.dataSource removeAllObjects];
        [self requestData:arrPic];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showError:@"获取信息失败"];
        [self endRefresh];
    } Progress:^(float progress) {
    }];
}
- (void)loadPicMoreData {
    if ([NSString isStringEmpty:_nextPageUrlString]) {
        [self endRefresh];
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return ;
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:_nextPageUrlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) return;
        NSArray *arrPic;
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject objectForKey:@"results"]) {
            arrPic = responseObject[@"results"];
            _nextPageUrlString = responseObject[@"next"];
        }else {
        }
        [self requestData:arrPic];
        [self endRefresh];
    } WithFail:^(NSError *error) {
        [self endRefresh];
    } Progress:^(float progress) {
        
    }];
}
// 统计保存数
- (void)statisticsSaveNum:(NSNumber *)piID {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    parameDic[@"save_times"] = @1;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/%@",Root_URL,piID];
    [JMHTTPManager requestWithType:RequestTypePATCH WithURLString:urlString WithParaments:parameDic WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)fetchErweimaData:(NSDictionary *)dict {
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 0) {
        _qrCodeUrlString = dict[@"qrcode_link"];
    }else {
        [MBProgressHUD showWarning:dict[@"info"]];
    }
}
- (void)requestData:(NSArray *)data {
    if (data.count == 0) {
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 90, SCREENHEIGHT * 0.5 - 90, 180, 180)];
        [self.view addSubview:timeView];
        UIImageView *timeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
        timeImageV.image = [UIImage imageNamed:@"shizhong.png"];
        [timeView addSubview:timeImageV];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 120, 120)];
        title.text = @"休假中...";
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor lightGrayColor];
        title.textAlignment = NSTextAlignmentCenter;
        [timeView addSubview:title];
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    for (NSDictionary *oneTurns in data) {
        NSMutableArray *muArray = [NSMutableArray array];
        NSArray *picArr = oneTurns[@"pic_arry"];
        if ([NSArray isEmptyForArray:picArr]) {
        }else {
            [muArray addObjectsFromArray:picArr];
        }
        
        NSInteger countNum = muArray.count;
        if (![NSString isStringEmpty:_qrCodeUrlString] && [oneTurns[@"show_qrcode"] boolValue]) {
            if (countNum < 9) {
                [muArray addObject:_qrCodeUrlString];
            }else {
                [muArray replaceObjectAtIndex:4 withObject:_qrCodeUrlString];
            }
        }
        JMSharePicModel *sharePic = [JMSharePicModel mj_objectWithKeyValues:oneTurns];
        sharePic.pic_arry = muArray;
        [self.dataSource addObject:sharePic];
    }
    [self.collectionView reloadData];
}

#pragma mark -- UICollectionView 代理方法 --
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JMSharePicModel *picModel = self.dataSource[section];
    return picModel.pic_arry.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMPushingDaysCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JMPushingDaysCellIdentifier forIndexPath:indexPath];
    JMSharePicModel *picModel = self.dataSource[indexPath.section];
    NSString *url = CS_STRING(picModel.pic_arry[indexPath.row]);
    if (picModel.show_qrcode) {
        NSInteger countNum = picModel.pic_arry.count;
        NSInteger codeNum = countNum < 9 ? countNum - 1 : 4;
        if ((codeNum != indexPath.row) && ![NSString isStringEmpty:url]) {
            url = [url imageGoodsOrderCompression];
        }
    }else {
        url = [url imageGoodsOrderCompression];
    }
    NSString *sectionRow = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.imageDict setObject:image forKey:sectionRow];
        }
    }];
    [self.imageDict setObject:cell.cellImageView.image forKey:sectionRow];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMSharePicModel *picModel = self.dataSource[indexPath.section];
    NSInteger cellNum = picModel.pic_arry.count;
    if (cellNum == 1) {
        return CGSizeMake(CELLWIDTH + 30, CELLWIDTH + 80);
    }
    return CGSizeMake(CELLWIDTH, CELLWIDTH);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.images removeAllObjects];
    JMSharePicModel *picModel = self.dataSource[indexPath.section];
    imageUrlArray = [picModel.pic_arry copy];
    for (int i = 0; i < imageUrlArray.count; i++) {
        NSString *sectionRot = [NSString stringWithFormat:@"%ld%d",indexPath.section,i];
        UIImage *image = self.imageDict[sectionRot];
        if (image == nil) {
            image = [UIImage imageNamed:@"zhanwei"];
        }
        [self.images addObject:image];
    }
    [JMPhotoBrowesView showPhotoBrowesWihtCurrentImageIndex:indexPath.row ImageCount:imageUrlArray.count DataSource:self];
}
- (UIImage *)photoBrowser:(JMPhotoBrowesView *)browser placeholderImageForIndex:(NSInteger)index {
    return self.images[index];
}
- (NSURL *)photoBrowser:(JMPhotoBrowesView *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSString *picUrlString = imageUrlArray[index];
    if ([NSString isStringEmpty:picUrlString]) {
        return nil;
    }
    NSString *picString = [picUrlString imageNormalCompression];
    return [NSURL URLWithString:picString];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JMPushingDaysHeaderView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:JMPushingDaysHeaderViewIdentifier forIndexPath:indexPath];
        JMSharePicModel *picModel = self.dataSource[indexPath.section];
        headerV.model = picModel;
        return headerV;
    }else{
        JMPushingDaysFooterView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:JMPushingDaysFooterViewIdentifier forIndexPath:indexPath];
        JMSharePicModel *picModel = self.dataSource[indexPath.section];
        footerV.delegate = self;
        footerV.model = picModel;
        return footerV;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    JMSharePicModel *picModel = self.dataSource[section];
    return CGSizeMake(SCREENWIDTH, picModel.headerHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 75);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JMSharePicModel *picModel = self.dataSource[section];
    NSInteger cellNum = picModel.pic_arry.count;
    if (cellNum == 4) {
        return UIEdgeInsetsMake(5, 10, 5, CELLWIDTH + 10);
    }
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark -- item的尾部视图的代理回调事件处理 --
- (void)composeWithShareModel:(JMSharePicModel *)model Button:(UIButton *)button {
    if (button.tag == 100) { // 保存图片
        [self saveImageToIphone:model];
    }else {  // 复制文案
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:model.descriptionTitle];
        if (pab == nil) {
            [MobClick event:@"DaysPush_fail"];
            [MBProgressHUD showError:@"出错啦~! 请重新复制文案"];
            return ;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小鹿小贴士" message:@"亲爱的小鹿妈妈,现在文案复制成功了哦~可以去朋友圈粘贴回复啦。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [MobClick event:@"DaysPush_success"];
        }
    }
    
}
#pragma mark -- 保存图片到手机 --
- (void)saveImageToIphone:(JMSharePicModel *)picModel {
    if ([[JMSystemPermissionsManager sharedManager] requestAuthorization:KALAssetsLibrary] == NO) {
        return ;
    }else {
        _currentSaveIndex = picModel.piID;
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:picModel.descriptionTitle];
        if (pab == nil) {
            [MobClick event:@"DaysPush_fail"];
            [MBProgressHUD showError:@"出错啦~! 请重新复制文案"];
            return ;
        }else{
            [MobClick event:@"DaysPush_success"];
        }
        NSArray *arr = [JMPushSaveModel findAll];
        for (int i = 0; i < arr.count; i++) {
            self.pushSaveModel = arr[i];
            if ([self.pushSaveModel.pushID isEqualToNumber:_currentSaveIndex]) {
                NSInteger count = self.pushSaveModel.imageArray.count;
                for (int j = 0; j < count; j++) {
                    UIImage *image = [UIImage imageWithData:self.pushSaveModel.imageArray[j]];
                    [sharImageArray addObject:image];
                }
                if (_isNeedAleartMessage) {
                    [self alertMessage];
                }else {
                    [self UIActivityMessage];
                }
                return ;
            }
        }
        [MBProgressHUD showLoading:@"文案复制完成，正在保存图片..."];
        if (self.currentArr == nil) {
            self.currentArr = [picModel.pic_arry mutableCopy];
            [self downLoadImage:picModel];
        }else if (self.currentArr.count > 0){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showLoading:@"亲~ 慢点! (*^__^*) " ToView:self.view];
            [self saveNextimage];
        }else {
            [self.currentArr addObjectsFromArray:picModel.pic_arry];
            //            [self saveNext];
            [self downLoadImage:picModel];
        }
    }
}
#pragma mark -- 下载图片到手机并保存到数据库中 --
- (void)downLoadImage:(JMSharePicModel *)picModel {
    [self statisticsSaveNum:picModel.piID];
    [self saveNextimage];
    NSArray *curArr = [self.currentArr copy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *indexArray = [NSMutableArray array];
    NSInteger curArrCount = curArr.count;
    for (int i = 0; i < curArrCount; i++) {
        NSString *picUrl = curArr[i];
        if ([NSString isStringEmpty:picUrl]) {
            continue;
        }
        NSString *indexString = [picUrl md5];
        [indexArray addObject:indexString];
        if (picModel.show_qrcode) {
            if (curArrCount < 9) {
                if (i == (curArrCount - 1)) {
                }else {
                    picUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg", picUrl]; // /quality/90
                }
            }else {
                if (i == 4) {
                }else {
                    picUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg", picUrl]; // /quality/90
                }
            }
        }else {
            picUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg", picUrl]; // /quality/90
        }
        
        dispatch_group_async(group, queue, ^{
            [UIImage imagewithURLString:picUrl Index:indexString];
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for (int i = 0 ; i < curArr.count; i++) {
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            //计算出文件的全路径
            NSString *file = [cachesPath stringByAppendingPathComponent:indexArray[i]];
            UIImage *image = [UIImage imageWithContentsOfFile:file];
            NSData *data = UIImageJPEGRepresentation(image, 0.5);
            UIImage *newImage = [UIImage imageWithData:data];
            newImage == nil ? : [sharImageArray addObject:newImage];
            [JMStoreManager removeFileByFileName:indexArray[i]];
        }
        
        NSArray *array = [NSArray array];
        NSMutableArray *muArrau = [NSMutableArray array];
        array = [sharImageArray copy];
        for (int i = 0; i < array.count; i++) {
            NSData *data = UIImageJPEGRepresentation(array[i], 0.5);
            NSLog(@"sharImageArray ------ > %ld",data.length);
            [muArrau addObject:data];
        }
        self.pushSaveModel.pushID = _currentSaveIndex;
        self.pushSaveModel.imageArray = [muArrau copy];
        self.pushSaveModel.currentTime = [NSString getCurrentTime];
        [self.pushSaveModel save];
        [MBProgressHUD hideHUD];
        if ([WXApi isWXAppInstalled]) {
            [MBProgressHUD hideHUD];
            if (_isNeedAleartMessage) {
                [self alertMessage];
            }else {
                [self UIActivityMessage];
            }
        }else {
            [MBProgressHUD showWarning:@"没有安装微信哦~"];
        }
    });
}
/// 循环保存图片到相册
- (void)saveNextimage {
    NSInteger countNum = self.currentArr.count;
    if (countNum > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_BLOCK_DETACHED, 0), ^{
            NSString *picImageUrl = self.currentArr[0];
            if ([picImageUrl hasPrefix:Root_URL]) {
                picImageUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg", picImageUrl]; // /quality/90
            }else {
            }
            UIImageWriteToSavedPhotosAlbum([UIImage imagewithURLString:picImageUrl], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        });
    }else {
        [MBProgressHUD hideHUD];
    }
}
-(void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        if ([[JMSystemPermissionsManager sharedManager] requestAuthorization:KALAssetsLibrary] == NO) {
            [MBProgressHUD hideHUD];
        }else {
            if (self.currentArr.count != 0) {
                [self.currentArr removeObjectAtIndex:0];
                [self saveNextimage];
            }
        }
    }else {
        //        [sharImageArray addObject:image];
        if (self.currentArr.count != 0) {
            [self.currentArr removeObjectAtIndex:0];
            [self saveNextimage];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 102) {
        if (buttonIndex == 1) {
            [self UIActivityMessage];
        }else {
            [sharImageArray removeAllObjects];
            _isNeedAleartMessage = NO;
            [MBProgressHUD hideHUD];
        }
    }
}
- (void)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享小贴士" message:@"亲爱的小鹿妈妈,现在可以直接分享微信了哦~点击'确定'就可以直接发朋友圈啦,点击'取消'本次不再提示此条信息。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    [alert show];
}
- (void)UIActivityMessage {
    [MBProgressHUD showLoading:@"火速加载~"];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:sharImageArray applicationActivities:nil];
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed) {
        [sharImageArray removeAllObjects];
    };
    activityVC.completionHandler = myBlock;
    [self presentViewController:activityVC animated:YES completion:nil];
    [MBProgressHUD hideHUD];
}
// 整点刷新
- (void)timeRefresh {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeView) userInfo:nil repeats:YES];
}
- (void)updateTimeView {
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    if (hour == 6 && minute == 0 && second == 0) { // 每日6点开始
        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.collectionView reloadData];
    }
}


- (void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)compareData:(NSString *)befoData SaveData:(NSString *)saveData {
    NSInteger compCount;
    NSComparisonResult result = [befoData compare:saveData];
    if (result == NSOrderedSame) {
        compCount = 0;
    }else if (result == NSOrderedAscending) {
        // saveData 大
        compCount = 1;
    }else if (result == NSOrderedDescending) {
        compCount = -1;
    }else { }
    return compCount;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[JMGlobal global] clearCacheWithSDImageCache:^(NSString *sdImageCacheString) {
    }];
}

@end










































































































