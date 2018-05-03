//
//  HSOTPViewController.m
//  HomeServiz
//
//  Created by Bheema Badri on 03/05/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSOTPViewController.h"
#import "HSLoginAPI.h"

@interface HSOTPViewController () {
    
    __weak IBOutlet UITextField *otpField;
    __weak IBOutlet UILabel *timerLabel;
    __weak IBOutlet UILabel *otpLabel;

}

@end

@implementation HSOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self updateOtp];
}

-(void)updateOtp {
    otpLabel.text = [NSString stringWithFormat:@"Enter OTP sent to %@",self.loginResp.phone];
    
    otpField.text = self.loginResp.otp;

}

-(IBAction)login:(id)sender {
    
}

-(IBAction)resendOtp:(id)sender {
    
    [self showGlobalProgressView];
    NSMutableDictionary *body = [NSMutableDictionary new];
    [body setValue:self.loginResp.phone forKey:@"phone"];
    [[HSLoginAPI loginApi]getloginsuccessBlock:^(HSLoginResponse * _Nonnull response)  {
        if(response){
            self.loginResp = response;
            [self updateOtp];
            [self hideProgressView];
        }
    }inputDict:body failureBlock:^(HSLoginResponse * _Nonnull response) {
        [self hideProgressView];
        NSLog(@"FAilure");
        //[self handleError:response];
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
