//
//  ASMapViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASMapShowAllCardsVC.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

#import "ASDatabaseManager.h"
#import "ASLocation.h"
#import "ASMapAnnotation.h"

@interface ASMapShowAllCardsVC () <MKMapViewDelegate,  CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *locationsOfCardsArray;

@end


@implementation ASMapShowAllCardsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self mapViewSetup];
    
    //load all locations
    [self loadAndShowAllCardsLoctions];
    
    //[self setTextAndColorForNavigationBarAndStatusBar];
    self.navigationItem.title = @"All cards";
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    [self.locationManager startUpdatingLocation];
    //    NSLog(@"%@", [self deviceLocation]);
    //
    //    //View Area
    //    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    //    region.center.latitude = self.locationManager.location.coordinate.latitude;
    //    region.center.longitude = self.locationManager.location.coordinate.longitude;
    //    region.span.longitudeDelta = 0.005f;
    //    region.span.longitudeDelta = 0.005f;
    //    [self.mapView setRegion:region animated:YES];
}


- (void)setTextAndColorForNavigationBarAndStatusBar {
    
    //self.navigationItem.title = @"CATEGORIES";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.418 blue:0.099 alpha:1.000];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20,[UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
}


- (void) mapViewSetup {

    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
#endif
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (NSString *)deviceLocation {
    
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

- (NSString *)deviceLat {
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}

- (NSString *)deviceLon {
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}

- (NSString *)deviceAlt {
    
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}


- (IBAction)actionShowMainMenu:(id)sender {
    
    NSLog(@"actionShowMainMenu");
}


#pragma mark - Main function

//Main function to determine and show area rect for all cards locations.
- (void) showAllCardsLocations {
    
    //MapRect set to null
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        
        //An MKMapPoint data structure represents a point on this two-dimensional map.
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 20000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2 , delta * 2);
        
        
        zoomRect = MKMapRectUnion(zoomRect, rect); //union function
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}


- (void)loadAndShowAllCardsLoctions {
    
    self.locationsOfCardsArray = [[ASDatabaseManager sharedManager]getAllDataFromDBtableName:@"location"];
    
    [self addAllLocationsToTheAnnotations:self.locationsOfCardsArray];
}


- (void)addAllLocationsToTheAnnotations:(NSArray*)locationsArray {
    
    for (ASLocation *location in self.locationsOfCardsArray) {
        
        ASMapAnnotation *newCardAnnotation = [[ASMapAnnotation alloc]init];
        newCardAnnotation.title = location.locationTitle;
        CLLocationCoordinate2D locatonCordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        newCardAnnotation.coordinate =  locatonCordinate;
        [self.mapView addAnnotation:newCardAnnotation];
    }
    
    [self showAllCardsLocations];
}

@end

