//
//  LDJRSAAndDES.h
//  iOSToolsKit
//
//  Created by 王方帅 on 17/5/8.
//  Copyright © 2017年 wangfangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDJRSAAndDES : NSObject

+(NSDictionary *)rsaSignAndEncryptionWithParams:(NSDictionary *)params;

+(NSDictionary *)rsaDecryptAndVerifySignWithParams:(NSMutableDictionary *)params;

+(NSDictionary *)desSignAndEncryptionWithParams:(NSMutableDictionary *)params;

+(NSDictionary *)desDecryptAndVerifySignWithParams:(NSMutableDictionary *)params;

+(void)createRsaPublicKeyAndPrivateKey;

@end
