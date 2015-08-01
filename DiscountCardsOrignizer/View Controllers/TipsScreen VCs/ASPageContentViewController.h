//
//  ASPageContentViewController.h
//  ATestPageViewController
//
//  Created by Alexandr Sergienko on 7/18/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASPageContentViewController : UIViewController

@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) NSString *nameOfImage;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImage;

@end
