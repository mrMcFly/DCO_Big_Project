//
//  ASCategoryIconsViewController.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"
@protocol ASCategoryIconsViewControllerDelegate;


@interface ASCategoryIconsVC : ASBaseVC //UIViewController

@property (weak, nonatomic) id <ASCategoryIconsViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *categoryImage;

@end


@protocol  ASCategoryIconsViewControllerDelegate <NSObject>

- (void) saveChoosenIconForNewCategory: (ASCategoryIconsVC*) categoryIconsVC withIndex:(NSInteger) iconIndex;

@end