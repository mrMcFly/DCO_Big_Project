//
//  ASShowAllNearestPlacesVC.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/14/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASGooglePlacesConnection.h"


@interface ASShowAllNearestPlacesVC : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CLLocationManager  *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *locations;
//@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) ASGooglePlacesConnection *googlePlacesConnection;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (nonatomic, getter = isResultsLoaded) BOOL resultsLoaded;

//==============================================
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double latitude;
//==============================================

//@property (strong, nonatomic) NSString *chosenPlace;
@property (strong, nonatomic) GooglePlacesObject *placeObj;

- (IBAction)actionConfirmSelection:(UIButton*)sender;

@end
