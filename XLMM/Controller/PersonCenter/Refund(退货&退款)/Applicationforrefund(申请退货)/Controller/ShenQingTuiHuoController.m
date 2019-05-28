//
//  ShenQingTuiHuoController.m
//  XLMM
//
//  Created by younishijie on 15/11/13.
//  Copyright © 2015年 上海己美. All rights reserved.
//

#import "ShenQingTuiHuoController.h"
#import "JMOrderGoodsModel.h"
#import "QiniuSDK.h"
#import "JMRefundView.h"
#import "JMPopViewAnimationDrop.h"
#import "JMPopViewAnimationSpring.h"


//JMOrderGoodsModel

@interface ShenQingTuiHuoController ()<JMRefundViewDelegate,UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *keysArray;
@property (nonatomic, strong) NSMutableArray *linksArray;

@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) JMRefundView *popView;


@end


@implementation ShenQingTuiHuoController
{
    int number;
    int maxNumber;
    
    int reasonCode;
    UIView *backView;
    UIView *reasonView;
    UIView *selectedImageView;
    
    BOOL isChangeBtn;
   // UIVisualEffectView *effectView;
    
   // float refundPrice;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [JMNotificationCenter addObserver:self selector:@selector(keyboardDidHiden:) name:UIKeyboardWillHideNotification object:nil];
    [MobClick beginLogPageView:@"ShenQingTuiHuoController"];

}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [JMNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    
 
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.oid]];
    
    // 将图片写入文件
    
    [self.imagesArray writeToFile:fullPath atomically:YES];
    
    /**
     *  在视图即将消失的时候
     */
    if (self.changeStatusBlock != nil) {
        self.changeStatusBlock(isChangeBtn);
    }
    
    [MobClick endLogPageView:@"ShenQingTuiHuoController"];

}

- (void)keyboardDidShow:(NSNotification *)notification{
    NSLog(@"show");
    [UIView animateWithDuration:0.1 animations:^{
        self.view.frame = CGRectMake(0, -120, SCREENWIDTH, 120 + SCREENHEIGHT);
        
    }];
}
- (void)keyboardDidHiden:(NSNotification *)notification{
    
    
    NSLog(@"hiden");
    [UIView animateWithDuration:0.1 animations:^{
        
        self.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        
    }];
    
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getQiNiuToken];
    
    // Do any additional setup after loading the view from its nib.
    [self createNavigationBarWithTitle:@"申请退货" selecotr:@selector(backClicked:)];
    self.containterWidth.constant = SCREENWIDTH;
    self.imagesArray = [[NSMutableArray alloc] init];
    self.keysArray = [[NSMutableArray alloc] init];
    self.linksArray = [[NSMutableArray alloc] init];
    
    [self createKeysArray];

     NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.oid]];
    //
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithContentsOfFile:fullPath];
    if (mutableArray.count > 0) {
        self.imagesArray = mutableArray;
        [self createImageViews];
    } else {
        self.deleteButton1.hidden = YES;
        self.deleteButton2.hidden = YES;
        self.deleteButton3.hidden = YES;
    }
    self.dataArray = @[
                       @"错拍",
                       @"缺货",
                       @"开线/脱色/脱毛/有色差/有虫洞",
                       @"发错货/漏发",
                       @"没有发货",
                       @"未收到货",
                       @"与描述不符",
                       @"退运费",
                       @"发票问题",
                       @"七天无理由退换货",
                       @"其他"
                       ];
    
    //[self createNavigationBarWithTitle:@"申请退款" selecotr:@selector(backClicked:)];
    
    [self.myImageView sd_setImageWithURL:[NSURL URLWithString:[[self.dingdanModel.pic_path imageGoodsOrderCompression] JMUrlEncodedString]]];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.layer.cornerRadius = 5;
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.borderWidth = 0.5;
    self.myImageView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    number = [self.dingdanModel.num intValue];
    maxNumber = [self.dingdanModel.num intValue];
    
    
    self.nameLabel.text = self.dingdanModel.title;
    if(number != 0){
        self.priceLabel.text = [NSString stringWithFormat:@"¥%.1f",[self.dingdanModel.total_fee floatValue]/number];
    }
    self.sizeNameLabel.text = self.dingdanModel.sku_name;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", self.dingdanModel.num];
    
    self.refundPriceLabel.text = [NSString stringWithFormat:@"¥%.02f", self.refundPrice];
