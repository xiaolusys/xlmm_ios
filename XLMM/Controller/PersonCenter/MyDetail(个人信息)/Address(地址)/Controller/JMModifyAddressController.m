//
//  JMModifyAddressController.m
//  XLMM
//
//  Created by zhang on 17/2/20.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import "JMModifyAddressController.h"
#import "UILabel+CustomLabel.h"
#import "JMSelectAddressView.h"
#import "JMAddressModel.h"
#import "JMAddressIDCardCell.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)


@interface JMModifyAddressController () <UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSString *province;
    NSString *city;
    NSString *county;
    NSMutableArray *_selectedPhotos;
    NSString *sideFace;
    NSString *sideBack;
    NSString *idCardName;
    NSString *idCardNum;
}

@property (nonatomic, strong) UIScrollView *maskScrollView;
@property (nonatomic, strong) UIButton *navRightButton;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) UITextField *consigneeField;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic, strong) UITextField *idCardField;
@property (nonatomic, strong) UITextField *areaField;

@property (nonatomic, strong) UITextView *addressTextView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) JMSelectAddressView *selectView;

@property (nonatomic, strong) UICollectionView *collecionView;

@end

@implementation JMModifyAddressController

- (UIScrollView *)maskScrollView {
    if (!_maskScrollView) {
        _maskScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
    }
    return _maskScrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JMModifyAddressController"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JMModifyAddressController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedPhotos = [NSMutableArray array];
    NSString *titleString = @"修改收货地址";
    if (self.isAdd) {
        titleString = @"新增收货地址";
    }
    [self createNavigationBarWithTitle:titleString selecotr:@selector(backClick)];
    self.view.backgroundColor = [UIColor countLabelColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)]];
    [self.view addSubview:self.maskScrollView];
    
    [self createInputBoxView];
    JMSelectAddressView *selectView = [[JMSelectAddressView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.selectView = selectView;
    kWeakSelf
    self.selectView.block = ^(NSString *proviceStr,NSString *cityStr,NSString * disStr) {
        NSLog(@"%@,%@,%@",proviceStr , cityStr , disStr);
        weakSelf.areaField.text = [NSString stringWithFormat:@"%@%@%@",proviceStr,cityStr,disStr];
        province = [proviceStr copy];
        city = [cityStr copy];
        county = [disStr copy];
    };
    
}
#pragma mark 网络请求
// 删除地址
- (void)deleteAddress {
    NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/delete_address", Root_URL, self.addressModel.addressID];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
        /*
         {
         code = 1;
         msg = "\U5220\U9664\U51fa\U9519";
         ret = 0;
         }
         */
        [self.navigationController popViewControllerAnimated:YES];
    } WithFail:^(NSError *error) {
        [MBProgressHUD showWarning:@"删除地址失败"];
    } Progress:^(float progress) {
    }];
}




