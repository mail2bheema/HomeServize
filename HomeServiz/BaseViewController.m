//
//  BaseViewController.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "HSLoadingView.h"
#import "HSLoadingIndicator.h"

@interface BaseViewController () {
    UIView *loadingView;
    UIView *loadingFalseView;
    HSLoadingIndicator *brandedIndicatorView;
    HSLoadingView *loadingIndicatorView;
    UILabel *indicatorLabel;
    //    BOOL pinScreenisPresent;

}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showProgressView:(BOOL) isGlobal {
    AppDelegate *appDelegate = [AppDelegate appDelegate];
    loadingIndicatorView = [HSLoadingView sharedInstances];
    if (!isGlobal) {
        [self.view addSubview:loadingIndicatorView];
        [loadingIndicatorView addOnView:self.view];
        
    }
    else {
        [appDelegate.window addSubview:loadingIndicatorView];
        [loadingIndicatorView addOnView:appDelegate.window];
    }
    [loadingIndicatorView addGlobalLoadingIndicator];
}

- (void)showGlobalProgressView {
    [self showProgressView:YES];
}

- (void)hideProgressView {
    if (loadingIndicatorView) {
        [loadingIndicatorView stopAnimating];
        [loadingIndicatorView removeFromSuperview];
        loadingIndicatorView = nil;
    }
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
