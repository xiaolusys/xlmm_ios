//
//  UIImage+ChangeGray.m
//  ImageTransfor
//
//  Created by younishijie on 15/10/14.
//  Copyright © 2015年 上海己美网络科技有限公司. All rights reserved.
//

#import "UIImage+ChangeGray.h"

@implementation UIImage (ChangeGray)

+ (UIImage*)grayscale:(UIImage*)anImage{
    
//    CGImageRef imageRef = anImage.CGImage;
//    
//    size_t width  = CGImageGetWidth(imageRef);
//    size_t height = CGImageGetHeight(imageRef);
//    
//    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
//    
//    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
//    
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
//    
//    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
//    
//    
//    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
//    
//    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
//    
//    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
//    
//    CFDataRef data = CGDataProviderCopyData(dataProvider);
//    
//    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
//    
//    NSUInteger  x, y;
//    for (y = 0; y < height; y++) {
//        for (x = 0; x < width; x++) {
//            UInt8 *tmp;
//            tmp = buffer + y * bytesPerRow + x * 4;
//            
//            UInt8 red,green,blue;
//            red = *(tmp + 0);
//            green = *(tmp + 1);
//            blue = *(tmp + 2);
//            
//            UInt8 brightness;
//           
//            brightness = (77 * red + 28 * green + 151 * blue) / 256;
//            
////            NSLog(@"%p", tmp +0);
////            NSLog(@"%u", *(tmp+2));
//            *(tmp + 0) = brightness;
//            
//            *(tmp + 1) = brightness;
//            *(tmp + 2) = brightness;
//    
//            
//        }
//    }
//    
//    
//    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
//    
//    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
//    
//    CGImageRef effectedCgImage = CGImageCreate(
//                                               width, height,
//                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
//                                               colorSpace, bitmapInfo, effectedDataProvider,
//                                               NULL, shouldInterpolate, intent);
//    
//    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
//    
//    CGImageRelease(effectedCgImage);
//    
//    CFRelease(effectedDataProvider);
//    
//    CFRelease(effectedData);
//    
//    CFRelease(data);
//    
//    return effectedImage;

    return nil;
}

@end
