//
//  ASCardImageCell.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCardImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *imgButton;
@property (strong, nonatomic) UIImage *chosenImage;
//@property (weak, nonatomic) UISwitch *swithElem;
//@property (weak, nonatomic) id <ASCardImageCellDelegate> delegate;

@end



