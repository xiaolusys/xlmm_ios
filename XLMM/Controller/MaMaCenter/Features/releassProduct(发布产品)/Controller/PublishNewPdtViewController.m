//
//  PublishNewPdtViewController.m
//  XLMM
//
//  Created by 张迎 on 16/1/6.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "PublishNewPdtViewController.h"
#import "PicCollectionViewCell.h"
#import "PicHeaderCollectionReusableView.h"
#import "PicFooterCollectionReusableView.h"
#import "PhotoView.h"
#import "SharePicModel.h"
#import "CountdownView.h"
#import "UILabel+CustomLabel.h"
#import "JMStoreManager.h"
#import "WXApi.h"
#import "JMPushSaveModel.h"
#import "JMRichTextTool.h"
#import <Photos/Photos.h>
#import "NSArray+Reverse.h"
#import "JMPhotoBrowesView.h"



#define CELLWIDTH (([UIScreen mainScreen].bounds.size.width - 24)/3)


@interface PublishNewPdtViewController () <JMPhotoBrowesViewDatasource, JMPhotoBrowesViewDelegate> {
    NSString *_qrCodeUrlString;
    NSInteger indexCode;
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
    NSMutableDictionary *parameDic;
    NSMutableArray *sharImageArray;
    NSNumber *_currentSaveIndex;
    BOOL _isNeedAleartMessage;
    NSMutableDictionary *_currentSaveDataSource;
    NSString *_getBeforeDayFive;
    NSArray *imageUrlArray;
}
@property (nonatomic, strong)PhotoView *photoView;
@property (nonatomic, strong)UIView *watchesView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger saveIndex;
@property (nonatomic, strong)NSMutableArray *currentArr;
@property (nonatomic, assign)NSInteger cellNum;
@property (nonatomic, strong) JMPushSaveModel *pushSaveModel;
@property (nonatomic, strong) SharePicModel *picModel;
@property (nonatomic, strong) NSMutableDictionary *imageDict;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation PublishNewPdtViewController{
    NSTimer *theTimer;
    UIView *bottomView;
    CountdownView *countdowmView;
}

