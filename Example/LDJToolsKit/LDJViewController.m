//
//  LDJViewController.m
//  LDJToolsKit
//
//  Created by wangfangshuai on 05/09/2017.
//  Copyright (c) 2017 wangfangshuai. All rights reserved.
//

#import "LDJViewController.h"
#import "LDJRSAAndDES.h"

#import "KeychainItemWrapper.h"
#import "JSONKit.h"

@interface LDJViewController ()

@end

@implementation LDJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [LDJRSAAndDES createRsaPublicKeyAndPrivateKey];
    
    [[LDJRSAAndDES share].rsaKeyDic addEntriesFromDictionary:@{@"serverPublicKeyStrInClient":[[LDJRSAAndDES share].rsaKeyDic objectForKey:@"clientPublic"]}];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    [wrapper setObject:[[LDJRSAAndDES share].rsaKeyDic JSONString] forKey:(id)kSecValueData];
    
    
    NSDictionary *encryptionDic = [LDJRSAAndDES rsaSignAndEncryptionWithParams:[NSMutableDictionary dictionaryWithDictionary:@{@"111":@"http://www.baidu.com"}]];
    NSLog(@"%@",encryptionDic);
    NSDictionary *decryptDic = [LDJRSAAndDES rsaDecryptAndVerifySignWithParams:[NSMutableDictionary dictionaryWithDictionary:encryptionDic]];
    NSLog(@"%@",decryptDic);
    
    [[LDJRSAAndDES share].rsaKeyDic addEntriesFromDictionary:@{@"deskey":@"1111"}];
    
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Encryption" accessGroup:nil];
    [wrapper setObject:[[LDJRSAAndDES share].rsaKeyDic JSONString] forKey:(id)kSecValueData];
    encryptionDic = [LDJRSAAndDES desSignAndEncryptionWithParams:[NSMutableDictionary dictionaryWithDictionary:@{@"111":@"http://www.baidu.com"}]];
    NSLog(@"%@",encryptionDic);
    decryptDic = [LDJRSAAndDES desDecryptAndVerifySignWithParams:[NSMutableDictionary dictionaryWithDictionary:encryptionDic]];
    NSLog(@"%@",decryptDic);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
