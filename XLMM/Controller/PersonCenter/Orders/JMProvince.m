//
//  JMProvince.m
//  XLMM
//
//  Created by zhang on 16/5/27.
//  Copyright © 2016年 上海己美. All rights reserved.
//

#import "JMProvince.h"

@interface JMProvince ()



@end

@implementation JMProvince
//{
//    
//    NSDictionary *_areaDic;
//    NSArray *_province;
//    NSArray *_city;
//    NSArray *_district;
//    
//}

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}
+(instancetype)provinceWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+(NSMutableArray *)provinceList{
    
    NSMutableArray *provinceM = [NSMutableArray array];
    NSDictionary *areaDic = [[NSDictionary alloc] init];
    //    NSArray *province = [[NSArray alloc] init];
    //    NSArray *city = [[NSArray alloc] init];
    //    NSArray *district = [[NSArray alloc] init];
    
    //plist文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    NSArray *province = [[NSArray alloc] initWithArray: provinceTmp];
    
    
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    NSArray *city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    NSString *selectedCity = [city objectAtIndex: 0];
    NSArray *district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    
    [provinceM addObject:province];
    [provinceM addObject:city];
    [provinceM addObject:district];
    

    
    return provinceM;
    
}

@end





























