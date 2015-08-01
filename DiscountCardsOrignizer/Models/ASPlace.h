//
//  ASPlace.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/15/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPlace : NSObject

@property (assign, nonatomic) NSInteger iD;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *types;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *openinigHourse;
@property (strong, nonatomic) NSString *vicinity;
@property (strong, nonatomic) NSString *placeID;

+(instancetype)createNewPlaceWithName:(NSString *)name
                          withAddress:(NSString *)address
                            withTypes:(NSString *)types
                      withPhoneNumber:(NSString *)phoneNumber
                          withWebsite:(NSString *)website
                        openingHourse:(NSString *)hourse
                             vicinity:(NSString *)vicinity
                              plaseID:(NSString *)placeID
                            andSelfID:(NSInteger)idValue;

@end
