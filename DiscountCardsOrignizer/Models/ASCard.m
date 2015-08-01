//
//  ASCard.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASCard.h"

@implementation ASCard

+ (ASCard *)createNewCardWithName:(NSString*)name
                      withExpDate:(NSString*)expDate
                   withCategoryID:(NSInteger)categoryID
                          photoID:(NSInteger)photoID
                        andSelfID:(NSInteger)idValue {
    
    ASCard *newCard = [[ASCard alloc]init];
    newCard.name = name;
    newCard.expDate = expDate;
    newCard.category_id = categoryID;
    newCard.photo_id = photoID;
    newCard.iD = idValue;
    
    return newCard;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %lu %lu %lu", self.name, self.expDate, (unsigned long)self.category_id, (unsigned long)self.photo_id, (unsigned long)self.iD];
}
@end

