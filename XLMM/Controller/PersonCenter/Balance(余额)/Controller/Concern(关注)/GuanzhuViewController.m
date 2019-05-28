//
//  GuanzhuViewController.m
//  XLMM
//
//  Created by younishijie on 16/2/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "GuanzhuViewController.h"
#import "UIImage+UIImageExt.h"


@interface GuanzhuViewController ()

@end

@implementation GuanzhuViewController{
    UIImage *saveImage;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"GuanZhu"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [MobClick endLogPageView:@"GuanZhu"];
}


- (void)backClicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createNavigationBarWithTitle:@"公众号" selecotr:@selector(backClicked:)];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.button.layer.cornerRadius = 20;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = [UIColor buttonEnabledBorderColor].CGColor;
    [self downLoadWithURLString:[NSString stringWithFormat:@"%@/rest/v1/users/get_wxpub_authinfo",Root_URL] andSelector:@selector(fetchedData:)];
    
    self.saveView.layer.cornerRadius = 8;
    self.saveView.layer.borderWidth = 1;
    self.saveView.layer.borderColor = [UIColor buttonDisabledBorderColor].CGColor;
    
}

- (void)fetchedData:(NSData *)data{
    if (data == nil) {
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dic = %@", dic);
    //  生成二维码 和描述。。。
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:[dic objectForKey:@"auth_link"]] withSize:480];
    self.imageView.image = image;
    
    self.label.text = [dic objectForKey:@"auth_msg"];
    
    
    
}

- (IBAction)buttonClicked:(id)sender {
    saveImage = [UIImage imageFromView:self.saveView];
    NSLog(@"save");
    
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已存入手机相册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}


#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

@end
