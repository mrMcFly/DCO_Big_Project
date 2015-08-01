//
//  ViewController.h
//  ATestPageViewController
//
//  Created by Alexandr Sergienko on 7/18/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTipsScreenVC : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;

//for define width of this elements
@property (weak, nonatomic) IBOutlet UIView *messageButtonView;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end

