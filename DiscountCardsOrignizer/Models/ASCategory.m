//
//  ASCategory.m
//  DiscountCardsOrganizer
//
//  Created by Alexandr Sergienko on 6/24/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASCategory.h"

@implementation ASCategory

+ (instancetype)createNewCategoryWithTitle:(NSString*)name
                                     image:(NSString*)imgTitle
                                 andSelfID:(NSInteger)idValue {
    
    ASCategory *newCategory = [[ASCategory alloc]init];
    newCategory.name = name;
    newCategory.imageTitle = imgTitle;
    newCategory.iD = idValue;
    
    return newCategory;
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.name];
}

@end
