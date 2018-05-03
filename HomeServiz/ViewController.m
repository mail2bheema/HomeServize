//
//  ViewController.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "ViewController.h"
#import "HSLoginAPI.h"
#import "HSOTPViewController.h"

@interface ViewController () {
    
    __weak IBOutlet UITextField *textField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self login];
}

-(IBAction)continueRegister:(id)sender {
    
    [self showGlobalProgressView];
    NSMutableDictionary *body = [NSMutableDictionary new];
    [body setValue:textField.text forKey:@"phone"];
    [[HSLoginAPI loginApi]getloginsuccessBlock:^(HSLoginResponse * _Nonnull response)  {
        if(response){
            [self hideProgressView];
            [self navigateToOtp:response];
        }
    }inputDict:body failureBlock:^(HSLoginResponse * _Nonnull response) {
        [self hideProgressView];
        NSLog(@"FAilure");
        //[self handleError:response];
    }];

}

-(void)navigateToOtp:(HSLoginResponse*)tempResp {
    UIStoryboard *str = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HSOTPViewController *obj = [str instantiateViewControllerWithIdentifier:@"HSOTPViewController"];
    obj.resp = tempResp;
    [self.navigationController pushViewController:obj animated:YES];

}
-(IBAction)faceBookRegister:(id)sender {
    
}

-(IBAction)gmailRegister:(id)sender {
    
}

-(void)login {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
