//
//  ASCardImageCell.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASCardImageCell.h"

@implementation ASCardImageCell

- (void)awakeFromNib {
    // Initialization code
    self.imgButton.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
