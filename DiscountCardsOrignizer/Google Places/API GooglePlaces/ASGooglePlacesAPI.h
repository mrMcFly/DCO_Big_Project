//
//  ASGooglePlacesAPI.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/15/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kGOOGLE_API_KEY @"AIzaSyDe6txcZAalvglFwddPI8iq3w5vZiumt78"


@interface ASGooglePlacesAPI : NSObject

@property (nonatomic, assign) BOOL connectionIsActive;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *responseData;

+(instancetype)sharedInstance;

- (void)getFirstInfoFromCoordinates:(CLLocationCoordinate2D)coordinate;

@end
