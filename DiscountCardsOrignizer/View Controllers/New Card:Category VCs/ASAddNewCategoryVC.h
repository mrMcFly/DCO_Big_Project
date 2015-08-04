//
//  ASNewCategoryVC.h
//  DiscountCardsOrganizer
//
//  Created by Alexandr Sergienko on 6/25/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseVC.h"
#import "ASCategoryIconsVC.h"


@interface ASAddNewCategoryVC : ASBaseVC //<ASCategoryIconsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameOfCategoryField;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

- (IBAction)actionAddImageForNewCategory:(UIButton *)sender;
- (IBAction)actionSaveResult:(UIButton *)sender;


@end