- (NSMutableDictionary *)imageDict {
    if (!_imageDict) {
        _imageDict = [NSMutableDictionary dictionary];
    }
    return _imageDict;
}
- (SharePicModel *)picModel {
    if (!_picModel) {
        _picModel = [[SharePicModel alloc] init];
    }
    return _picModel;
}
- (JMPushSaveModel *)pushSaveModel {
    if (!_pushSaveModel) {
        _pushSaveModel = [[JMPushSaveModel alloc] init];
    }
    return _pushSaveModel;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PublishNewPdtViewController"];
    NSArray *arr = [JMPushSaveModel findAll];
    for (int i = 0; i < arr.count; i++) {
        self.pushSaveModel = arr[i];
        if ([self compareData:_getBeforeDayFive SaveData:self.pushSaveModel.currentTime] == -1) {
            // 删除此条数据
            [JMPushSaveModel deleteObjectsByCriteria:[self.pushSaveModel.pushID stringValue]];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([theTimer isValid]) {
        [theTimer invalidate];
    }
    [MBProgressHUD hideHUD];
    [MobClick endLogPageView:@"PublishNewPdtViewController"];
}


//- (PhotoView *)photoView {
//    if (!_photoView) {
//        self.photoView = [[PhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    }
//    return _photoView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundlightGrayColor];
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClickAction)];
    _currentSaveDataSource = [NSMutableDictionary dictionary];
    sharImageArray = [NSMutableArray array];
    parameDic = [NSMutableDictionary dictionary];
    indexCode = 0;
    _qrCodeRequestDataIndex = 0;
    _isNeedAleartMessage = YES;
    _getBeforeDayFive = [NSString getBeforeDay:-5];
    [self createCollectionView];
    
    _qrCodeUrlString = [JMStoreManager getDataString:@"qrCodeUrlString.txt"];
    [self dingshishuaxin];
    if ([NSString isStringEmpty:_qrCodeUrlString]) {
        [self loaderweimaData];
    }else {
        [self loadPicData];
    }
}
- (void)dingshishuaxin{
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
        self.picCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.picCollectionView reloadData];
    }
}
- (void)showDefaultView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, SCREENWIDTH, 180)];
    bottomView.backgroundColor = [UIColor backgroundlightGrayColor];
    countdowmView = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    countdowmView.center = CGPointMake(SCREENWIDTH * 0.5, 100);
    [bottomView addSubview:countdowmView];
    [self.watchesView addSubview:bottomView];
    theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:countdowmView selector:@selector(updateTimeView) userInfo:nil repeats:YES];
}
- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // CGFloat rightSize = ([UIScreen mainScreen].bounds.size.width - 78)/3;
    //    flowLayout.sectionInset = UIEdgeInsetsMake(10, 68, 10, 10);
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5;
    CGFloat layoutHeight;
    if (self.isPushingDays) {
        layoutHeight = 0;
    }else {
        layoutHeight = 104;
    }
    self.picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - layoutHeight) collectionViewLayout:flowLayout];
    NSInteger hour = [self getCurrentTime];
    
    NSString *className = NSStringFromClass([self class]);
    if ([className isEqual:@"PublishNewPdtViewController"]) {
        if (hour > 6 || hour == 6) {
            self.picCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [self.view addSubview:self.picCollectionView];
        }else {
            self.watchesView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, SCREENWIDTH, 200)];
            self.watchesView.backgroundColor = [UIColor backgroundlightGrayColor];
            [self.picCollectionView addSubview:self.watchesView];
            [self showDefaultView];
            self.picCollectionView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
            [self.view addSubview:self.picCollectionView];
        }
    }else {  // JMPushingCategoryController
        self.picCollectionView.contentInset = UIEdgeInsetsMake((SCREENWIDTH - 5 * HomeCategorySpaceW) / 4 * 1.25 * 2 + 60 + HomeCategorySpaceH, 0, 0, 0);
        [self.view addSubview:self.picCollectionView];
        
    }
    self.picCollectionView.backgroundColor = [UIColor whiteColor];
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"picCollectionCell"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"picHeader"];
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"PicFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"picFooter"];
    [MBProgressHUD showLoading:@"正在加载..." ToView:self.view];
    
}
- (void)loadPicData {
    NSString *urlString = CS_DSTRING(Root_URL,@"/rest/v1/pmt/ninepic");
    NSString *className = NSStringFromClass([self class]);
    if ([className isEqual:@"PublishNewPdtViewController"]) {
        if (self.isPushingDays) {
            urlString = self.pushungDaysURL;
        }
    }else {
        urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic?ordering=-save_times",Root_URL];
    }
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        if (!responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            return ;
        }
        [MBProgressHUD hideHUDForView:self.view];
        NSArray *arrPic = responseObject;
        [self requestData:arrPic];
    } WithFail:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"获取信息失败"];
    } Progress:^(float progress) {
    }];
}
- (void)loaderweimaData {
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
- (void)fetchErweimaData:(NSDictionary *)dict {
    NSInteger code = [dict[@"code"] integerValue];
    if (code == 0) {
        _qrCodeUrlString = dict[@"qrcode_link"];
    }else {
        [MBProgressHUD showWarning:dict[@"info"]];
    }
}
- (NSInteger)getCurrentTime{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    NSDateComponents * comps = [calendar components:unitFlags fromDate:date];
    int hour = (int)[comps hour];
    return hour;
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
        
        self.picCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    //    qrCodeUrlString = @"http://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQH_7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL01rTXVsUHJsT09aQklkd1R1MjFfAAIEeybmVwMEAI0nAA==";
    for (NSDictionary *oneTurns in data) {
        NSMutableArray *muArray = [NSMutableArray array];
        NSArray *picArr = oneTurns[@"pic_arry"];
        if ([NSArray isEmptyForArray:picArr]) {
        }else {
            [muArray addObjectsFromArray:picArr];
        }
        
        NSInteger countNum = muArray.count;
        if (![NSString isStringEmpty:_qrCodeUrlString]) {
            if (countNum < 9) {
                [muArray addObject:_qrCodeUrlString];
            }else {
                [muArray replaceObjectAtIndex:4 withObject:_qrCodeUrlString];
            }
        }
        SharePicModel *sharePic = [SharePicModel mj_objectWithKeyValues:oneTurns];
        sharePic.pic_arry = muArray;
        [self.dataArr addObject:sharePic];
    }
    [self.picCollectionView reloadData];
    

}

#pragma mark --collection的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SharePicModel *picModel = self.dataArr[section];
    //    self.cellNum = picModel.pic_arry.count;
    return picModel.pic_arry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picCollectionCell" forIndexPath:indexPath];
    SharePicModel *picModel = self.dataArr[indexPath.section];
    NSInteger countNum = picModel.pic_arry.count;
    NSInteger codeNum = countNum < 9 ? countNum - 1 : 4;
    
    NSString *url = picModel.pic_arry[indexPath.row];
    if (codeNum == indexPath.row) {
    }else {
        url = [url imageGoodsOrderCompression];
    }
//    NSLog(@"%@",url);
//    NSString *url = codeNum == indexPath.row ? picModel.pic_arry[indexPath.row] : [picModel.pic_arry[indexPath.row] imageGoodsOrderCompression];
//    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    NSString *sectionRow = [NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"zhanwei"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"%ld组 %ld行 ---- %@",indexPath.section,indexPath.row, image);
        if (image) {
            [self.imageDict setObject:image forKey:sectionRow];
        }
    }];
    [self.imageDict setObject:cell.cellImageView.image forKey:sectionRow];
