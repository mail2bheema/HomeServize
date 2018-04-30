//
//  NSString+Helper.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (Helper)

- (BOOL) isValid;

- (BOOL) isNonEmpty;

- (NSString *)mobileNumberDisplayString;

- (BOOL) isNotNullString;

+ (NSString *)addressStringForObject:(id)obj;

- (NSString *)stringByRemovingCharacterPattern:(NSString *)pattern withString:(NSString *)string;

- (NSString *)hexSpacedStringToReadableString;

- (NSData *)dataFromHexString;

- (BOOL)vpaValidation;

- (NSString *)removingWhiteSpace;

- (NSData *)sha256Data;

+ (NSData *)secKeyRefToData:(SecKeyRef)secKeyRef;
+ (NSData *)secKeyRefToSHA256:(SecKeyRef)secKeyRef;
+ (NSData *)SHA256FromNSData:(NSData *)data;

- (NSString *) urlEncodedString;

@end
