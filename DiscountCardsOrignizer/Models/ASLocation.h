//
//  ASLocation.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/8/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASLocation : NSObject

@property (assign, nonatomic) NSUInteger iD;
@property (assign, nonatomic) NSInteger  placeId;
@property (assign, nonatomic) NSInteger  cardId;
@property (strong, nonatomic) NSString  *locationTitle;
@property (assign, nonatomic) double     longitude;
@property (assign, nonatomic) double     latitude;

+ (instancetype)createNewLocationWithLocationTitle:(NSString*)locationTitle
                                     withLongitude:(double)longitude
                                      withLatitude:(double)latitude
                                        withCardID:(NSInteger)cardID
                                       withPlaceID:(NSInteger)placeID
                                         andSelfID:(NSInteger)idValue;

@end
