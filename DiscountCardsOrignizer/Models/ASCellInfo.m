//
//  ASCellInfo.m
//  DiscountCardsOrignizer
//
//  Created by Alexander Sergienko on 8/3/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import "ASCellInfo.h"

@implementation ASCellInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@,/// location = %@, place = %@", self.imageOfCell, self.titleOfCell, self.location, self.place];
}

@end