//    [cell createImageForCellImageView:picModel.pic_arry[indexPath.row] Index:codeNum RowIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SharePicModel *picModel = self.dataArr[indexPath.section];
    self.cellNum = picModel.pic_arry.count;
    if (self.cellNum == 1) {
        return CGSizeMake(CELLWIDTH + 30, CELLWIDTH + 80);
    }
    return CGSizeMake(CELLWIDTH, CELLWIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.images removeAllObjects];
    SharePicModel *picModel = self.dataArr[indexPath.section];
    imageUrlArray = [picModel.pic_arry copy];
    for (int i = 0; i < imageUrlArray.count; i++) {
        NSString *sectionRot = [NSString stringWithFormat:@"%ld%d",indexPath.section,i];
        UIImage *image = self.imageDict[sectionRot];
        if (image == nil) {
            image = [UIImage imageNamed:@"zhanwei"];
        }
        [self.images addObject:image];
    }
//    [JMPhotoBrowesView showPhotoBrowserWithImages:picModel.pic_arry currentImageIndex:indexPath.row];
    [JMPhotoBrowesView showPhotoBrowesWihtCurrentImageIndex:indexPath.row ImageCount:imageUrlArray.count DataSource:self];
}
- (UIImage *)photoBrowser:(JMPhotoBrowesView *)browser placeholderImageForIndex:(NSInteger)index {
    return self.images[index];
}
- (NSURL *)photoBrowser:(JMPhotoBrowesView *)browser highQualityImageURLForIndex:(NSInteger)index {
    return [NSURL URLWithString:[imageUrlArray[index] imageNormalCompression]];
}





- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        PicHeaderCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picHeader" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        headerV.titleLabel.text = picModel.title_content;
        headerV.timeLabel.text = [NSString jm_cutOutYearWihtSec:picModel.start_time];
        headerV.propagandaLabel.text = picModel.descriptionTitle;
        return headerV;
    }else{
        PicFooterCollectionReusableView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picFooter" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        [footerV.likeButton setTitle:picModel.save_times forState:UIControlStateNormal];
        [footerV.shareButton setTitle:picModel.save_times forState:UIControlStateNormal];
        footerV.savePhotoBtn.tag = 100 + indexPath.section;
        [footerV.savePhotoBtn addTarget:self action:@selector(tapSaveImageToIphone:currentPicArr:) forControlEvents:UIControlEventTouchUpInside];
        return footerV;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    SharePicModel *picModel = self.dataArr[section];
    return CGSizeMake(SCREENWIDTH, picModel.headerHeight);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREENWIDTH, 75);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    SharePicModel *picModel = self.dataArr[section];
    self.cellNum = picModel.pic_arry.count;
    if (self.cellNum == 4) {
        return UIEdgeInsetsMake(5, 10, 5, CELLWIDTH + 10);
    }
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark --保存事件
- (void)tapSaveImageToIphone:(UIButton *)sender
               currentPicArr:(NSMutableArray *)currentPicArr {
    NSInteger saveIndex = sender.tag - 100;
    self.saveIndex = saveIndex;
    SharePicModel *picModel = self.dataArr[saveIndex];
    _currentSaveIndex = picModel.piID;
    //判断是否有用户权限
    if (![self isPhotoPermission]) {
        //无权限
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败！" message:@"请在 设置->隐私->照片 中开启小鹿美美对照片的访问权" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 101;
        [alert show];
        
    }else {
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        //        NSLog(@"---------%@", picModel.descriptionTitle);
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
        NSLog(@"%@",self.currentArr);
        if (self.currentArr == nil) {
            self.currentArr = [picModel.pic_arry mutableCopy];
            //            [self saveNext];
            [self downLoadImage:picModel.piID];
        }else if (self.currentArr.count > 0){
            [MBProgressHUD hideHUD];
//            [MBProgressHUD showWarning:@"亲~您操作太快啦! ~(>_<)~"];
            [MBProgressHUD showLoading:@"亲~ 慢点! (*^__^*) " ToView:self.view];
//            [self.currentArr addObjectsFromArray:picModel.pic_arry];
            [self saveNextimage];
        }else {
            [self.currentArr addObjectsFromArray:picModel.pic_arry];
            //            [self saveNext];
            [self downLoadImage:picModel.piID];
        }
        
    }
    
}
#pragma mark 统计保存次数
- (void)statisticsSaveNum:(NSNumber *)piID {
    parameDic[@"save_times"] = @1;
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/pmt/ninepic/%@",Root_URL,piID];
    [JMHTTPManager requestWithType:RequestTypePATCH WithURLString:urlString WithParaments:parameDic WithSuccess:^(id responseObject) {
        if (!responseObject) return ;
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
}
- (void)downLoadImage:(NSNumber *)pushID {
    [self statisticsSaveNum:pushID];
    [self saveNextimage];
    NSArray *curArr = [self.currentArr copy];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *indexArray = [NSMutableArray array];
    NSInteger curArrCount = curArr.count;
    for (int i = 0; i < curArrCount; i++) {
        NSString *picUrl = curArr[i];
        NSString *indexString = [picUrl md5];
        [indexArray addObject:indexString];
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
        NSLog(@"%@",sharImageArray);
    });
}
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
        [MBProgressHUD hideHUDForView:self.view];
    }
}
- (void)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享小贴士" message:@"亲爱的小鹿妈妈,现在可以直接分享微信了哦~点击'确定'就可以直接发朋友圈啦,点击'取消'本次不再提示此条信息。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 102;
    [alert show];
}

-(void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        if (![self isPhotoPermission]) {
            [MBProgressHUD hideHUD];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败！" message:@"请在 设置->隐私->照片 中开启小鹿美美对照片的访问权" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
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
- (void)UIActivityMessage {
    [MBProgressHUD showLoading:@"火速加载~"];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:sharImageArray applicationActivities:nil];
//    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeAirDrop,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypeOpenInIBooks];
    
    UIActivityViewControllerCompletionHandler myBlock = ^(NSString *activityType,BOOL completed) {
        [sharImageArray removeAllObjects];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    activityVC.completionHandler = myBlock;
    [self presentViewController:activityVC animated:TRUE completion:nil];
    [MBProgressHUD hideHUD];
}
#pragma mark -- scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.photoView.contentOffY = scrollView.contentOffset.y;
}

#pragma mark--alertView的代理
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (101 == alertView.tag) {
//        //跳转到设置页
//        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//
//        if([[UIApplication sharedApplication] canOpenURL:url]) {
//
//            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            [[UIApplication sharedApplication] openURL:url];
//        }
//    }
//}
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
- (BOOL)isPhotoPermission {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[JMGlobal global] clearCacheWithSDImageCache:^(NSString *sdImageCacheString) {
        
    }];
    // Dispose of any resources that can be recreated.
}





@end

















































