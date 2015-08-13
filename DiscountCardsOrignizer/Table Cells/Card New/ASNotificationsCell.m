//
//  ASNotificationsCell.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASNotificationsCell.h"

@implementation ASNotificationsCell


- (void)awakeFromNib {
    // Initialization code
    
    self.confirmNotificationsButton.layer.cornerRadius = 5.f;
    self.confirmNotificationsButton.layer.borderColor = [UIColor purpleColor].CGColor;
    self.confirmNotificationsButton.layer.borderWidth = 1.f;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)actionConfirmOrCancelNotifications:(UIButton *)sender {
    
    NSLog(@"actionConfirmOrcancelNotifications");
}


@end
