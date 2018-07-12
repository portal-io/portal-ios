//
//  NSData+AES256.h
//  WhaleyVR
//
//  Created by Xie Xiaojian on 2016/11/21.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "WVRGlobalUtil.h"

@interface NSData(AES256)

- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;

@end
