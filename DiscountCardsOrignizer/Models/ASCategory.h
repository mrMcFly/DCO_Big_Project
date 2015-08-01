//
//  ASCategory.h
//  DiscountCardsOrganizer
//
//  Created by Alexandr Sergienko on 6/24/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ASCategory : NSObject

@property (assign, nonatomic) NSUInteger iD;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageTitle;


+ (instancetype)createNewCategoryWithTitle:(NSString*)name
                                     image:(NSString*)imgTitle
                                 andSelfID:(NSInteger)idValue;

@end
