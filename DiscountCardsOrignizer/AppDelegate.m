//
//  AppDelegate.m
//  DiscountCardsOrignizer
//
//  Created by Alexander Sergienko on 7/31/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "AppDelegate.h"
#import "ASDatabaseManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SWRevealViewController.h"


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate () <SWRevealViewControllerDelegate>
@property (strong, nonatomic) UIVisualEffectView *effectView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[ASDatabaseManager sharedManager]initializeDataBase];
    
    //API key from project (google account, console developers)
    [GMSServices provideAPIKey:@"AIzaSyDe6txcZAalvglFwddPI8iq3w5vZiumt78"];

    //PageControl settings.
    [self setDefaultPageControl];
    
    //I set in Plist (Status bar is initially hidden == YES) for LaunchImage, so here Status bar "come back,baby":).
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:1.000 green:0.345 blue:0.110 alpha:1.000]];
    
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
//        view.backgroundColor=[UIColor blackColor];
//        [self.window.rootViewController.view addSubview:view];
//    }
    
    SWRevealViewController* reveal = (SWRevealViewController*)self.window.rootViewController;
    reveal.delegate = self;

    
    return YES;
}


-(void)setDefaultPageControl {
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor orangeColor];
}


-(void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft){
        //[revealController.frontViewController.view setUserInteractionEnabled:YES];
        [revealController.frontViewController.revealViewController tapGestureRecognizer];
        [revealController.frontViewController.revealViewController panGestureRecognizer];
       
        //[self.effectView removeFromSuperview];
    }else{
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        self.effectView.frame = revealController.frontViewController.view.frame;
        
        //[revealController.frontViewController.view addSubview:self.effectView];
        //[revealController.frontViewController.view setUserInteractionEnabled:NO];
//        for (UIView *subView in revealController.frontViewController.view.subviews) {
//            [subView setUserInteractionEnabled:NO];
//        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}




@end
