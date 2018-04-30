//
//  HSLoadingView.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//



#import "HSLoadingView.h"
#import "HSLoadingIndicator.h"

@interface HSLoadingView()

@property (strong, nonatomic) HSLoadingIndicator *brandedIndicatorView;

@end

@implementation HSLoadingView
{
}

HSLoadingView *loadingViewSharedInstance;

+ (HSLoadingView *)sharedInstances {
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        loadingViewSharedInstance = [[self alloc] initWithFrame:CGRectZero];
    });
    return loadingViewSharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (void)addOnView:(UIView *)view {

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:0];
    [view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1 constant:0];
    [view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:80];
    [view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:80];
    [view addConstraint:constraint];
    [self layoutIfNeeded];
}

- (void)addGlobalLoadingIndicator {

    _brandedIndicatorView = [HSLoadingIndicator sharedInstances];
    [self addSubview:_brandedIndicatorView];
    [self addIndicatorConstraint];
    [_brandedIndicatorView startAnimating];
}

- (void)initialiseLoadingIndicator {
    
    _brandedIndicatorView = [[HSLoadingIndicator alloc] initWithFrame:CGRectZero];
    [self addSubview:_brandedIndicatorView];
    [self addIndicatorConstraint];
    [_brandedIndicatorView startAnimating];
}

- (void)addIndicatorConstraint {
    
    [_brandedIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint;
    constraint = [NSLayoutConstraint constraintWithItem:_brandedIndicatorView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_brandedIndicatorView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1 constant:0];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_brandedIndicatorView
                                              attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:self.frame.size.width-30];
    [self addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:_brandedIndicatorView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1 constant:self.frame.size.height-30];
    [self addConstraint:constraint];
    [self layoutIfNeeded];
}

- (void)stopAnimating {

    [_brandedIndicatorView stopAnimating];
}

@end
