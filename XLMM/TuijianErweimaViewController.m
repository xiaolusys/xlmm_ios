//
//  TuijianErweimaViewController.m
//  XLMM
//
//  Created by younishijie on 16/1/21.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "TuijianErweimaViewController.h"
#import "UIViewController+NavigationBar.h"
#import "WXApi.h"
#import "MMClass.h"
#import "UIImage+ChangeGray.h"
#import "YoumengShare.h"
#import "SendMessageToWeibo.h"
#import "SVProgressHUD.h"



@interface TuijianErweimaViewController ()
//遮罩层
@property (nonatomic, strong)UIView *shareBackView;
//分享页面
@property (nonatomic, strong) YoumengShare *youmengShare;
@end

@implementation TuijianErweimaViewController{
    UIImage *shareImages;
}

- (YoumengShare *)youmengShare {
    if (!_youmengShare) {
        self.youmengShare = [[YoumengShare alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    }
    return _youmengShare;
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
    self.title = @"二维码";
    UIImage * image = [UIImage imageNamed:@"erweimaDemo.png"];
    [self createNavigationBarWithTitle:@"推荐二维码" selecotr:@selector(backClicked:)];
    CGFloat height = (SCREENHEIGHT - 360-64-50)/2;
    self.topHeight.constant = 64 + height;
    self.bottomHeight.constant = height;
    
    self.imageView.image = image;
    [self downloadImage];
    self.saveButton.layer.cornerRadius = 15;
    self.saveButton.layer.borderWidth = 1;
    self.saveButton.layer.borderColor = [UIColor buttonEmptyBorderColor].CGColor;
    
    self.shareButton.layer.cornerRadius = 20;
    self.shareButton.layer.borderWidth = 1;
    self.shareButton.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    self.whiteView.layer.cornerRadius = 8;
    self.whiteView.layer.borderWidth = 1;
    self.whiteView.layer.borderColor = [UIColor imageViewBorderColor].CGColor;
    self.whiteView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.whiteView.layer.shadowOffset = CGSizeMake(2, 2);
    self.whiteView.contentMode = UIViewContentModeScaleAspectFill;
 
    
}

- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadImage{
    NSString *imagelink = [NSString stringWithFormat:@"%@%@", Root_URL, self.imagelink];
    NSLog(@"imagelink = %@", imagelink);
   // imagelink = @"http://192.168.1.31:9000/media/mm/coupon.png";
    UIImage *image = [UIImage imagewithURLString:imagelink];
    NSLog(@"image = %@", image);
    NSError *error = nil;
    
    NSURL *url = [NSURL URLWithString:imagelink];
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMapped error:&error];
    if (error == nil) {
        NSLog(@"data = %@", data);
    } else{
        NSLog(@"error = %@", error);
    }
    image = [UIImage imageWithData:data];
    self.imageView.image = image;
    
    NSLog(@"view = %@", self.whiteView);
    self.whiteView.bounds = CGRectMake(0, 0, 240, 360);
    shareImages = [UIImage imageFromView:self.whiteView];
    NSLog(@"shareImage = %@", shareImages);
    
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (IBAction)saveImage:(id)sender {
    NSLog(@"save");
    
     UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (IBAction)shareImage:(id)sender {
    NSLog(@"share");
    
    self.shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.shareBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:self.shareBackView];
    [self.shareBackView addSubview:self.youmengShare];
    self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    self.youmengShare.snapshotBtn.hidden = YES;
    self.youmengShare.friendsSnaoshotBtn.hidden = YES;
    
    // 点击分享后弹出自定义的分享界面
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT - 240, SCREENWIDTH, 240);
    }];
    
    //添加手势
//    self.youmengShare.userInteractionEnabled = NO;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleShareBtnClick:)];
//    
//    [self.shareBackView addGestureRecognizer:tap];
    
    // 分享页面事件处理
    [self.youmengShare.cancleShareBtn addTarget:self action:@selector(cancleShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.youmengShare.weixinShareBtn addTarget:self action:@selector(weixinShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.friendsShareBtn addTarget:self action:@selector(friendsShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqshareBtn addTarget:self action:@selector(qqshareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.qqspaceShareBtn addTarget:self action:@selector(qqspaceShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.weiboShareBtn addTarget:self action:@selector(weiboShareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.youmengShare.linkCopyBtn addTarget:self action:@selector(linkCopyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
//    WXMediaMessage *message = [WXMediaMessage message];
//    
//    WXImageObject *ext = [WXImageObject object];
//    
//  
//    ext.imageData = UIImagePNGRepresentation(shareImages);
//    message.mediaObject = ext;
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = 1;
//    
//    [WXApi sendReq:req];
}

#pragma mark --分享按钮事件
- (void)hiddenNavigationView{
    self.navigationController.navigationBarHidden = YES;
}
- (void)cancleShareBtnClick:(UIButton *)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.youmengShare.frame = CGRectMake(0, SCREENHEIGHT + 240, SCREENWIDTH, 240);
    } completion:^(BOOL finished) {
        [self.shareBackView removeFromSuperview];
    }];
}
- (void)weixinShareBtnClick:(UIButton *)btn{
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:shareImages location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
    }];
    [self cancleShareBtnClick:nil];
}

- (void)friendsShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:shareImages location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        [self hiddenNavigationView];
        
    }];
    [self cancleShareBtnClick:nil];
}



- (void)qqshareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@" " image:shareImages location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    }];

    [self cancleShareBtnClick:nil];
}

- (void)qqspaceShareBtnClick:(UIButton *)btn {
    [UMSocialData defaultData].extConfig.qzoneData.url = self.mamalink;
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@" " image:shareImages location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
    }];
    
    [self cancleShareBtnClick:nil];
}

- (void)weiboShareBtnClick:(UIButton *)btn {
    [SendMessageToWeibo sendMessageWithText:self.mamalink andPicture:UIImagePNGRepresentation(shareImages)];
    [self cancleShareBtnClick:nil];
}

- (void)linkCopyBtnClick:(UIButton *)btn {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *str = self.mamalink;
    [pab setString:str];
    if (pab == nil) {
        [SVProgressHUD showErrorWithStatus:@"请重新复制"];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:@"已复制"];
    }
    
    [self cancleShareBtnClick:nil];
}

@end
