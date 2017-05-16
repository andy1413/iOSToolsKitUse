//
//  UtilityMethods.h
//  JDSoulland
//
//  Created by LinXF on 2017/4/28.
//  Copyright © 2017年 JDMEDAHAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityMethods : NSObject

//  字典转json
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary;


//字典排序并转为json
+ (NSString*)dicSort:(NSDictionary*)dataDic;
@end
