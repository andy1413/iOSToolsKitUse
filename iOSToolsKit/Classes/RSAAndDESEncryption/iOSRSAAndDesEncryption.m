//
//  iOSRSAAndDesEncryption.m
//  iOSToolsKit
//
//  Created by 王方帅 on 17/5/8.
//  Copyright © 2017年 wangfangshuai. All rights reserved.
//

#import "iOSRSAAndDesEncryption.h"
#import "RSAEncryptor.h"
#import "HBRSAHandler.h"
#import "NSString+MD5.h"
#import "DesEncryption.h"
#import <CommonCrypto/CommonDigest.h>
#import "rsa.h"
#import "pem.h"

@implementation iOSRSAAndDesEncryption

+ (NSString *)rsaEncryptString:(NSString *)str publicKey:(NSString *)pubKey
{
    return [RSAEncryptor encryptString:str publicKey:pubKey];
}

+ (NSString *)rsaDecryptString:(NSString *)str privateKey:(NSString *)privKey
{
    return [RSAEncryptor decryptString:str privateKey:privKey];
}

+(NSString *)rsaSignWithParamsString:(NSString *)paramsString clientPrivateKey:(NSString *)privKey
{
    HBRSAHandler *hbsign = [[HBRSAHandler alloc] init];
    
    BOOL importSucc = [hbsign importKeyWithType:KeyTypePrivate andkeyString:privKey];
    if (importSucc)
    {
        NSString *signString = [hbsign signMD5String:paramsString];
        NSLog(@"RSA签名前明文=%@",paramsString);
        NSLog(@"RSA签名后=%@",signString);
        return signString;
    }
    else
    {
        NSLog(@"导入私有key失败");
        return @"";
    }
}

+(BOOL)rsaVerifySignWithParamsString:(NSString *)paramsString serverPublicKey:(NSString *)pubKey withSign:(NSString *)sign
{
    HBRSAHandler *hbsign = [[HBRSAHandler alloc] init];
    
    BOOL importSucc = [hbsign importKeyWithType:KeyTypePublic andkeyString:pubKey];
    if (importSucc)
    {
        BOOL veriSucc = [hbsign verifyMD5String:paramsString withSign:sign];
        NSLog(@"rsa验签是否成功=%d",veriSucc);
        return veriSucc;
    }
    else
    {
        NSLog(@"导入公有key失败");
        return NO;
    }
}

+(NSString *)desEncryptionWithParamsString:(NSString *)paramsString key:(NSString *)key
{
    return [DesEncryption encryptUseDES:paramsString key:key];
}

+(NSString *)desDecryptWithDes:(NSString *)paramsString key:(NSString *)key
{
    return [DesEncryption decryptUseDES:paramsString key:key];
}

+(NSString *)desSignUseMD5WithParamsString:(NSString *)paramsString
{
    return [paramsString MD5Digest];
}

+(BOOL)desVerifySignWithParamsString:(NSString *)paramsString withMD5Sign:(NSString *)md5Sign
{
    NSString *md5String = [paramsString MD5Digest];
    if ([md5String isEqualToString:md5Sign])
    {
        NSLog(@"des验签成功");
        return YES;
    }
    else
    {
        NSLog(@"des验签失败");
        return NO;
    }
}

+(void)createRSAPublicAndPrivateKey:(ReturnPublicAndPrivate)block{
    /*产生RSA密钥*/
    
    RSA*rsa =NULL;
    
    rsa =RSA_new();
    
    //产生一个模为num位的密钥对，e为公开的加密指数，一般为65537（0x10001）
    
    rsa =RSA_generate_key(1024,0x10001,NULL,NULL);
    
    //路径
    
    NSString*documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    /*提取公钥字符串*/
    
    //最终存储的地方，所以需要创建一个路径去存储字符串
    
    NSString*pubPath = [documentsPath stringByAppendingPathComponent:@"PubFile.txt"];
    
    FILE* pubWrite =NULL;
    
    pubWrite =fopen([pubPath UTF8String],"wb");
    
    if(pubWrite ==NULL)
        
        NSLog(@"Read Filed.");
    
    else
        
    {
        
        PEM_write_RSA_PUBKEY(pubWrite,rsa);
        
        fclose(pubWrite);
        
    }
    
    //    拿出字符串之后对字符串进行处理，这样就得到了我们需要的字符串了。
    
    NSString*str=[NSString stringWithContentsOfFile:pubPath encoding:NSUTF8StringEncoding error:nil];
    
    str = [str stringByReplacingOccurrencesOfString:@"-----BEGIN PUBLIC KEY-----"withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"-----END PUBLIC KEY-----"withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    
    /*提取私钥字符串*/
    
    NSString*priPath =[documentsPath stringByAppendingPathComponent:@"PriFile.txt"];
    
    FILE*priWtire =NULL;
    
    priWtire =fopen([priPath UTF8String],"wb");
    
    EVP_PKEY*pkey =NULL;
    
    if(priWtire ==NULL) {
        
        NSLog(@"ReadFiled.");
        
    }else{
        pkey =EVP_PKEY_new();
        
        EVP_PKEY_assign_RSA(pkey, rsa);
        
        PEM_write_PKCS8PrivateKey(priWtire, pkey,NULL,NULL,0,0,NULL);
        
        fclose(priWtire);
        
    }
    
    NSString*priStr=[NSString stringWithContentsOfFile:priPath encoding:NSUTF8StringEncoding error:nil];
    
    priStr = [priStr stringByReplacingOccurrencesOfString:@"-----BEGIN PRIVATE KEY-----"withString:@""];
    
    priStr = [priStr stringByReplacingOccurrencesOfString:@"-----END PRIVATE KEY-----"withString:@""];
    
    priStr = [priStr stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    
    block(str,priStr);
    NSLog(@"客户端公钥=%@",str);
    NSLog(@"客户端私钥=%@",priStr);
    
}

@end
