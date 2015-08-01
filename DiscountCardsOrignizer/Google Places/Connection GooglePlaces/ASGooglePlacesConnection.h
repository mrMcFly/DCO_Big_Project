//
//  ASGooglePlacesConnection.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/14/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlacesObject.h"
#import <MapKit/MapKit.h>

@protocol GooglePlacesConnectionDelegate;

@interface ASGooglePlacesConnection : NSObject
{
    NSMutableData       *responseData;
    NSURLConnection     *connection;
    BOOL                connectionIsActive;
    int                 minAccuracyValue;
    //NEW
    CLLocationCoordinate2D userLocation;
}

@property (nonatomic, weak) id <GooglePlacesConnectionDelegate> delegate;
@property (nonatomic, retain) NSMutableData     *responseData;
@property (nonatomic, retain) NSURLConnection   *connection;
@property (nonatomic, assign) BOOL              connectionIsActive;
@property (nonatomic, assign) int               minAccuracyValue;
//NEW
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;

// useful functions
-(id)initWithDelegate:(id)del;

-(void)getGoogleObjectsWithQuery:(NSString *)query
                  andCoordinates:(CLLocationCoordinate2D)coords
                        andTypes:(NSString *)types;

-(void)getGoogleObjects:(CLLocationCoordinate2D)coords
               andTypes:(NSString *)types;

-(void)getGoogleObjectDetails:(NSString*)reference;

-(void)cancelGetGoogleObjects;

@end


@protocol GooglePlacesConnectionDelegate

- (void) googlePlacesConnection:(ASGooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects;
- (void) googlePlacesConnection:(ASGooglePlacesConnection *)conn didFailWithError:(NSError *)error;

@end