//    refundPrice = [self.dingdanModel.priceString floatValue];
    self.refundNumLabel.text = [NSString stringWithFormat:@"%i", maxNumber];
    
    self.selectedReason.layer.cornerRadius = 4;
    self.selectedReason.layer.borderWidth = 0.5;
    self.selectedReason.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.inputTextView.layer.cornerRadius = 4;
    self.inputTextView.layer.borderWidth = 0.5;
    self.inputTextView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    
    self.inputTextView.clearsContextBeforeDrawing = YES;
    
    
    self.commitButton.layer.cornerRadius = 20;
    self.commitButton.layer.borderWidth = 1;
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;


    
//    //  创建需要的毛玻璃特效类型
//    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:2];
//    //  毛玻璃view 视图
//    effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    //添加到要有毛玻璃特效的控件中
//    effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
//    [self.view addSubview:effectView];
//    //设置模糊透明度
//    effectView.alpha = 0.f;
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    
    backView.hidden = YES;
    
    [self.view addSubview:backView];
    
    
    [self loadReasonView];
    [self loadSelectedImageView];
    [self disableTijiaoButton];
    
    
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.borderWidth = 0.5;
    self.sendButton.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.sendImageView.layer.masksToBounds = YES;
    self.sendImageView2.layer.masksToBounds = YES;
    self.sendImageView3.layer.masksToBounds = YES;
    self.sendImageView.layer.cornerRadius = 5;
    self.sendImageView.layer.borderWidth = 0;
    self.sendImageView.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.sendImageView2.layer.cornerRadius = 5;
    self.sendImageView2.layer.borderWidth = 0;
    self.sendImageView2.layer.borderColor = [UIColor lineGrayColor].CGColor;
    self.sendImageView3.layer.cornerRadius = 5;
    self.sendImageView3.layer.borderWidth = 0;
    self.sendImageView3.layer.borderColor = [UIColor lineGrayColor].CGColor;
    


}

- (void)createKeysArray{
    NSString *userUrlString = [NSString stringWithFormat:@"%@/rest/v1/users", Root_URL];
    // NSLog(@"url = %@", userUrlString);
    NSString *userID = @"";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:userUrlString]];
    if(data != nil){
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //  NSLog(@"dic = %@", diction);
        NSDictionary *userInfo = [[diction objectForKey:@"results"] objectAtIndex:0];
        userID = [userInfo objectForKey:@"id"];
    }
    for (int i = 0; i < 3; i++) {
       NSString *key = [self keysWithTime:([[NSDate date] timeIntervalSince1970] + 100 * i) AndUserID:userID];
        [self.keysArray addObject:key];
        NSString *link = [NSString stringWithFormat:@"http://7xkyoy.com2.z0.glb.qiniucdn.com/%@", key];
        [self.linksArray addObject:link];
        
    }
    NSLog(@"keys = %@", self.keysArray);
    NSLog(@"links = %@", self.linksArray);
}

- (void)uploadImages:(NSData *)imagedata andKeys:(NSString *)key{
    NSString *token = [self getQiNiuToken];
   
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:imagedata key:key token:token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"%@", info);
                      NSLog(@"%@", resp);
                  } option:nil];
}

