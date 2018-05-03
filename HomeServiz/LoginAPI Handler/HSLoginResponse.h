//
//  HSLOginResponse.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSAPIResponse.h"
#import "UserModel.h"

@interface HSLoginResponse : HSAPIResponse
//@property (strong, nonatomic, nullable) UserModel *response;
@property (nullable, nonatomic, strong) NSString <Optional>*uid;
@property (nullable, nonatomic, strong) NSString <Optional>*name;
@property (nullable, nonatomic, strong) NSString <Optional>*email;
@property (nullable, nonatomic, strong) NSString <Optional>*phone;
@property (nullable, nonatomic, strong) NSString <Optional>*gender;
@property (nullable, nonatomic, strong) NSString <Optional>*password;
@property (nullable, nonatomic, strong) NSString <Optional>*image;
@property (nullable, nonatomic, strong) NSString <Optional>*source;
@property (nullable, nonatomic, strong) NSString <Optional>*fcmId;
@property (nullable, nonatomic, strong) NSString <Optional>*otp;
@property (nullable, nonatomic, strong) NSString <Optional>*isVerified;
@property (nullable, nonatomic, strong) NSString <Optional>*referCodeStatus;
@property (nullable, nonatomic, strong) NSString <Optional>*referToCode;
@property (nullable, nonatomic, strong) NSString <Optional>*referByCode;
@property (nullable, nonatomic, strong) NSString <Optional>*country;
@property (nullable, nonatomic, strong) NSString <Optional>*ustatus;
@property (nullable, nonatomic, strong) NSString <Optional>*token;
@property (nullable, nonatomic, strong) NSString <Optional>*deviceId;
@property (nullable, nonatomic, strong) NSString <Optional>*dob;
@property (nullable, nonatomic, strong) NSString <Optional>*isSocial;
@property (nullable, nonatomic, strong) NSString <Optional>*userName;

@property (nullable, nonatomic, strong) NSArray <Optional>*cities;
//@property (nullable, nonatomic, strong) NSArray <Optional>*tax;

@end
