//
//  UtilityMethods.m
//  JDSoulland
//
//  Created by LinXF on 2017/4/28.
//  Copyright © 2017年 JDMEDAHAI. All rights reserved.
//

#import "UtilityMethods.h"

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

//字典排序并转为json
+ (NSString*)dicSort:(NSDictionary*)dataDic {
    NSArray* arr = [dataDic allKeys];
    for(NSString* str in arr)
    {
        NSLog(@"%@", [dataDic objectForKey:str]);
    }
    
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    NSLog(@"array=%@",arr);
    
    
    
    NSString *data=@"";
    
    for (int x=0; x<[arr count]; x++) {
        NSString *key =[arr objectAtIndex:x];
        NSString *tempData =[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[dataDic objectForKey:key]];
        data = [data stringByAppendingString: tempData];
    }
    data =[data substringToIndex:data.length-1];
    NSLog(@"data =%@",data);
    return  [self resultStr:data];
}

+(NSString*)resultStr:(NSString*)keyAndValues{
    NSString *result = [NSString stringWithFormat:@"{%@}",keyAndValues];
    return result;
}

@end