#pragma mark 创建UI
- (void)createNavRightItem {
    NSString *titleStr = @"删除";
    CGFloat titleStrWidth = [titleStr widthWithHeight:0. andFont:14.].width;
    self.navRightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, titleStrWidth, 44)];
    [self.navRightButton addTarget:self action:@selector(rightNavigationClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton setTitle:titleStr forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    self.navRightButton.titleLabel.font = [UIFont systemFontOfSize:14.];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navRightButton];
}
- (void)createInputBoxView {
    CGFloat firstSectionViewH = 100.;
    CGFloat labelWidth = 80.f;
    if (self.isBondedGoods) {
        firstSectionViewH = 140.;
    }
    UIView *firstSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, firstSectionViewH)];
    firstSectionView.backgroundColor = [UIColor whiteColor];
    UILabel *consigneeLabel = [self createLabelWithFrame:CGRectMake(20, 10, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"收货人"];
    UILabel *phoneNumLabel = [self createLabelWithFrame:CGRectMake(20, consigneeLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"手机号"];
    UITextField *consigneeField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, 15, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入收货人姓名" KeyboardType:UIKeyboardTypeDefault];
    UITextField *phoneNumField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, consigneeField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入收货人手机号" KeyboardType:UIKeyboardTypeNumberPad];
    self.consigneeField = consigneeField;
    self.phoneNumField = phoneNumField;
    [self.maskScrollView addSubview:firstSectionView];
    [firstSectionView addSubview:consigneeLabel];
    [firstSectionView addSubview:phoneNumLabel];
    [firstSectionView addSubview:consigneeField];
    [firstSectionView addSubview:phoneNumField];
    if (self.isBondedGoods) {
        UILabel *idCardLabel = [self createLabelWithFrame:CGRectMake(20, phoneNumLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"身份证号"];
            UITextField *idCardField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, phoneNumField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请输入身份证号" KeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        self.idCardField = idCardField;
        [firstSectionView addSubview:idCardLabel];
        [firstSectionView addSubview:idCardField];
    }
    
    UIView *secondSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, firstSectionView.mj_max_Y + 20, SCREENWIDTH, 150)];
    secondSectionView.backgroundColor = [UIColor whiteColor];
    UILabel *areaLabel = [self createLabelWithFrame:CGRectMake(20, 10, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"所在地区"];
    UILabel *addressLabel = [self createLabelWithFrame:CGRectMake(20, areaLabel.mj_max_Y, labelWidth * HomeCategoryRatio, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"详细地址"];
    UITextField *areaField = [self createTextFieldWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, 15, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 30) PlaceHolder:@"请选择您所在地区" KeyboardType:UIKeyboardTypeDefault];
    
    self.areaField = areaField;
    [self.maskScrollView addSubview:secondSectionView];
    [secondSectionView addSubview:areaLabel];
    [secondSectionView addSubview:addressLabel];
    [secondSectionView addSubview:areaField];

//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextView class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        const char *name = ivar_getName(ivar);
//        NSString *objcName = [NSString stringWithUTF8String:name];
//        NSLog(@"%d : %@",i , objcName);
//    }
    UITextView *addressTextView = [[UITextView alloc] initWithFrame:CGRectMake(labelWidth * HomeCategoryRatio + 20, areaField.mj_max_Y + 10, SCREENWIDTH - consigneeLabel.mj_max_X - 20, 80)];
    addressTextView.backgroundColor = [UIColor whiteColor];
    addressTextView.font = [UIFont systemFontOfSize:13.];
    addressTextView.keyboardType = UIKeyboardTypeDefault;
    addressTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    addressTextView.layer.masksToBounds = YES;
    addressTextView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    addressTextView.layer.borderWidth = 0.5f;
    addressTextView.layer.cornerRadius = 5.f;
    addressTextView.delegate = self;
    [secondSectionView addSubview:addressTextView];
    self.addressTextView = addressTextView;
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, SCREENWIDTH / 2, 20)];
    placeHolderLabel.text = @"请输入您的详细地址";
    placeHolderLabel.font = [UIFont systemFontOfSize:13.];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor titleDarkGrayColor];
    [placeHolderLabel sizeToFit];
    [addressTextView addSubview:placeHolderLabel];
