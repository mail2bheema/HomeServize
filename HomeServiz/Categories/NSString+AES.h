//
//  NSString+AES.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString(AES)

- (NSString *)AES128EncryptStringWithkey:(id)key;
- (NSString *)AES128DecryptStringWithkey:(id)key;

- (NSData *)AES128EncryptedDataWithkey:(id)key;
- (NSData *)AES128DecryptedDataWWithkey:(id)key;

- (NSString *)encryptedBase64AES128StringWithCardNumber;
- (NSString *)decryptedCardNumberWithBase64AES128EncryptedCardNumber;

@end
