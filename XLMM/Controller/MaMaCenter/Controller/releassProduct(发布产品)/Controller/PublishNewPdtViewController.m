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
#import "MMClass.h"
#import "SharePicModel.h"
#import "CountdownView.h"
#import "UILabel+CustomLabel.h"
#import "JMStoreManager.h"


#define CELLWIDTH (([UIScreen mainScreen].bounds.size.width - 82)/3)


@interface PublishNewPdtViewController () {
    NSString *_qrCodeUrlString;
    NSInteger indexCode;
    NSInteger _qrCodeRequestDataIndex;  // 二维码图片请求次数
}

@property (nonatomic, strong)UICollectionView *picCollectionView;
@property (nonatomic, strong)PhotoView *photoView;

@property (nonatomic, strong)UIView *watchesView;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger saveIndex;
@property (nonatomic, strong)NSMutableArray *currentArr;

@property (nonatomic, assign)BOOL isLoad;

@property (nonatomic, assign)NSInteger cellNum;
@end

@implementation PublishNewPdtViewController{
  
    NSTimer *theTimer;
    UIView *bottomView;
    CountdownView *countdowmView;
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
    [MobClick beginLogPageView:@"PublishNewPdtViewController"];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor backgroundlightGrayColor];
    self.navigationController.navigationBarHidden = NO;
    indexCode = 0;
    _qrCodeRequestDataIndex = 0;
//    qrCodeUrlString = @"http://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=gQH_7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL01rTXVsUHJsT09aQklkd1R1MjFfAAIEeybmVwMEAI0nAA==";
    [self createNavigationBarWithTitle:@"每日推送" selecotr:@selector(backClickAction)];
    [self createCollectionView];
