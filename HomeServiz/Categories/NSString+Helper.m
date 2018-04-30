//
//  NSString+Helper.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL) isValid{
    if ([self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL) isNonEmpty{
    if ([self isValid]) {
        if ([[self  stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (BOOL) isNotNullString{
    if ([self isNonEmpty]) {
        if ([self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"]) {
            return NO;
        }
        return YES;
    }
    return NO;
}
- (NSString *)mobileNumberDisplayString{
    if ([self isNonEmpty]) {
        return [NSString stringWithFormat:@"+91 %@",self];
    }
    return @"";
}

- (BOOL)vpaValidation {
 
    NSString *emailRegex = @"[A-Z0-9a-z.-]+@[A-Za-z0-9.-]+";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (NSString *)removingWhiteSpace{
    if ([self isNonEmpty]) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    }
    return @"";
}

+ (NSString *)addressStringForObject:(id)obj{
    return [NSString stringWithFormat:@"%p", obj];
}

- (NSString *)stringByRemovingCharacterPattern:(NSString *)pattern withString:(NSString *)string{
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *trimmedStr = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:string];
    
    return trimmedStr;
}

- (NSString *)hexSpacedStringToReadableString{
    NSMutableString * readbleStr = [NSMutableString string];
    
    NSArray * components = [self componentsSeparatedByString:@" "];
    for ( NSString * component in components ) {
        int value = 0;
        sscanf([component cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [readbleStr appendFormat:@"%c", (char)value];
    }
    return readbleStr;
}

- (NSData *)dataFromHexString{
    const char *chars = [self UTF8String];
    NSInteger i = 0, len = self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    
    return data;
}

//- (NSData *)sha256Data
//{
//    const char *str = [self UTF8String];
//    unsigned char result[CC_SHA256_DIGEST_LENGTH];
//    CC_SHA256(str, (CC_LONG) strlen(str), result);
//    return [NSData dataWithBytes:(const void *)result
//                          length:sizeof(unsigned char)*CC_SHA256_DIGEST_LENGTH];
//}

- (NSString *) urlEncodedString{
    //return self;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("%:/?#[]@!$&’()*+,;=~_-'"), kCFStringEncodingUTF8));
}

+ (NSData *)secKeyRefToData:(SecKeyRef)secKeyRef{
    size_t len =  SecKeyGetBlockSize(secKeyRef);
    NSData *keyData = [NSData dataWithBytes:secKeyRef length:len];
    return keyData;
}

+ (NSData *)secKeyRefToSHA256:(SecKeyRef)secKeyRef{
//    return [NSString SHA256FromNSData:[[self secKeyRefToData:secKeyRef] SHA256Hash]];
//}
//
//+ (NSData *)SHA256FromNSData:(NSData *)data{
//    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
//    if ( CC_SHA256([data bytes], (CC_LONG)[data length], hash) ) {
//        NSData *sha256 = [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
//        return sha256;
//    }
    return nil;
}

@end
