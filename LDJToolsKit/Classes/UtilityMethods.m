//
//  UtilityMethods.m
//  JDSoulland
//
//  Created by LinXF on 2017/4/28.
//  Copyright © 2017年 JDMEDAHAI. All rights reserved.
//

#import "UtilityMethods.h"
#import "JSONKit.h"

@implementation UtilityMethods
//  字典转json
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *policyData = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    if(!policyData && error){
        NSLog(@"Error creating JSON: %@", [error localizedDescription]);
        return @"";
    }
    
    //NSJSONSerialization converts a URL string from http://... to http:\/\/... remove the extra escapes 修复json转换中\\ 问题
    NSString* jsonString = [[NSString alloc] initWithData:policyData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonString;
}

//数组和字典排序并转为json
+ (NSString*)httpRequestDicAndArraySort:(id)dicOrArray {
    if ([dicOrArray isKindOfClass:[NSArray class]])
    {
        dicOrArray = [dicOrArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        return [dicOrArray JSONString];
    }
    else if ([dicOrArray isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dataDic = dicOrArray;
        return [self dicSort:dataDic];
    }
    else
    {
        NSLog(@"dicOrArray格式错误,不是数组也不是字典%@",dicOrArray);
        return @"";
    }
    
}

+(NSString *)arraySort:(NSArray *)dataArr
{
    NSArray *arr = dataArr;
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSLog(@"array=%@",arr);
    
    
    
    NSString *data=@"";
    
    for (int x=0; x<[arr count]; x++) {
        NSString *value =[arr objectAtIndex:x];
        NSString *tempData = nil;
        if ([value isKindOfClass:[NSString class]])
        {
            tempData = [NSString stringWithFormat:@"\"%@\",",value];
        }
        else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
        {
            tempData = [NSString stringWithFormat:@"%@,",[self httpRequestDicAndArraySort:value]];
        }
        
        data = [data stringByAppendingString: tempData];
    }
    data =[data substringToIndex:data.length-1];
    NSLog(@"data =%@",data);
    return [NSString stringWithFormat:@"[%@]",data];
}

+(NSString *)dicSort:(NSDictionary *)dataDic
{
    NSArray* arr = [dataDic allKeys];
    
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSLog(@"array=%@",arr);
    
    
    
    NSString *data=@"";
    
    for (int x=0; x<[arr count]; x++) {
        NSString *key =[arr objectAtIndex:x];
        NSString *value = [dataDic objectForKey:key];
        NSString *tempData = nil;
        if ([value isKindOfClass:[NSString class]])
        {
            tempData = [NSString stringWithFormat:@"\"%@\":\"%@\",",key,value];
        }
        else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]])
        {
            NSString *vvv = [self httpRequestDicAndArraySort:value];
            tempData = [NSString stringWithFormat:@"\"%@\":%@,",key,vvv];
        }
        
        data = [data stringByAppendingString: tempData];
    }
    data =[data substringToIndex:data.length-1];
    NSLog(@"data =%@",data);
    return [NSString stringWithFormat:@"{%@}",data];
}

@end
