//
//  ASSideBarController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASSideBarVC.h"
#import "ASSidebarCell.h"

@interface ASSideBarVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleMenuItems;

@end


@implementation ASSideBarVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    CGRect tableViewFrame = CGRectMake(0,CGRectGetHeight(self.view.bounds) * 0.1 / 2, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds) * 0.9);
    
    //[self.tableView setFrame:tableViewFrame];
    
    
//    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    CGRect tableViewFrame = CGRectMake(0,CGRectGetHeight(self.view.bounds) * 0.1 / 2, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.tableView.bounds) * 0.9);
    
    //[self.tableView setFrame:tableViewFrame];
    
    
    //    self.view.backgroundColor = [UIColor redColor];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleMenuItems = @[@"Category",@"Map",@"Tips",@"Terms",@"Select color",@"Settings",@"About"];
    
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//
//    
//    CGRect tableViewFrame = CGRectMake(0,CGRectGetHeight(self.tableView.frame) * 0.3 / 2 , CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame) * 0.7);
//    
//    float a = CGRectGetHeight(self.tableView.frame) * 0.3 / 2;
//    NSLog(@"A= %f",a);
//    
//    [self.tableView setFrame:tableViewFrame];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.titleMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.titleMenuItems objectAtIndex:indexPath.row];
    NSLog(@"%@",CellIdentifier);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    return @"Menu";
//}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[UIApplication sharedApplication]isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    });
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGRect screenRect    = [[UIScreen mainScreen] bounds];
//    CGFloat screenHeight = CGRectGetHeight(screenRect);
//    CGFloat cellHeight   = screenHeight / [self.menuItems count];
    
    //CGRect screenRect    = [[UIScreen mainScreen] bounds];
    //CGFloat screenHeight = CGRectGetHeight(screenRect);
    
    //CGFloat cellHeight   = CGRectGetHeight(self.tableView.frame) / [self.titleMenuItems count] - 10;
    
    CGFloat cellHeight   = (CGRectGetHeight(self.tableView.frame) - CGRectGetHeight(self.view.frame) * 0.2)  / [self.titleMenuItems count] - (20 / 7);
    
    return cellHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    CGFloat heightForHeader = (CGRectGetHeight(self.view.frame) * 0.2 - 20) / 2;
    
    return heightForHeader;
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    view.tintColor = [UIColor blackColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

@end