//    [self loaderweimaData];
    _qrCodeUrlString = [JMStoreManager getObjectByFileName:@"qrCodeUrlString"];
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
    
    if (hour == 10 && minute == 0 && second == 0) {
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

- (void)backClickAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
   // CGFloat rightSize = ([UIScreen mainScreen].bounds.size.width - 78)/3;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 68, 10, 10);
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5;
    
    
    self.picCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 104) collectionViewLayout:flowLayout];
    NSInteger hour = [self getCurrentTime];
    
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
    if (self.categoryCidString) {
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,self.categoryCidString];
    }
    
    [JMHTTPManager requestWithType:RequestTypeGET WithURLString:urlString WithParaments:nil WithSuccess:^(id responseObject) {
        NSArray *arrPic = responseObject;
        [self requestData:arrPic];
    } WithFail:^(NSError *error) {
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
        [MBProgressHUD hideHUDForView:self.view];
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
    for (NSMutableDictionary *oneTurns in data) {
        NSMutableArray *muArray = [NSMutableArray arrayWithArray:oneTurns[@"pic_arry"]];
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
    
    
    self.isLoad = YES;
    
    [self.picCollectionView reloadData];
    
    [MBProgressHUD hideHUDForView:self.view];
    
    
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
    if (countNum < 9) {
        [cell createImageForCellImageView:picModel.pic_arry[indexPath.row] Index:4];
    }else {
        [cell createImageForCellImageView:picModel.pic_arry[indexPath.row] Index:(countNum - 1)];
    }
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
    //图片查看
    PicCollectionViewCell *cell = (PicCollectionViewCell *)[self.picCollectionView cellForItemAtIndexPath:indexPath];
    
    //取到当前数组
    SharePicModel *picModel = self.dataArr[indexPath.section];
    
    self.photoView = [[PhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.photoView.picArr = [picModel.pic_arry mutableCopy];
    self.photoView.index = indexPath.row;

    [self.photoView createScrollView];
    [self.photoView fillData:indexPath.row cellFrame:cell.frame];
    [[[UIApplication sharedApplication].delegate window]addSubview:self.photoView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        //返回页眉
        PicHeaderCollectionReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picHeader" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        headerV.timeLabel.text = [self turnsTime:picModel.start_time];
        
        //改变label的高
        if (self.isLoad) {
            CGSize titleSize = [picModel.descriptionTitle boundingRectWithSize:CGSizeMake(SCREENWIDTH - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            headerV.desheight.constant = titleSize.height + 10;
        }
        
        headerV.propagandaLabel.text = picModel.descriptionTitle;
        NSString *name = [NSString stringWithFormat:@"%dlun", [picModel.turns_num intValue] - 1];
        headerV.turnsImageView.image = [UIImage imageNamed:name];
        return headerV;
        
    }else{
        PicFooterCollectionReusableView *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"picFooter" forIndexPath:indexPath];
        SharePicModel *picModel = self.dataArr[indexPath.section];
        if ([picModel.could_share intValue]) {
            footerV.savePhotoBtn.userInteractionEnabled=YES;
            footerV.savePhotoBtn.alpha=1.0;
            footerV.savePhotoBtn.tag = 100 + indexPath.section;
            [footerV.savePhotoBtn addTarget:self action:@selector(tapSaveImageToIphone:currentPicArr:) forControlEvents:UIControlEventTouchUpInside];
            return footerV;
        }else {
            footerV.savePhotoBtn.userInteractionEnabled=NO;
            footerV.savePhotoBtn.alpha=0.5;
            return footerV;
        }
       
    }
}

- (NSString *)turnsTime:(NSString *)timeStr {
    NSMutableString *timestext= [NSMutableString stringWithString:timeStr];
    NSRange range;
    range = [timestext rangeOfString:@"T"];
    [timestext replaceCharactersInRange:range withString:@" "];
    
    range = NSMakeRange(0, 5);
    [timestext deleteCharactersInRange:range];
    range = NSMakeRange(timestext.length - 4, 3);
    [timestext deleteCharactersInRange:range];
    return timestext;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (!self.isLoad) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 58);
    }else {
        SharePicModel *picModel = self.dataArr[section];
        NSString *title = picModel.descriptionTitle;
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(SCREENWIDTH - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if (titleSize.width < 30) {
            return CGSizeMake([UIScreen mainScreen].bounds.size.width, 58);
        }
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, titleSize.height + 35);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 54);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    SharePicModel *picModel = self.dataArr[section];
    self.cellNum = picModel.pic_arry.count;

    if (self.cellNum == 4) {
        return UIEdgeInsetsMake(10, 68, 10, CELLWIDTH + 10);
    }
    return UIEdgeInsetsMake(10, 68, 10, 10);
}

#pragma mark --保存事件
- (void)tapSaveImageToIphone:(UIButton *)sender
               currentPicArr:(NSMutableArray *)currentPicArr {
    
    NSInteger saveIndex = sender.tag - 100;
    self.saveIndex = saveIndex;
    SharePicModel *picModel = self.dataArr[saveIndex];
//    NSDictionary *dict = [picModel mj_keyValues];
    //判断是否有用户权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        [MobClick event:@"DaysPush_success"];
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
            [MBProgressHUD showError:@"请重新复制文案"];
        }else{
            [MobClick event:@"DaysPush_success"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文案复制完成，正在保存图片，尽情分享吧！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag = 102;
            [alert show];
        }
        
        
        if (self.currentArr == nil) {
            self.currentArr = [picModel.pic_arry mutableCopy];
            [self saveNext];
        }else if (self.currentArr.count > 0){
            [self.currentArr addObjectsFromArray:picModel.pic_arry];
        }else {
            [self.currentArr addObjectsFromArray:picModel.pic_arry];
            [self saveNext];
        }
        
    }
  
}

- (void)saveNext {
    NSInteger countNum = self.currentArr.count;
    if (countNum > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_BLOCK_DETACHED, 0), ^{
            NSString *picImageUrl = self.currentArr[0];
            if ([picImageUrl hasPrefix:@"http://img.xiaolumeimei.com"]) {
                picImageUrl = [NSString stringWithFormat:@"%@?imageMogr2/thumbnail/578/format/jpg/quality/90", picImageUrl];
            }else {
            }
            UIImageWriteToSavedPhotosAlbum([UIImage imagewithURLString:picImageUrl], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        });
    }
}

-(void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
//        NSLog(@"-------%@", error.localizedDescription);
    }else {
        [self.currentArr removeObjectAtIndex:0];
    }
    [self saveNext];
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



@end













































