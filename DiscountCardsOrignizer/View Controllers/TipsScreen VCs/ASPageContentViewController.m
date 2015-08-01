//
//  ASPageContentViewController.m
//  ATestPageViewController
//
//  Created by Alexandr Sergienko on 7/18/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASPageContentViewController.h"

@interface ASPageContentViewController ()

@end

@implementation ASPageContentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tipsImage.image = [UIImage imageNamed:self.nameOfImage];
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




@end
