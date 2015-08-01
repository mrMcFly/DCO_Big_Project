//
//  ASMapSelectLocationVC.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ASMapSelectLocationVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *selectedLocationForCardField;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double latitude;

//just test to check return path
@property (strong, nonatomic) NSIndexPath* indexPath;

- (IBAction)actionConfirmLocationOfCard:(UIButton*)sender;

@end