- (NSString *)getQiNiuToken{
   // http://192.168.1.31:9000/rest/v1/refunds/qiniu_token
    
    NSString *qiniuUrl = [NSString stringWithFormat:@"%@/rest/v1/refunds/qiniu_token", Root_URL];
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:qiniuUrl]];
    NSError *error = nil;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:qiniuUrl] options:NSDataReadingMappedIfSafe error:&error];                                                                                                                                                                                                                                                                
    if (error != nil) {
        NSLog(@"error = %@", error);
    }
    NSLog(@"data = %@", data);
    if (data == nil) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSString *token = [dic objectForKey:@"uptoken"];
    NSLog(@"dic = %@", dic);
    NSLog(@"token = %@", token);
    
    
    return token;
    
    
}

- (NSString *)keysWithTime:(NSTimeInterval )time AndUserID:(NSString *)userID{
   
    
    NSString *string = [NSString stringWithFormat:@"ios_%ld_%@_%c%c%c%c%c%c%c%c", (long)[[NSDate date] timeIntervalSince1970], userID, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65, arc4random()%26 + 65];
    //NSLog(@"%@", string);
    return string;
   // return nil;
}

- (void)loadSelectedImageView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PostImageView" owner:nil options:nil];
    
    selectedImageView = [views objectAtIndex:0];
    
    UIButton *cancelButton = (UIButton *)[selectedImageView viewWithTag:2000];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    [cancelButton addTarget:self action:@selector(cancelSeletedImage:) forControlEvents:UIControlEventTouchUpInside];
    UIView *listView = (UIView *)[selectedImageView viewWithTag:1000];
    listView.layer.masksToBounds = YES;
    listView.layer.cornerRadius = 10;
    selectedImageView.frame = self.view.frame;
    selectedImageView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    selectedImageView.alpha = 0.9;
    [self.view addSubview:selectedImageView];
    //  UIButton *button0 = (UIButton *)[reasonView viewWithTag:800];
    for (int i = 0; i < 2; i++) {
        UIButton *button = (UIButton *)[selectedImageView viewWithTag:900 + i];
        [button setTitleColor:[UIColor orangeThemeColor] forState:UIControlStateHighlighted];
        
        button.showsTouchWhenHighlighted = NO;
        //  button.highlighted = NO;
        [button addTarget:self action:@selector(selectedimageMethod:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"uibuton = %@", button);
    }

}

- (void)cancelSeletedImage:(UIButton *)button{
    selectedImageView.hidden = YES;
    backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        selectedImageView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
     //   effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
    }];
    
}

- (void)loadReasonView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"SelectedReasonsView" owner:nil options:nil];
    
    reasonView = [views objectAtIndex:0];
    
    UIButton *cancelButton = (UIButton *)[reasonView viewWithTag:200];
    cancelButton.layer.cornerRadius = 20;
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
    [cancelButton addTarget:self action:@selector(cancelSeleted:) forControlEvents:UIControlEventTouchUpInside];
    UIView *listView = (UIView *)[reasonView viewWithTag:100];
    listView.layer.masksToBounds = YES;
    listView.layer.cornerRadius = 10;
    reasonView.frame = self.view.frame;
    reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
    reasonView.alpha = 0.9;
    [self.view addSubview:reasonView];
    //  UIButton *button0 = (UIButton *)[reasonView viewWithTag:800];
    for (int i = 0; i < 11; i++) {
        UIButton *button = (UIButton *)[reasonView viewWithTag:800 + i];
        [button setTitleColor:[UIColor buttonEmptyBorderColor] forState:UIControlStateHighlighted];
        
        button.showsTouchWhenHighlighted = NO;
        //  button.highlighted = NO;
        [button addTarget:self action:@selector(selectReason:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"uibuton = %@", button);
    }
    [self hiddenReasonView];
}

