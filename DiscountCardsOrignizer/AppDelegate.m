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


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface AppDelegate ()

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
    
    return YES;
}


-(void)setDefaultPageControl {
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor orangeColor];
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