//    [addressTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    self.placeHolderLabel = placeHolderLabel;
    
    
    CGFloat settingViewH = 40.f;
    if (self.isAdd) {
        settingViewH = 0.f;
    }else {
        UIView *settingView = [[UIView alloc] initWithFrame:CGRectMake(0, secondSectionView.mj_max_Y + 20, SCREENWIDTH, 40)];
        settingView.backgroundColor = [UIColor whiteColor];
        [self.maskScrollView addSubview:settingView];
        
        UILabel *isSettingLabel = [self createLabelWithFrame:CGRectMake(20, 0, SCREENWIDTH / 2, 40) font:13. textColor:[UIColor buttonTitleColor] text:@"是否设为常用地址"];
        [settingView addSubview:isSettingLabel];
        
        UISwitch *addressSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 5, 60, 30)];
        [addressSwitch setOn:NO animated:YES];
        [addressSwitch addTarget:self action:@selector(addressSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [settingView addSubview:addressSwitch];
    }
    
    
    
    UILabel *warningLabel = [self createLabelWithFrame:CGRectMake(20, secondSectionView.mj_max_Y + 20 + settingViewH, SCREENWIDTH - 40, 20) font:14. textColor:[UIColor redColor] text:@""];
    [self.maskScrollView addSubview:warningLabel];
    self.warningLabel = warningLabel;
    
    
//    CGFloat _margin = 4;
//    CGFloat _itemWH;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    _itemWH = (self.view.mj_w - 2 * _margin - 4) / 3 - _margin;
    layout.itemSize = CGSizeMake(90, 90);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    UICollectionView *collecionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, warningLabel.mj_max_Y + 20, SCREENWIDTH, 100) collectionViewLayout:layout];
    collecionView.alwaysBounceVertical = YES;
    collecionView.backgroundColor = [UIColor whiteColor];
    collecionView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    collecionView.dataSource = self;
    collecionView.delegate = self;
    collecionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [collecionView registerClass:[JMAddressIDCardCell class] forCellWithReuseIdentifier:@"JMAddressIDCardCellIdentifier"];
    [self.maskScrollView addSubview:collecionView];
    self.collecionView = collecionView;

    
    UIButton *savebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    savebutton.frame = CGRectMake(15, collecionView.mj_max_Y + 10, SCREENWIDTH - 30, 40);
    savebutton.backgroundColor = [UIColor buttonEnabledBackgroundColor];
    [savebutton setTitle:@"保存" forState:UIControlStateNormal];
    [savebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    savebutton.titleLabel.font = [UIFont systemFontOfSize:14.];
    savebutton.layer.masksToBounds = YES;
    savebutton.layer.cornerRadius = 20.f;
    [savebutton addTarget:self action:@selector(saveAddressInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.maskScrollView addSubview:savebutton];
    
    
    if (self.isAdd) {
    }else {
        [self createNavRightItem];
        self.consigneeField.text = self.addressModel.receiver_name;
        self.phoneNumField.text = self.addressModel.receiver_mobile;
        self.addressTextView.text = self.addressModel.receiver_address;
        province = self.addressModel.receiver_state;
        city = self.addressModel.receiver_city;
        county = self.addressModel.receiver_district;
        self.areaField.text = [NSString stringWithFormat:@"%@%@%@",province,city,county];
    }
    if (self.addressTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }

    self.maskScrollView.contentSize = CGSizeMake(SCREENWIDTH, savebutton.mj_max_Y + 20);
    self.maskScrollView.userInteractionEnabled = YES;
    [self.collecionView reloadData];
    
}

- (UILabel *)createLabelWithFrame:(CGRect)frame font:(CGFloat)font textColor:(UIColor *)textColor text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:font];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame PlaceHolder:(NSString *)placeHolder KeyboardType:(UIKeyboardType)keyboardType {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = placeHolder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13.];
    textField.delegate = self;
    return textField;
}

#pragma mark UICollectionView 代理实现
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMAddressIDCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JMAddressIDCardCellIdentifier" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        [cell.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@(40));
        }];
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn"];
        cell.deleteBtn.hidden = YES;
        if ([NSString isStringEmpty:sideFace]) {
            cell.titleLabel.text = @"请上传身份证正面照";
        }else {
            cell.titleLabel.text = @"请上传身份证反面照";
        }
        
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
        [sheet showInView:self.view];
        
    }else {
        // 预览图片 (暂时不写)
        
    }
}

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    
    [self.collecionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self.collecionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collecionView reloadData];
    }];
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self diaoyongxiangji:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if ([self authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([self authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        [self diaoyongxiangji:UIImagePickerControllerSourceTypeCamera];
        
       
    }
}
- (void)diaoyongxiangji:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = type;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
    
    
}
#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 设置图片
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
    NSData *data = [self imageWithImage:newImage scaledToSize:CGSizeMake(300, 400)];
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"card_base64"] = encodedImageStr;
    param[@"side"] = @"face";
    NSString *string = [NSString stringWithFormat:@"%@/rest/v2/ocr/idcard_indentify", Root_URL];
    [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:param WithSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 0) {
            
            NSDictionary *dict = responseObject[@"card_infos"];
            NSString *sideStr = [NSString stringWithFormat:@"%@",dict[@"side"]];
            if ([sideStr isEqualToString:@"back"]) {
                sideBack = dict[@"card_imgpath"];
            }else {
                sideFace = dict[@"card_imgpath"];
                idCardNum = [dict[@"num"] stringValue];
                idCardName = dict[@"name"];
            }
        }else {
            [MBProgressHUD showWarning:responseObject[@"info"]];
        }
    } WithFail:^(NSError *error) {
    } Progress:^(float progress) {
    }];
    
    
}
//[_selectedPhotos addObject:newImage];
- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSInteger)authorizationStatus {
    if (iOS8Later) {
        return [PHPhotoLibrary authorizationStatus];
    } else {
        return [ALAssetsLibrary authorizationStatus];
    }
    return NO;
}

