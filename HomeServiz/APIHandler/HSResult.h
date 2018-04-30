//
//  HSResult.h
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>


@interface HSResult : JSONModel

#define HSResultExtCode3004     @"3004"

// Loyalty
#define HSResultExtCode20008    @"20008"


/*! If this value is HSResultCodeOk, it means success. Otherwise, please refer to the error code. */
typedef NS_ENUM(NSInteger, HSResultCode) {
    
    /*! Response checksum didn't math*/
    HSResultResponseChecksumMismatch = -998,
    
    /*! Request Cancelled */
    HSResultCodeRequestInsecure = -999,
    
    /*! Parameter error */
    HSResultCodeInvalidMandatoryParam = -10,
    
    /*! Network Error */
    HSResultCodeNetworkNotAvailable = -9,
    
    /*! AuthenticateFail Security*/
    HSResultCodeAuthenticateFail = -8,
    
    HSResultCodeCannotConnectToHost = -5,
    
    /*! Network Connection Lost */
    HSResultCodeNetworkConnectionLost = -4,
    
    /*! Network Error */
    HSResultCodeNetworkTimeOut = -3,
    
    /*! Network Error */
    HSResultCodeNetworkError = -2,
    
    /*! Init Code (None-Code) */
    HSResultCodeInit = -1,
    
    /*! Success */
    HSResultCodeOk = 0,
    
    HSResultCodeAuthenticationFailed = 401,
    
    /*! Common Error */
    HSResultCodeInvalidParameter = 1,
    HSResultCodeParameterDecryptionFail = 2,
    HSResultCodeInvalidMessageFormat = 3,
    HSResultCodeUnknownResponseMessage = 4,
    HSResultCodeNoRecordsWereFound = 5,
    HSResultCodeJWTValidationFailed = 6,
    
    /*! Login Error */
    HSResultCodeRegisterMobileShouldBeDone = 1001,
    HSResultCodeMobileNumberIsNotWhitelisted = 1002,
    HSResultCodeThereIsNoMatchedMobileId = 1003,
    HSResultCodeMobileNumberIsAlreadyExistInIDAM = 1004,
    HSResultCodeMissingRequestStepForLogin = 1005,
    HSResultCodeAuthenticationFail = 1008,
    HSResultCodeUserLockedOut = 1012,
    HSResultCodeWalletIsNotActivated = 1015,
    //HSResultCodeSSOTokenHasBeenExpired = 1022,
    HSResultCodePinIsNotCorrect = 1023,
    HSResultCodeWalletPinIsLocked = 1024,
    HSResultCodeDeviceIsLocked = 1025,
    HSResultCodeCustomerIsBlocked = 1026,
    HSResultCodeCustomerIsSuspended = 1027,
    HSResultCodePhoneDateIsInaccurate = 1028,
    HSResultCodeMobileNumberDoesNotExistInIDAM = 1029,
    HSResultCodeMPinLoginIsRequired = 1030,
    HSResultCodeCustomerHasBeenTerminated = 1031,
    HSResultCodeAmlCheckFailed = 1032,
    HSResultCodeLoginMobileNumberInvalid = 1035,
    HSResultCodeInternalErrorHappened = 1099,
    
    /*! Wallet error */
    HSResultCodeFileNotFound = 2003,
    HSResultCodeMobileNotRegistered = 2006,
    HSResultCodeUserIDNotRegistered = 2008,
    HSResultCodeNoSuchTransactionIdExist = 2013,
    HSResultCodePushSendFail = 2025,
    HSResultCodeNoSuchWalletExist =    2028,
    HSResultCodeNoSuchServiceExists = 2031,
    HSResultCodeNoSuchProviderExists = 2034,
    HSResultCodeCustomerNotRegistered = 2036,
    HSResultCodeNoSuchServiceVersion = 2037,
    HSResultCodeSeIDIsDuplicated = 2039,
    HSResultCodeCustomerIsAlreadyRegistered = 2044,
    HSResultCodeMobileNumberIsAlreadyRegistered = 2046,
    HSResultCodeMobileNumberIsNotRegistered = 2047,
    HSResultCodeInputDataIsInvalid = 2048,
    HSResultCodeRegisteredSecurityAnswerDoesNotExist = 2049,
    HSResultCodeSecurityAnswerYouEnteredIsNotCorrect = 2050,
    HSResultCodeCustomerDoesNotExist = 2051,
    HSResultCodeSecurityAnswerAttemptsLimitExceeded =    2052,
    HSResultCodeYourOTPIsNotValid =    2053,
    HSResultCodeCustomerHasBeenAlreadySuspended = 2054,
    HSResultCodeCustomerHasBeenAlreadyActivated = 2055,
    HSResultCodeMobileDeviceHasBeenAlreadySuspended = 2056,
    HSResultCodeMobileDeviceHasBeenAlreadyActivated = 2057,
    HSResultCodeCustomerHasBeenAlreadyBlocked =    2058,
    HSResultCodeEnteredmPINIsNotAvailable =    2059,
    HSResultCodeSecurityAnswerIsAlreadyRegistered =    2060,
    HSResultCodeMPINHasNotBeenSet =    2061,
    HSResultCodeMPINHasAlreadyBeenSet =    2062,
    HSResultCodeNicknameOfBeneficiaryIsAlreadyExist = 2063,
    HSResultCodeYouCanSetSetMPINWithWeakSecurity = 2064,
    HSResultCodeToDateShouldBeBiggerThanFromDate = 2065,
    HSResultCodeNewPasswordIsTheSameWithOldPassword = 2066,
    HSResultCodeOldPasswordDoesNotMatch = 2067,
    HSResultCodeCustomerIsNotInSuspendedStatus = 2068,
    HSResultCodeResetPasswordRetryCount = 2079,
    HSResultCodeUpdateKycIsPending = 2080,
    HSResultCodeOtpCannotBeSendDueToManyUnverifiedOtpRequests = 2081,
    HSResultCodeInvalidPasswordFormat = 2082,
    
    /*! Merchant Error */
    HSResultCodeMerchantNotExist = 3003,
    HSResultCodeMerchantTipAlreadyDone = 3008,
    HSResultCodeMerchantTipElapseTime = 3009,
    
    HSResultCodeRequestedYourIdAlreadyExist = 3501,
    HSResultCodeRequestedYourNicknameAlreadyExist = 3502,
    HSResultCodeNoSubscriptionFoundAgainstEnterDetails = 3504,
    
    /*! Bill Payment Error */
    HSResultCodeThereIsNoValidResponse = 4001,
    HSResultCodeThePlanListIsInProcessOfUpdate = 4002,
    HSResultCodeValidationOfTransactionIsFailed = 4003,
    HSResultCodeInvalidAuthenticator = 4004,
    HSResultCodeAuthenticationDetailsAreInvalidOrNotPresent = 4005,
    HSResultCodeBillerAccountOrShortNameAlreadyExistsForThisUser = 4006,
    HSResultCodeInvalidBankReferenceNo = 4007,
    HSResultCodeInvalidBillerId = 4008,
    HSResultCodeInvalidBillNumber = 4009,
    HSResultCodeInvalidPaymentAmount = 4010,
    HSResultCodeCouldNotAscertainTheStatusOfYourTransactionFromThePaymentGateway = 4011,
    HSResultCodeInvalidBillerStatus = 4012,
    HSResultCodeCouldNotFindBiller = 4013,
    HSResultCodeConnectionTimeoutWithBillDesk = 4014,
    
    /*! Prepaid Error */
    HSResultCodeThisCardHasBeenAlreadyLinked = 5001,
    HSResultCodeLimitExceeded = 5002,
    HSResultCodeRequestedPinIsSameAsOldPin = 5003,
    HSResultCodeYouHaveExceededYourBalanceLimit = 5004,
    HSResultCodeYouHaveExceededYourAttemptsLimit = 5005,
    
    /*! Generic Error */
    HSResultCodeMessageArray = 6001,
    
    /*! Instrument Error */
    HSResultCodeInstrumentIsAlreadySaved = 7001,
    HSResultCodeInstrumentIDIsNotValid = 7002,
    HSResultCodeInstrumentIsAlreadyExpired= 7003,
    HSResultCodeInstrumentNameIncludesInvalidCharacter = 7005,
    
    /* Site Custom Error */
    HSResultCodeAmlSystemErrorOccurred = 9007,
    HSResultCodeCortexSystemErrorCccured = 9009,
    HSResultCodeUnknownError = 9999,
    
    /* Reward (Coupon, Loyalty) Error */
    HSResultRewardError = 10000,
    
    /* Request Money error Error */
    HSResultRequestMoneyError = 11004,
    
    /*! */
    HSResultCodeExpiredByOtherSession = 40111,
    
    /*IFSC Error Code*/
    HSResultCodeInValidIFSC = 10024
    
};

#pragma mark - httpStatusCode

// Default JSON Tags
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSArray *errors;
@property (strong, nonatomic) NSNumber *codeNum;
@property (strong, nonatomic) NSString *error_description;
@property (assign, nonatomic) HSResultCode      code;

/*! NSError */
@property (nonatomic,strong) NSError            *errorResponse;

/*! HTTP status code ex) 401, 500 */
@property (assign, nonatomic) NSInteger         httpStatusCode;

/*! Get the result code from server. */
@property (assign, nonatomic) HSResultCode      resultCode;

@property (strong, nonatomic) NSDictionary *responseBody;

@end
