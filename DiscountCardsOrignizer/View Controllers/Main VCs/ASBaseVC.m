//
//  ASBaseViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASBaseVC.h"
#import "SWRevealViewController.h"
#import "ASAddNewCardVC.h"

@implementation ASBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.title = @"News";
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget:self.revealViewController];
        [self.sidebarButton setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self.addNewCardButton setTarget:self];
    [self.addNewCardButton setAction:@selector(actionAddNewCard:)];
    
    [self setTextAndColorForNavigationBarAndStatusBar];

}


- (void)actionAddNewCard:(UIBarButtonItem*)sender {
    
    NSLog(@"Add new Card");
    ASAddNewCardVC *addCardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASAddNewCardVC"];
    [self.navigationController pushViewController:addCardVC animated:YES];
}


- (void)setTextAndColorForNavigationBarAndStatusBar {
        
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.418 blue:0.099 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self setNeedsStatusBarAppearanceUpdate];
    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20,[UIScreen mainScreen].bounds.size.width, 20)];
//    statusBarView.backgroundColor = [UIColor blackColor];
    //[self.navigationController.navigationBar addSubview:statusBarView];
}

@end