#pragma mark 代理实现
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.warningLabel.text = @"";
    if (textField == self.areaField) {
        [self.consigneeField resignFirstResponder];
        [self.phoneNumField resignFirstResponder];
        [self.idCardField resignFirstResponder];
        [self.addressTextView resignFirstResponder];
        [self.selectView show];
        return NO;
    }else {
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.text.length) {
        self.placeHolderLabel.hidden = NO;
    }else {
        self.placeHolderLabel.hidden = YES;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    } else if (buttonIndex == 1){
        [self deleteAddress];
    }
}

#pragma mark 自定义点击事件
- (void)addressSwitchChange:(UISwitch *)addressSwitch {
    if (addressSwitch.on) {
        if (self.addressModel.addressID != nil) {
            [MBProgressHUD showLoading:@""];
            NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/%@/change_default", Root_URL, self.addressModel.addressID];
            [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:nil WithSuccess:^(id responseObject) {
                NSLog(@"%@",responseObject);
                [MBProgressHUD hideHUD];
            } WithFail:^(NSError *error) {
                [MBProgressHUD hideHUD];
            } Progress:^(float progress) {
            }];
        }
        NSLog(@"打开");
    }else {
        NSLog(@"关闭");
    }
}
- (void)saveAddressInfoClick:(UIButton *)button {
    NSLog(@"收货人%@ \n  手机号 %@ \n  详细地址%@ ",self.consigneeField.text,self.phoneNumField.text,self.addressTextView.text);
    if ([NSString isStringEmpty:self.consigneeField.text]) {
        self.warningLabel.text = @"请填写收货人姓名";
        return ;
    }
    if ([NSString isStringEmpty:self.phoneNumField.text]) {
        if (self.phoneNumField.text.length != 11) {
            self.warningLabel.text = @"请填写正确的手机号码";
            return ;
        }
        self.warningLabel.text = @"请填写手机号码";
        return ;
    }
    if (self.isBondedGoods) {
        if ([NSString isStringEmpty:self.idCardField.text]) {
            self.warningLabel.text = @"请填写身份证号";
            return ;
        }
        if (![[JMGlobal global] validateIdentityCard:self.idCardField.text]) {
            self.warningLabel.text = @"请检查身份证号";
            return ;
        }
    }
    if ([NSString isStringEmpty:self.areaField.text]) {
        self.warningLabel.text = @"请选择所在地区";
        return ;
    }
    if ([NSString isStringEmpty:self.addressTextView.text]) {
        self.warningLabel.text = @"请填写详细地址";
        return ;
    }
    NSMutableDictionary *parame = [self parame];
    if (self.isAdd) {
        if (self.isBondedGoods) {
            parame[@"identification_no"] = self.idCardField.text;
        }
        NSString *string = [NSString stringWithFormat:@"%@/rest/v1/address/create_address?format=json", Root_URL];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:string WithParaments:parame WithSuccess:^(id responseObject) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
        } WithFail:^(NSError *error) {
            [MBProgressHUD showWarning:@"添加地址失败,请重新添加"];
        } Progress:^(float progress) {
            
        }];
    }else {
        parame[@"id"] = self.addressModel.addressID;
        if (self.isBondedGoods) {
            parame[@"identification_no"] = self.idCardField.text;
        }
        NSString *modifyUrlStr = [NSString stringWithFormat:@"%@/rest/v1/address/%@/update", Root_URL,self.addressModel.addressID];
        [JMHTTPManager requestWithType:RequestTypePOST WithURLString:modifyUrlStr WithParaments:parame WithSuccess:^(id responseObject) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [MBProgressHUD showWarning:responseObject[@"info"]];
            }
            
        } WithFail:^(NSError *error) {
            [MBProgressHUD showWarning:@"修改地址失败,请重新修改"];
        } Progress:^(float progress) {
            
        }];

        
        
    }
}
- (NSMutableDictionary *)parame {
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"receiver_state"] = province;
    parame[@"receiver_city"] = city;
    parame[@"receiver_district"] = county;
    parame[@"receiver_address"] = self.addressTextView.text;
    parame[@"receiver_name"] = self.consigneeField.text;
    parame[@"receiver_mobile"] = self.phoneNumField.text;
    return parame;
}
// 删除地址事件
- (void)rightNavigationClick:(UIButton *)button {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]) {
        return NO;
    }
    return  YES;
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}







@end




















