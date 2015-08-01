//
//  ASAddNewCardViewController.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"
#import "ASCategory.h"

@interface ASAddNewCardVC : ASBaseVC

//might be different values.

//Different nav. title for Create and Edit.
@property (strong, nonatomic) NSString *navigationTitle;

//when we in some type of category and we tap on create new card,them VC "add new card" has default string in 'category' textField (choose category).
@property (strong, nonatomic) ASCategory *categoryForNewCard;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)actionSaveNewCard:(id)sender;
- (IBAction)actionSelectMenu:(id)sender;

@end
