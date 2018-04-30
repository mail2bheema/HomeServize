//
//  HSAPIResponse+Utility.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSAPIResponse+Utility.h"
#import "NSString+Helper.h"

static uint32_t const kMaxArrayedMessageShown = 6;

#pragma mark - Error Messages
static NSString *const kError_Message_No_Internet_Connection = @"Please check your internet connection.";
static NSString *const kError_Message_No_connection_timeout = @"The connection timed out.";
static NSString *const kError_Message_Logout = @"You are being logged Out. Please Re-Login.";
static NSString *const kError_Message_Insecure_Connection = @"Unable to connect to server. Please try after sometime";
static NSString *const kError_Message_Default = @"Unable to process your request. Please try again later.";
static NSString *const kError_Unable_to_connect_to_HSM = @"unable to connect to HSM";


@implementation HSAPIResponse (Utility)

#pragma mark - Error Parsing

- (NSString *)extractMessageFromResponse{
    NSString *message = [self message];
    
    if ([[self errorResponse] code] == -999 && [[[self errorResponse] userInfo] objectForKey:@"isInSecure"]) {
        message = kError_Message_Insecure_Connection;
        self.code = HSResultCodeRequestInsecure;
        return message;
    }
    
    if ([[self errorResponse] code] == -1001){
        message = kError_Message_No_connection_timeout;
        return message;
    }
    
    if([[self errorResponse] code] == -1009) {
        message = kError_Message_No_Internet_Connection;
        return message;
    }
    
    if (![message isNonEmpty]) {
        message = [self error_description];
    }
    
    if ([self code] == HSResultCodeMessageArray) {
        message = [self extractArrayedMessage:message];
    }
    
    if (![message isNonEmpty] && [[self errors] count] > 0) {
        uint32_t count = 0;
        for (NSDictionary *error in [self errors]) {
            NSString *value = [error objectForKey:@"message"];
            NSString *errorMsg = nil;
            if ([value isNonEmpty]) {
                errorMsg = [NSString stringWithFormat:@"%@.",value];
            }
            if (count == 0) {
                message = errorMsg;
                if (!message) {
                    message = [NSString string];
                }
            }
            else{
                if ([errorMsg isNonEmpty]) {
                    message = [message stringByAppendingString:errorMsg];
                }
            }
            count++;
        }
    }
    
    if (![message isNonEmpty] && self.httpStatusCode >= 300) {
        message = kError_Message_Default;
    }
    
    if ([[message lowercaseString] isEqualToString:[kError_Unable_to_connect_to_HSM lowercaseString]]) {
        message = kError_Message_Default;
    }
    
    return message;
}

- (NSString *)extractArrayedMessage:(NSString *)messageArray{
    
    NSError *error;
    NSString *entireMsg = [NSString string];
    
    NSDictionary *msgJSON = [NSJSONSerialization JSONObjectWithData:[messageArray dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if (msgJSON) {
        BOOL first = YES;
        uint32_t msgShown = 0;
        
        for (NSString *key in msgJSON) {
            NSString *localMsg = nil;
            if (first) {
                localMsg = [NSString stringWithFormat:@"%@ :", key];
                first = NO;
            }
            else{
                localMsg = [NSString stringWithFormat:@"\n\n%@ :", key];
            }
            NSArray *messages = [msgJSON objectForKey:key];
            
            uint32_t count= 0;
            for (NSString *msg in messages) {
                localMsg = [localMsg stringByAppendingString:[NSString stringWithFormat:@"\n\u2022 %@", msg]];
                count++;
                msgShown++;
            }
            
            entireMsg = [entireMsg stringByAppendingString:localMsg];
            
            if (msgShown == kMaxArrayedMessageShown) {
                break;
            }
        }
    }
    return entireMsg;
}

#pragma mark - Validate Response

//- (BOOL)sanitizeValidateResponse{
//    BOOL success = NO;
//    if(![self isKindOfClass:[NSClassFromString(@"HSValidateTransactionResponse") class]]){
//        return success;
//    }
//
//    HSValidateTransactionResponse *validateResponse = (HSValidateTransactionResponse *)self;
//
//    NSArray <HSTransactionBill> *bills = [validateResponse bills];
//    HSTransactionBill *bill = [bills firstObject];
//    NSString *billAmount = bill.billAmount;
//
//    if ([[validateResponse bills] count] > 0) {
//
//        if ([billAmount caseInsensitiveCompare:@"NA"] == NSOrderedSame || ![billAmount isNonEmpty]) {
//            if ([validateResponse isPayWithOutBill]) {
//                // The amount field will be enabled.
//                [bill setBillAmount:@"0"];
//                [validateResponse setBills:bills];
//                [validateResponse setIsPartialPayment:YES];
//
//                success = YES;
//            }
//            else{
//                // Show Error
//                success = NO;
//            }
//        }
//        else{
//            // Let the default values propogate
//            success = YES;
//        }
//    }
//    else{
//        if ([validateResponse isPayWithOutBill]) {
//            // Do Nothing
//            [bill setBillAmount:@"0"];
//            [validateResponse setBills:bills];
//            success = YES;
//        }
//        else{
//            // Show ERROR
//            success = NO;
//        }
//    }
//
//    return success;
//}

@end
