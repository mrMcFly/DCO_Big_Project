//
//  ASLocation.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/8/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASLocation.h"

@implementation ASLocation


+ (instancetype)createNewLocationWithLocationTitle:(NSString*)locationTitle
                                     withLongitude:(double)longitude
                                      withLatitude:(double)latitude
                                        withCardID:(NSInteger)cardID
                                       withPlaceID:(NSInteger)placeID
                                         andSelfID:(NSInteger)idValue {

    ASLocation *newLocation = [[ASLocation alloc]init];
    newLocation.locationTitle = locationTitle;
    newLocation.longitude = longitude;
    newLocation.latitude = latitude;
    newLocation.cardId = cardID;
    newLocation.placeId = placeID;
    newLocation.iD = idValue;
    
    return newLocation;
}

@end
