//
//  ViewController.m
//  HomeServiz
//
//  Created by Bheema Badri on 26/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "ViewController.h"
#import "HSLoginAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self login];
}
-(void)login {
    [self showGlobalProgressView];
    
    [[HSLoginAPI loginApi]getloginsuccessBlock:^(HSLoginResponse * _Nonnull response) {
        if(response){
            [self hideProgressView];
            NSLog(@"Success");
        }
    } failureBlock:^(HSLoginResponse * _Nonnull response) {
        [self hideProgressView];
        NSLog(@"FAilure");

        //[self handleError:response];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
