//
//  ASNewCategoryVC.m
//  DiscountCardsOrganizer
//
//  Created by Alexandr Sergienko on 6/25/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASAddNewCategoryVC.h"
#import "ASCategory.h"
#import "ASDatabaseManager.h"
#import "ASCategoryIconsVC.h"
#import "ASAddNewCardVC.h"

#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


@interface ASAddNewCategoryVC () <UITextFieldDelegate>

@property (strong, nonatomic) ASCategory *category;

@end


@implementation ASAddNewCategoryVC

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.category = [[ASCategory alloc]init];
    
    self.iconButton.layer.cornerRadius = 10.f;
    self.iconButton.layer.borderWidth = 2.f;
    self.iconButton.layer.borderColor = [UIColor colorWithRed:0.468 green:0.525 blue:0.684 alpha:1.000].CGColor;
    self.iconButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.662 blue:0.071 alpha:1.000];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.832 blue:0.487 alpha:1.000];
}


- (IBAction)actionAddImageForNewCategory:(UIButton *)sender {
    
    NSLog(@"actionAddImageForNewCategory");
}


- (IBAction)actionSaveResult:(UIButton *)sender {
    
    NSLog(@"actionSaveResult");
    
    if ([self isItEnoughParametersForSavingNewCategory]) {
        
        NSString *recordName = self.category.name;
        NSString *recordImage = self.category.imageTitle;
        NSLog(@"recordName = %@", recordName);
        NSLog(@"recordImage = %@", recordImage);
        
        [[ASDatabaseManager sharedManager]
         insertCategoryRecordDataInDBtableWithName:recordName
                                          andImage:recordImage];
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
        [self performSegueWithIdentifier:@"unwindToMainVC" sender:nil];
    }else {
        
        [self showAlertForNotFilledCategoryFields];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldRaplace = true;
    
    return shouldRaplace;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.nameOfCategoryField.text = textField.text;
    self.category.name = textField.text;
}


//#pragma mark - ASCategoryIconsViewControllerDelegate
//- (void) saveChoosenIconForNewCategory: (ASCategoryIconsVC*) categoryIconsVC withIndex:(NSInteger) iconIndex {
//    
////    NSString *imageName = [NSString stringWithFormat:@"IconImage%ld",(long)iconIndex];
////    NSLog(@"category image name= %@", imageName);
//    UIImage *iconImg = [UIImage imageNamed:categoryIconsVC];
//    [self.iconButton setBackgroundImage:iconImg forState:UIControlStateNormal];
//    self.category.imageTitle = imageName;
//}


//#pragma mark - Segue
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    UIViewController *VC = segue.destinationViewController;
//    
//    if ([VC isKindOfClass:[ASCategoryIconsVC class]]) {
//        ((ASCategoryIconsVC*)VC).delegate = self;
//    }
//}


//-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
//    
//    if ([segue.identifier isEqualToString:@"unwindAddNewCategoryVC"]) {
//        ASCategoryIconsVC *iconsVC = segue.sourceViewController;
//        NSString *chosenCategoryImage = iconsVC.categoryImage;
//        //UIImage *iconImg = [UIImage imageNamed:chosenCategoryImage];
//        NSLog(@"IMAGE = %@", chosenCategoryImage);
//        UIImage *imageForCategory = [UIImage imageNamed:chosenCategoryImage];
//        [self.iconButton setBackgroundImage:imageForCategory forState:UIControlStateNormal];
//        self.category.imageTitle = chosenCategoryImage;
//    }
//}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
    if ([segue.identifier isEqualToString:@"unwindAddNewCategoryVC"]) {
        
        ASCategoryIconsVC *iconsVC = segue.sourceViewController;
        NSString *chosenCategoryImage = iconsVC.categoryImage;

        UIImage *imageForCategory = [UIImage imageNamed:chosenCategoryImage];
        //[self.iconButton setBackgroundImage:imageForCategory forState:UIControlStateNormal];
        self.categoryImage.image = imageForCategory;
        self.category.imageTitle = chosenCategoryImage;
    }
}


#pragma mark - Additional

- (BOOL)isItEnoughParametersForSavingNewCategory {
    
    BOOL weCanSave;
    
    if (self.category.name.length > 0 && self.category.imageTitle) {
        weCanSave = YES;
    }else {
        weCanSave = NO;
    }
    
    return weCanSave;
}


- (void)showAlertForNotFilledCategoryFields {
    
    NSString *alertTitle = @"Note";
    NSString *alertMessage = @"Category should have name and an image";
    NSString *alertCancel = @"Ok";
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [[[UIAlertView alloc]initWithTitle:alertTitle
                                   message:alertMessage
                                  delegate:nil
                         cancelButtonTitle:alertCancel
                         otherButtonTitles:nil]show];
        
    }else {
        
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:alertTitle
                                            message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:alertCancel
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES
                         completion:nil];
    }
}

@end
