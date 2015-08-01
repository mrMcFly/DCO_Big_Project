//
//  ASAllCardListVC.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/10/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"
#import "ASCategory.h"

@interface ASAllCardListVC : ASBaseVC

@property (strong, nonatomic) ASCategory *specificChosenCategory;

- (IBAction)actionShowCategoryVC:(UIButton*)sender;
- (IBAction)actionShowMapWithAllCardsLocationsVC:(UIButton*)sender;

@end
