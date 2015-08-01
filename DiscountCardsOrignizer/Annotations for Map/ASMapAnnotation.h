//
//  ASMapAnnotation.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/8/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ASMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
