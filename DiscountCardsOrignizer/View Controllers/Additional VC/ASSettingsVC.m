//
//  ASSettingsVC.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASSettingsVC.h"

@implementation ASSettingsVC

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.title = @"Settings";
    //[self setTextAndColorForNavigationBarAndStatusBar];
    
    self.navigationItem.title = @"Settings";

}


- (void)setTextAndColorForNavigationBarAndStatusBar {
    
    self.navigationItem.title = @"Settings";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.418 blue:0.099 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20,[UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
}

@end
