//
//  LDJRSAAndDES.m
//  iOSToolsKit
//
//  Created by 王方帅 on 17/5/8.
//  Copyright © 2017年 wangfangshuai. All rights reserved.
//

#import "LDJRSAAndDES.h"
#import "iOSRSAAndDesEncryption.h"
#import "UtilityMethods.h"
#import "KeychainItemWrapper.h"
#import "JSONKit.h"

@implementation LDJRSAAndDES

+(LDJRSAAndDES *)share
{
    static LDJRSAAndDES *_share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share = [[LDJRSAAndDES alloc] init];
    });
    return _share;
}

+(NSDictionary *)rsaSignAndEncryptionWithParams:(NSMutableDictionary *)params
{
    NSString *privateKey = [[LDJRSAAndDES share].keyChainDic objectForKey:@"clientPrivate"];
    if (privateKey == nil)
    {
        NSLog(@"clientPrivate is nil");
        return nil;
    }
    NSString *sign = [iOSRSAAndDesEncryption rsaSignWithParamsString:[UtilityMethods httpRequestDicAndArraySort:params] clientPrivateKey:privateKey];
    NSLog(@"rsaSignAndEncryptionWithParams:%@",sign);
    if (sign)
    {
        params[@"sign"] = sign;
        NSString *pubKey = [[LDJRSAAndDES share].keyChainDic objectForKey:@"serverPublicKeyStrInClient"];
        if (pubKey == nil)
        {
            NSLog(@"serverPublicKeyStrInClient is nil");
            return nil;
        }
        NSString *encryptStr = [iOSRSAAndDesEncryption rsaEncryptString:[params JSONString] publicKey:pubKey];
        NSLog(@"rsaSignAndEncryptionWithParams:%@",encryptStr);
        if (encryptStr)
        {
            return @{@"ciphertext":encryptStr};
        }
    }
    return nil;
}

+(NSDictionary *)rsaDecryptAndVerifySignWithParams:(NSMutableDictionary *)params
{
    NSString *private =[[LDJRSAAndDES share].keyChainDic objectForKey:@"clientPrivate"];
    if (private == nil)
    {
        NSLog(@"clientPrivate is nil");
        return nil;
    }
    NSString *decryptStr = [iOSRSAAndDesEncryption rsaDecryptString:params[@"ciphertext"] privateKey:private];
    NSLog(@"rsaDecryptAndVerifySignWithParams:%@",decryptStr);
    if (decryptStr)
    {
        NSMutableDictionary *responseDic = [NSMutableDictionary dictionaryWithDictionary:[decryptStr objectFromJSONString]];
        NSString *sign = responseDic[@"sign"];
        [responseDic removeObjectForKey:@"sign"];
        
        NSString *serverPublic =[[LDJRSAAndDES share].keyChainDic objectForKey:@"serverPublicKeyStrInClient"];
        if (serverPublic == nil)
        {
            NSLog(@"serverPublicKeyStrInClient is nil");
            return nil;
        }
        BOOL veriSucc = [iOSRSAAndDesEncryption rsaVerifySignWithParamsString:[responseDic JSONString] serverPublicKey:serverPublic withSign:sign];
        NSLog(@"rsaDecryptAndVerifySignWithParams:%d",veriSucc);
        if (veriSucc)
        {
            return responseDic;
        }
    }
    return nil;
}

+(NSDictionary *)desSignAndEncryptionWithParams:(NSMutableDictionary *)params
{
    NSString *sign = [iOSRSAAndDesEncryption desSignUseMD5WithParamsString:[UtilityMethods httpRequestDicAndArraySort:params]];
    NSLog(@"desSignAndEncryptionWithParams:%@",sign);
    if (sign)
    {
        params[@"sign"] = sign;
        
        NSString *deskey = [[LDJRSAAndDES share].keyChainDic objectForKey:@"deskey"];
        if (deskey == nil)
        {
            NSLog(@"deskey is nil");
            return nil;
        }
        NSString *encryptStr = [iOSRSAAndDesEncryption desEncryptionWithParamsString:[params JSONString] key:deskey];
        NSLog(@"desSignAndEncryptionWithParams:%@",encryptStr);
        if (encryptStr)
        {
            return @{@"ciphertext":encryptStr};
        }
    }
    return nil;
}

+(NSDictionary *)desDecryptAndVerifySignWithParams:(NSMutableDictionary *)params
{
    NSString *deskey =[[LDJRSAAndDES share].keyChainDic objectForKey:@"deskey"];
    if (deskey == nil)
    {
        NSLog(@"deskey is nil");
        return nil;
    }
    NSString *decryptStr = [iOSRSAAndDesEncryption desDecryptWithDes:params[@"ciphertext"] key:deskey];
    NSLog(@"desDecryptAndVerifySignWithParams:%@",decryptStr);
    if (decryptStr)
    {
        NSMutableDictionary *responseDic = [NSMutableDictionary dictionaryWithDictionary:[decryptStr objectFromJSONString]];
        NSString *sign = responseDic[@"sign"];
        [responseDic removeObjectForKey:@"sign"];
        
        BOOL veriSucc = [iOSRSAAndDesEncryption desVerifySignWithParamsString:[responseDic JSONString] withMD5Sign:sign];
        NSLog(@"desDecryptAndVerifySignWithParams:%d",veriSucc);
        if (veriSucc)
        {
            return responseDic;
        }
    }
    return nil;
}

+(void)createRsaPublicKeyAndPrivateKey
{
    [iOSRSAAndDesEncryption createRSAPublicAndPrivateKey:^(NSString *publicKey, NSString *privateKey) {
        
        [[LDJRSAAndDES share] addToKeyChainWithDic:@{@"clientPrivate":privateKey,@"clientPublic":publicKey}];
    }];
}

-(void)addToKeyChainWithDic:(NSDictionary *)dic
{
    [[LDJRSAAndDES share].keyChainDic addEntriesFromDictionary:dic];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    [wrapper setObject:[[LDJRSAAndDES share].keyChainDic JSONString] forKey:(id)kSecValueData];
}

-(NSMutableDictionary *)keyChainDic
{
    if (!_keyChainDic)
    {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
        NSDictionary *dic = [(NSString *)[wrapper objectForKey:(id)kSecValueData] objectFromJSONString];
        if ([dic isKindOfClass:[NSDictionary class]])
        {
            _keyChainDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        }
        else
        {
            _keyChainDic = [NSMutableDictionary dictionary];
        }
    }
    return _keyChainDic;
}

@end
