//
//  DesEncryption.h
//  JDMEForIphone
//
//  Created by  L on 14-8-12.
//  Copyright (c) 2014年 jd.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesEncryption : NSObject
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key ;//解密

@end
