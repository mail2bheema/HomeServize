//
//  HSLoadingView.h
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLoadingView : UIView

+ (HSLoadingView *)sharedInstances;
- (void)addOnView:(UIView *)view;

- (void)addGlobalLoadingIndicator;
- (void)initialiseLoadingIndicator;
- (void)stopAnimating;

@end
