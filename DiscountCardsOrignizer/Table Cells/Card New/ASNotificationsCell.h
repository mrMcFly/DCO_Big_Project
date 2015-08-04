//
//  ASNotificationsCell.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASNotificationsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *confirmNotificationsButton;

- (IBAction)actionConfirmOrCancelNotifications:(UIButton *)sender;

@end
