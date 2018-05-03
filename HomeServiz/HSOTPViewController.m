//
//  HSOTPViewController.m
//  HomeServiz
//
//  Created by Bheema Badri on 03/05/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "HSOTPViewController.h"

@interface HSOTPViewController () {
    
    __weak IBOutlet UITextField *otpField;
    __weak IBOutlet UILabel *timerLabel;
    __weak IBOutlet UILabel *otpLabel;

}

@end

@implementation HSOTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    otpField.text = self.resp.otp;
    // Do any additional setup after loading the view.
}

-(IBAction)login:(id)sender {
    
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
