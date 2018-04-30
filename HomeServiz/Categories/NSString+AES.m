//
//  NSString+AES.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "NSString+AES.h"
#import "NSData+CommonCrypto.h"
#import "NSData+AES.h"

static NSString *const garbageData = @"3d49b7dcaf80bdfa0a8d782ee91b6947";

@implementation NSString(AES)

- (NSString *)AES128EncryptStringWithkey:(id)key{
    CCCryptorStatus *errorEncryption = nil;
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] dataEncryptedUsingAlgorithm:kCCAlgorithmAES128 key:key options:kCCOptionPKCS7Padding | kCCOptionECBMode error:errorEncryption];
    NSString *encryptedString = [[NSString alloc] initWithData:encryptedData encoding:NSUTF8StringEncoding];
    return encryptedString;
}

- (NSString *)AES128DecryptStringWithkey:(id)key{
    CCCryptorStatus *errorEncryption = nil;
    NSData *decryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:key options:kCCOptionPKCS7Padding | kCCOptionECBMode error:errorEncryption];
    NSString *encryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return encryptedString;
}

- (NSData *)AES128EncryptedDataWithkey:(id)key{
    CCCryptorStatus *errorEncryption = nil;
    NSData *encryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] dataEncryptedUsingAlgorithm:kCCAlgorithmAES128 key:key options:kCCOptionPKCS7Padding | kCCOptionECBMode error:errorEncryption];
    return encryptedData;
}

- (NSData *)AES128DecryptedDataWWithkey:(id)key{
    CCCryptorStatus *errorEncryption = nil;
    NSData *decryptedData = [[self dataUsingEncoding:NSUTF8StringEncoding] decryptedDataUsingAlgorithm:kCCAlgorithmAES128 key:key options:kCCOptionPKCS7Padding | kCCOptionECBMode error:errorEncryption];
    return decryptedData;
}

- (NSString *)encryptedBase64AES128StringWithCardNumber{
    // As Discussed with Gaurav, Do Not Encrypt
    return self;
//    NSData *keyData = [garbageData dataFromHexString];
//    NSData *encryptedData = [self AES128EncryptedDataWithkey:keyData];
//    NSString *base64EncryptedCardNumber = [[NSString alloc] initWithData:[encryptedData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
//    return base64EncryptedCardNumber;
}

- (NSString *)decryptedCardNumberWithBase64AES128EncryptedCardNumber{
    // As Discussed with Gaurav, Do Not Decrypt
    return self;
//    NSData *keyData = [garbageData dataFromHexString];
//    NSData *dataToDecrypt = [[NSData alloc] initWithBase64EncodedString:self options:0];
//    NSData *decryptedData = [dataToDecrypt AES128DecryptedDataWithKey:keyData];
//    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
//    return decryptedString;
}

@end
