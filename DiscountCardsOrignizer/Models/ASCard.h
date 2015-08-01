//
//  ASCard.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCard : NSObject

@property (assign, nonatomic) NSUInteger iD;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *expDate;
@property (assign, nonatomic) NSUInteger category_id;
@property (assign, nonatomic) NSUInteger photo_id;

+ (ASCard *)createNewCardWithName:(NSString*)name
                      withExpDate:(NSString*)expDate
                   withCategoryID:(NSInteger)categoryID
                          photoID:(NSInteger)photoID
                        andSelfID:(NSInteger)idValue;

@end
