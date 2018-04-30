//
//  BaseViewController.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showProgressView:(BOOL) isGlobal;
- (void)showGlobalProgressView;
- (void)hideProgressView;

@end
