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

+(NSDictionary *)rsaSignAndEncryptionWithParams:(NSMutableDictionary *)params
{
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    NSString *privateKey = [wrapper objectForKey:@"clientPrivate"];
    if (privateKey == nil)
    {
        NSLog(@"clientPrivate is nil");
        return nil;
    }
    NSString *sign = [iOSRSAAndDesEncryption rsaSignWithParamsString:[UtilityMethods dicSort:params] clientPrivateKey:privateKey];
    NSLog(@"rsaSignAndEncryptionWithParams:%@",sign);
    if (sign)
    {
        params[@"sign"] = sign;
        NSString *pubKey = [wrapper objectForKey:@"serverPublicKeyStrInClient"];
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
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    NSString *private =[wrapper objectForKey:@"clientPrivate"];
    if (private == nil)
    {
        NSLog(@"clientPrivate is nil");
        return nil;
    }
    NSString *decryptStr = [iOSRSAAndDesEncryption rsaDecryptString:[params JSONString] privateKey:private];
    NSLog(@"rsaDecryptAndVerifySignWithParams:%@",decryptStr);
    if (decryptStr)
    {
        NSMutableDictionary *responseDic = [NSMutableDictionary dictionaryWithDictionary:[decryptStr objectFromJSONString]];
        NSString *sign = responseDic[@"sign"];
        [responseDic removeObjectForKey:@"sign"];
        
        NSString *serverPublic =[wrapper objectForKey:@"serverPublicKeyStrInClient"];
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
    NSString *sign = [iOSRSAAndDesEncryption desSignUseMD5WithParamsString:[UtilityMethods dicSort:params]];
    NSLog(@"desSignAndEncryptionWithParams:%@",sign);
    if (sign)
    {
        params[@"sign"] = sign;
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
        NSString *deskey = [wrapper objectForKey:@"deskey"];
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
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    NSString *deskey =[wrapper objectForKey:@"deskey"];
    if (deskey == nil)
    {
        NSLog(@"deskey is nil");
        return nil;
    }
    NSString *decryptStr = [iOSRSAAndDesEncryption desDecryptWithDes:[params JSONString] key:deskey];
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
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
        [wrapper setObject:privateKey forKey:@"clientPrivate"];
        [wrapper setObject:privateKey forKey:@"clientPublic"];
    }];
}

@end
