//
//  iOSRSAAndDesEncryption.h
//  iOSToolsKit
//
//  Created by 王方帅 on 17/5/8.
//  Copyright © 2017年 wangfangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ReturnPublicAndPrivate)(NSString *publicKey,NSString *privateKey);

@interface iOSRSAAndDesEncryption : NSObject

//rsa加密，用服务端公钥
+ (NSString *)rsaEncryptString:(NSString *)str publicKey:(NSString *)pubKey;

//rsa解密，用客户端私钥
+ (NSString *)rsaDecryptString:(NSString *)str privateKey:(NSString *)privKey;

//rsa签名，用客户端私钥
+(NSString *)rsaSignWithParamsString:(NSString *)paramsString clientPrivateKey:(NSString *)privKey;

//rsa验签，用服务端公钥
+(BOOL)rsaVerifySignWithParamsString:(NSString *)paramsString serverPublicKey:(NSString *)pubKey withSign:(NSString *)sign;

//des加密，用des key
+(NSString *)desEncryptionWithParamsString:(NSString *)paramsString key:(NSString *)key;

//des解密，用des key
+(NSString *)desDecryptWithDes:(NSString *)paramsString key:(NSString *)key;

//des签名（md5）
+(NSString *)desSignUseMD5WithParamsString:(NSString *)paramsString;

//des验签（md5）
+(BOOL)desVerifySignWithParamsString:(NSString *)paramsString withMD5Sign:(NSString *)md5Sign;

//创建rsa公私钥
+(void)createRSAPublicAndPrivateKey:(ReturnPublicAndPrivate)block;

@end
