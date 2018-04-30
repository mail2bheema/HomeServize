//
//  NSData+Helper.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "NSData+Helper.h"

@implementation NSData(Helper)

- (BOOL)isValid{
    if (self && [self isKindOfClass:[NSData class]] && [self length] > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)mimeType{
    NSString *mimeType = nil;
    
    if (![self isValid]) {
        return mimeType;
    }
    
    uint8_t c;
    [self getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            mimeType = @"image/jpeg";
            break;
        case 0x89:
            mimeType = @"image/png";
            break;
        case 0x47:
            mimeType = @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            mimeType = @"image/tiff";
            break;
        case 0x25:
            mimeType = @"application/pdf";
            break;
        case 0xD0:
            mimeType = @"application/vnd";
            break;
        case 0x46:
            mimeType = @"text/plain";
            break;
        default:
            mimeType = @"application/octet-stream";
    }
    return mimeType;
}

- (NSString *)dataToHexSpacedString{
    NSUInteger i, len;
    unsigned char *buf, *bytes;
    
    len = self.length;
    bytes = (unsigned char*)self.bytes;
    buf = malloc(len*2);
    
    for (i=0; i<len; i++) {
        buf[i*2] = itoh((bytes[i] >> 4) & 0xF);
        buf[i*2+1] = itoh(bytes[i] & 0xF);
    }
    
    return [[NSString alloc] initWithBytesNoCopy:buf
                                          length:len*2
                                        encoding:NSASCIIStringEncoding
                                    freeWhenDone:YES];
}

static inline char itoh(int i) {
    if (i > 9) return 'A' + (i - 10);
    return '0' + i;
}

+ (NSData *)keyBitsFromSeckeyRef:(SecKeyRef)seckeyref{
    static const uint8_t publicKeyIdentifier[] = "Whatever Identifier it is";
    NSData *publicTag = [[NSData alloc] initWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    
    OSStatus sanityCheck = noErr;
    NSData * publicKeyBits = nil;
    
    NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
    
    // Set the public key query dictionary.
    [queryPublicKey setObject:(id)kSecClassKey forKey:(id)kSecClass];
    [queryPublicKey setObject:publicTag forKey:(id)kSecAttrApplicationTag];
    [queryPublicKey setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    [queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecReturnData];
    
    // Get the key bits.
    sanityCheck = SecItemCopyMatching((CFDictionaryRef)queryPublicKey, (void *)&publicKeyBits);
    
    if (sanityCheck != noErr){
        publicKeyBits = nil;
    }
    
    return publicKeyBits;
}

@end
