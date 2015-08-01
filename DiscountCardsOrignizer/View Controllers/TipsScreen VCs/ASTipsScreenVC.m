//
//  ViewController.m
//  ATestPageViewController
//
//  Created by Alexandr Sergienko on 7/18/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASTipsScreenVC.h"
#import "ASPageContentViewController.h"

@interface ASTipsScreenVC ()

@end

@implementation ASTipsScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.pageImages = @[@"screen1.png", @"screen2.png",@"screen3.png"];
    
    // Hide Navigation Bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self setDefaultPageViewControl];

    
    [self setNeedsStatusBarAppearanceUpdate];
    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//    statusBarView.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar addSubview:statusBarView];

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ASPageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ASPageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


#pragma mark - Additional

- (void) setDefaultPageViewControl {
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    ASPageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(self.messageButtonView.frame) - CGRectGetHeight(self.skipButton.frame) +7);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}


- (ASPageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ASPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ASPageContentViewController"];
    pageContentViewController.nameOfImage = self.pageImages[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
