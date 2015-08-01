//
//  ASCardDetailInfoVC.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/14/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"
#import "ASCard.h"

@interface ASCardDetailInfoVC : ASBaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ASCard *chosenCard;

- (IBAction)actionShowCategory:(UIButton*)sender;
- (IBAction)actionShowMap:(UIButton*)sender;

@end
