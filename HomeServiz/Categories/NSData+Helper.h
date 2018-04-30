//
//  NSData+Helper.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface NSData(Helper)

- (BOOL)isValid;
- (NSString *)mimeType;
- (NSString *)dataToHexSpacedString;
+ (NSData *)keyBitsFromSeckeyRef:(SecKeyRef)seckeyref;
@end
