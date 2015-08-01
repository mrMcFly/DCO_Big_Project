//
//  ASMapViewController.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"


@interface ASMapShowAllCardsVC : ASBaseVC

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (IBAction)actionShowMainMenu:(id)sender;

@end
