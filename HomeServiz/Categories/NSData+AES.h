//
//  NSData+AES.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSData+CommonCrypto.h"

@interface NSData(AES)

- (NSData *)AES128EncryptedDataWithKey:(id)key;
- (NSData *)AES128DecryptedDataWithKey:(id)key;

@end
