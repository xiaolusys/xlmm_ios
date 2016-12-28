//
//  AddressPickerView.m
//  XLMM
//
//  Created by younishijie on 15/8/13.
//  Copyright (c) 2015年 上海己美. All rights reserved.
//

#import "AddressPickerView.h"
#import <QuartzCore/QuartzCore.h>


#define kDuration 0.3

@interface AddressPickerView()
{
    NSMutableArray *provinceArray;
    NSMutableArray *cityArray;
    NSMutableArray *countyArray;
}
@end

@implementation AddressPickerView

- (id)initWithdelegate:(id <AddressPickerDelegate>)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    if (self) {
        self.addressPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
        self.addressPicker.backgroundColor = [UIColor whiteColor];
       // self.addressPicker.frame = CGRectMake(0, 0, 320, 216);
        [self addSubview:self.addressPicker];
        self.address = [[AddressModel alloc] init];
        self.delegate = delegate;
        self.addressPicker.delegate = self;
        self.addressPicker.dataSource = self;

//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *downloadURLString = [defaults stringForKey:@"download_url"];
        
//        NSString *path = [JMHelper getFullPathWithFile:downloadURLString];
        
//        NSArray *arr = [[JMDBManager sharedManager] readModels];
        
        
//        NSData *data = [NSData dataWithContentsOfFile:downloadURLString];
//        
//        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
//        [self createAddress1];
        [self createAddress2];

        
    }
    return self;

    
}
- (void)createAddress2 {
//    NSString *addressPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/addressInfo.json",addressPath]];
//    NSString *addressPath = [JMHelper getFullPathWithFile];
//    NSData *data = [NSData dataWithContentsOfFile:addressPath];
    
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *addressPath = [docPath stringByAppendingPathComponent:@"addressInfo.json"];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:addressPath];
    if (isExist == YES) {
        NSData *data = [NSData dataWithContentsOfFile:addressPath];
        provinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }else {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"areasAddress" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        provinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:jsonPath];
    }

    cityArray = [[provinceArray objectAtIndex:0] objectForKey:@"childs"];
    NSLog(@"province = %u", (unsigned int)provinceArray.count);
    NSLog(@"city = %u", (unsigned int)cityArray.count);
    
    _address.provinceName = [[provinceArray objectAtIndex:0] objectForKey:@"name"];
    
//    NSLog(@"%@", [[provinceArray objectAtIndex:0] objectForKey:@"state"]);
    
    NSLog(@"%@", self.address.provinceName);
    
    
    
    self.address.cityName = [[cityArray objectAtIndex:0] objectForKey:@"name"];
//    NSLog(@"%@", [[cityArray objectAtIndex:0] objectForKey:@"city"]);
    
    NSLog(@"%@", _address.cityName);
    
    countyArray = [[cityArray objectAtIndex:0] objectForKey:@"childs"];
    if (countyArray.count > 0) {
        self.address.countyName = [[countyArray objectAtIndex:0] objectForKey:@"name"];
    } else{
        self.address.countyName = @"";
    }

    
}
- (void)createAddress1 {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

    cityArray = [[provinceArray objectAtIndex:0] objectForKey:@"cities"];
    NSLog(@"province = %u", (unsigned int)provinceArray.count);
    NSLog(@"city = %u", (unsigned int)cityArray.count);
    
    _address.provinceName = [[provinceArray objectAtIndex:0] objectForKey:@"state"];
    
    NSLog(@"%@", [[provinceArray objectAtIndex:0] objectForKey:@"state"]);
    
    NSLog(@"%@", self.address.provinceName);
    
    
    
    self.address.cityName = [[cityArray objectAtIndex:0] objectForKey:@"city"];
    NSLog(@"%@", [[cityArray objectAtIndex:0] objectForKey:@"city"]);
    
    NSLog(@"%@", _address.cityName);
    
    countyArray = [[cityArray objectAtIndex:0] objectForKey:@"areas"];
    if (countyArray.count > 0) {
        self.address.countyName = [countyArray objectAtIndex:0];
    } else{
        self.address.countyName = @"";
    }

}

#pragma mark --PickerViewDelegate--

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return provinceArray.count;
            break;
        case 1:
            return cityArray.count;
            break;
        case 2:
            return countyArray.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[provinceArray objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            return [[cityArray objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            if ([countyArray count] > 0) {
                return [[countyArray objectAtIndex:row] objectForKey:@"name"];
                break;
            }
        default:
            return  @"";
            break;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            cityArray = [[provinceArray objectAtIndex:row] objectForKey:@"childs"];
            [self.addressPicker selectRow:0 inComponent:1 animated:YES];
            [self.addressPicker reloadComponent:1];
            
            countyArray = [[cityArray objectAtIndex:0] objectForKey:@"childs"];
            [self.addressPicker selectRow:0 inComponent:2 animated:YES];
            [self.addressPicker reloadComponent:2];
            
            self.address.provinceName = [[provinceArray objectAtIndex:row] objectForKey:@"name"];
            if (cityArray.count > 0) {
                self.address.cityName = [[cityArray objectAtIndex:0] objectForKey:@"name"];
            }else {
                self.address.cityName = @"";
            }
            
            if ([countyArray count] > 0) {
                self.address.countyName = [[countyArray objectAtIndex:0] objectForKey:@"name"];
            } else{
                self.address.countyName = @"";
            }
            NSLog(@"%@", self.address.provinceName);

            break;
        case 1:
            countyArray = [[cityArray objectAtIndex:row] objectForKey:@"childs"];
            [self.addressPicker selectRow:0 inComponent:2 animated:YES];
            [self.addressPicker reloadComponent:2];
            
            self.address.cityName = [[cityArray objectAtIndex:row] objectForKey:@"name"];
            if ([countyArray count] > 0) {
                self.address.countyName = [[countyArray objectAtIndex:0] objectForKey:@"name"];
            } else{
                self.address.countyName = @"";
            }
            break;
        case 2:
            if ([countyArray count] > 0) {
                self.address.countyName = [[countyArray objectAtIndex:row]objectForKey:@"name"];
            } else{
                self.address.countyName = @"";
            }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChangeStatus:)]) {
        [self.delegate pickerDidChangeStatus:self];
    }

}





- (void)showInView:(UIView *)view{
    NSLog(@"shou in");
    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    NSString  *str = NSStringFromCGRect(self.frame);
    NSLog(@"%@", str);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        NSString  *str = NSStringFromCGRect(self.frame);
        NSLog(@"%@", str);
    }];
}

- (void)cancelPicker{
    
    NSLog(@"quxiao");
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self. frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}

@end
