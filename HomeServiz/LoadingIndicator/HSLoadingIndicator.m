//
//  HSLoadingIndicator.m
//  HomeServiz
//
//  Created by Bheema Badri on 27/04/18.
//  Copyright © 2018 Bheema Badri. All rights reserved.
//


#import "HSLoadingIndicator.h"

@implementation HSLoadingIndicator

HSLoadingIndicator *loadingSharedInstance;

+ (HSLoadingIndicator *)sharedInstances {
    static dispatch_once_t _onceToken;
    dispatch_once(&_onceToken, ^{
        loadingSharedInstance = [[self alloc] init];
    });
    return loadingSharedInstance;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureUI];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI{
    self.contentMode = UIViewContentModeScaleAspectFit;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int count = 0; count < 60; count++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%05d.png",count]];
        if (image) {
            [array addObject:image];
        }
    }
    self.animationImages = array;
    self.animationDuration = 1.6f;
    self.animationRepeatCount = 0;
    self.hidden = YES;
}

- (void)startAnimating{
    [super startAnimating];
    self.hidden = NO;
}

- (void)stopAnimating{
    [super stopAnimating];
    self.hidden = YES;
}

@end