- (void)hiddenReasonView{
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
      //  effectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
        backView.hidden = YES;
    }completion:^(BOOL finished) {
    }];
    
}
- (void)showReasonView{
    [UIView animateWithDuration:0.3 animations:^{
        reasonView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
      //  effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = YES;
        backView.hidden = NO;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)selectReason:(UIButton *)button{
    NSLog(@"tag = %ld", (long)button.tag);
    
    self.reasonLabel.text = self.dataArray[button.tag - 800];
    int num = (int)button.tag - 800+1;
    reasonCode = num %11;
    
    NSLog(@"reason Code = %d", reasonCode);
    [self hiddenReasonView];
    [self enableTijiaoButton];
    
    
    
}

- (void)enableTijiaoButton{
    self.commitButton.enabled = YES;
    self.commitButton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonBorderColor].CGColor;
}

- (void)disableTijiaoButton{
    self.commitButton.enabled = NO;
    self.commitButton.backgroundColor = [UIColor buttonDisabledBackgroundColor];
    self.commitButton.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
}

- (void)cancelSeleted:(UIButton *)button{
    NSLog(@"取消选择");
    [self hiddenReasonView];
    selectedImageView.hidden = YES;
    
}


- (void)backClicked:(UIButton *)button{
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

- (IBAction)reduceButtonClicked:(id)sender {
    NSLog(@"减一件");
    if (number-- <= 1) {
        number++;
        return;
    }
    
    //   http://192.168.1.31:9000/rest/v1/refunds
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSLog(@"params = %@", parameters);
    
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    
    NSLog(@"string = %@", string);
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        NSString *string = [responseObject objectForKey:@"apply_fee"];
        self.refundPrice = [string floatValue];
        self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", self.refundPrice];
        self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}

#pragma mark --TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    // textView.text = @" ";
    self.infoLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        self.infoLabel.hidden = NO;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    //return YES;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputTextView resignFirstResponder];
    
}
- (IBAction)addBtnClicked:(id)sender {
    
    if (number++ > maxNumber - 1) {
        number--;
        return;
    }
    NSDictionary *parameters = @{@"id": self.oid,
                                 @"modify":@3,
                                 @"num": [NSNumber numberWithInt:number]
                                 };
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parameters WithSuccess:^(id responseObject) {
        NSString *string = [responseObject objectForKey:@"apply_fee"];
        self.refundPriceLabel.text = [NSString stringWithFormat:@"%.02f", [string floatValue]];
        self.refundNumLabel.text = [NSString stringWithFormat:@"%d", number];
    } WithFail:^(NSError *error) {
        
    } Progress:^(float progress) {
        
    }];
}
- (IBAction)yuanyinClicked:(id)sender {
    
    NSLog(@"选择退款原因");
    
    
    [self.inputTextView resignFirstResponder];
    
    [self performSelector:@selector(showReasonView) withObject:nil afterDelay:0.3f];
    
//    [self showReasonView];

}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    NSData *imageData = UIImageJPEGRepresentation(savedImage, 1);

    [self.imagesArray addObject:imageData];
    
    [self createImageViews];
    
    
}

- (void)createImageViews{
    NSInteger MAX = 3;
    NSInteger count = (long)[self.imagesArray count];
    if (count > MAX) {
        count = MAX;
    }
    self.deleteButton1.hidden = YES;
    self.deleteButton2.hidden = YES;
    self.deleteButton3.hidden = YES;
    self.sendImageView.image = nil;
    self.sendImageView2.image = nil;
    self.sendImageView3.image = nil;
    
    for (int i = 0; i < count; i++) {
     
        UIImageView *imageView = [self.sendImgesView viewWithTag:1001 + i];
        UIButton *button = [self.sendImgesView viewWithTag:2001 + i];
        button.hidden = NO;
        imageView.image = [UIImage imageWithData:self.imagesArray[i]];
        

        
    }
    
    selectedImageView.hidden = YES;
    backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        selectedImageView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = NO;
    }];
    
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}




- (void)selectedimageMethod:(UIButton *)button{
    NSLog(@"button.tag = %ld", (long)button.tag);
    
    NSUInteger sourceType = 0;

    if (button.tag == 900) {
        sourceType = UIImagePickerControllerSourceTypeCamera;

    } else if (button.tag == 901){
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}







- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    NSLog(@"取消");
}


