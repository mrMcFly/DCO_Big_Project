//
//  ASLocationAndPlaceCell.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/15/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCardDetailsLocationAndPlaceCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lacotionLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

- (IBAction)actionMoreInfoAboutPlace:(UIButton*)sender;

@end
