//
//  ASPlace.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/15/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASPlace.h"

@implementation ASPlace

+(instancetype)createNewPlaceWithName:(NSString *)name
                          withAddress:(NSString *)address
                            withTypes:(NSString *)types
                      withPhoneNumber:(NSString *)phoneNumber
                          withWebsite:(NSString *)website
                        openingHourse:(NSString *)hourse
                             vicinity:(NSString *)vicinity
                              plaseID:(NSString *)placeID
                            andSelfID:(NSInteger)idValue {
    
    ASPlace *newPlace = [[ASPlace alloc]init];
    
    newPlace.name           = name;
    newPlace.address        = address;
    newPlace.types          = types;
    newPlace.phoneNumber    = phoneNumber;
    newPlace.website        = website;
    newPlace.openinigHourse = hourse;
    newPlace.vicinity       = vicinity;
    newPlace.placeID        = placeID;
    newPlace.iD             = idValue;

    return newPlace;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"name %@, address %@, placeID %@ ", self.name, self.address, self.placeID];
}


@end