- (IBAction)commitClicked:(id)sender {
    
    NSLog(@"提交");
    [MBProgressHUD showLoading:@"退货处理中....."];
    //申请退货 上传图片bug修复
    
    for (int i = 0; i< self.imagesArray.count && i < self.keysArray.count; i++) {
        
        
         [self uploadImages:self.imagesArray[i] andKeys:self.keysArray[i]];
        

    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@/rest/v1/refunds", Root_URL];
    NSString *descStr = self.inputTextView.text;
    if ([self.inputTextView.text isEqualToString:@""]) {
        descStr = @"七天无理由退货";
    }
    
    NSMutableString *linkstr = [[NSMutableString alloc] init];
    if(self.imagesArray.count > 3){
        [MBProgressHUD showError:@"上传3张图片即可，请选择后重新提交"];
        return;
    }
    for (int i = 0; i < self.imagesArray.count; i++) {
        [linkstr appendString:self.linksArray[i]];
        [linkstr appendString:@","];
    }
    
    NSRange range = {linkstr.length - 1, 1};
    if (linkstr.length >0 ) {
        [linkstr deleteCharactersInRange:range];
        
    }
    NSLog(@"str = %@", linkstr);
    
    NSDictionary *parameters = @{@"id":self.oid,
                                 @"reason":[NSNumber numberWithInt:reasonCode],
                                 @"num":self.refundNumLabel.text,
                                 @"sum_price":[NSNumber numberWithFloat:self.refundPrice],
                                 @"description":descStr,
                                 @"proof_pic":linkstr,
                                 };
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:urlString WithParaments:parameters WithSuccess:^(id responseObject) {
        NSDictionary *dic = responseObject;
        isChangeBtn = YES;
        if (dic.count == 0) return;
        
        NSLog(@"refund return, %@", responseObject);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            NSLog(@"refund return ok");
            [MBProgressHUD hideHUD];
            self.button.hidden = YES;
            [self returnPopView];
        }else {
            [MBProgressHUD showError:dic[@"info"]];
        }
        NSLog(@"refund return ok end");
    } WithFail:^(NSError *error) {
        isChangeBtn = NO;
        NSLog(@"refund return failed %@", error);
        [MBProgressHUD hideHUD];
    } Progress:^(float progress) {
        
    }];
}

#pragma mark -- 弹出视图
- (void)returnPopView {
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRefundpopView)]];
    JMRefundView *popView = [JMRefundView defaultPopView];
    self.popView = popView;
    self.popView.titleStr = @"退货请求提交成功，客服会在24小时完成审核，您可以在退货界面查询进展，审核通过后您需要在退货界面填写退货快递单号，方便我们为你快速处理退款。";
    self.popView.delegate = self;
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.popView];
    [JMPopViewAnimationSpring showView:self.popView overlayView:self.maskView];
    
}
- (void)composeRefundButton:(JMRefundView *)refundButton didClick:(NSInteger)index {
    if (index == 100) {
        [self hideRefundpopView];
//        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self hideRefundpopView];
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  隐藏
 */
- (void)hideRefundpopView {
    [JMPopViewAnimationSpring dismissView:self.popView overlayView:self.maskView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendImages:(id)sender {
    NSLog(@"选择图片");
    
    [self.inputTextView resignFirstResponder];
    
    [self performSelector:@selector(showImageSelected) withObject:nil afterDelay:0.3f];
  
    
    
}

- (void)showImageSelected{
    selectedImageView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        selectedImageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        //  effectView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
        self.navigationController.navigationBarHidden = YES;
        backView.hidden = NO;
    }];
}

- (IBAction)deleteImageone:(id)sender {
    [self.imagesArray removeObjectAtIndex:0];
    [self createImageViews];
}

- (IBAction)deleteImageTwo:(id)sender {
    [self.imagesArray removeObjectAtIndex:1];
    [self createImageViews];
}

- (IBAction)deleteButtonThr:(id)sender {
    [self.imagesArray removeObjectAtIndex:2];
    [self createImageViews];
}

@end



















