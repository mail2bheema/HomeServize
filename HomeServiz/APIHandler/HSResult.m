//
//  HSResult.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSResult.h"

@implementation HSResult

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

-(void)setCodeWithNSNumber:(NSNumber *)codeNumber{
    _code = [codeNumber integerValue];
    _codeNum = codeNumber;
}

- (HSResultCode)resultCode{
    return _code;
}

@end
