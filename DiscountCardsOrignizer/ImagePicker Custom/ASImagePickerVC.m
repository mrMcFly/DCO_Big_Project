//
//  ASImagePickerVC.m
//  DiscountCardsOrignizer
//
//  Created by Alexander Sergienko on 8/1/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASImagePickerVC.h"

@interface ASImagePickerVC ()

@end

@implementation ASImagePickerVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //Color for status bar.
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor=[UIColor blackColor];
        [self.view addSubview:view];
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
