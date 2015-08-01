//
//  ASIntroScreenViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASIntroScreenVC.h"
#import "ASTipsScreenVC.h"

@implementation ASIntroScreenVC

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    NSInteger delayInSeconds = 2.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        ASTipsScreenVC *tipsScreenVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASTipsScreenVC"];
        
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.viewControllers = @[tipsScreenVC];
    });
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
