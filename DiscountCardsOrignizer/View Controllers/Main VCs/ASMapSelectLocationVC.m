//
//  ASMapSelectLocationVC.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/7/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//


#import "ASMapSelectLocationVC.h"
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "ASMapAnnotation.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ASMapSelectLocationVC () <UITextFieldDelegate ,CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) ASMapAnnotation *annotationOfCard;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation ASMapSelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self setGestureForAddNewLocationForCard];
    
    [self mapViewSetup];

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [self.mapView setRegion:region animated:YES];
    
    [self.locationManager startUpdatingLocation];

    self.geoCoder = [[CLGeocoder alloc]init];

}



- (void)viewWillDisappear:(BOOL)animated
{
    if (self.locationManager)
    {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
    [super viewWillDisappear:animated];
}


- (void)dealloc
{
    if ([self.geoCoder isGeocoding]) {
        
        [self.geoCoder cancelGeocode];
    }
}

#pragma mark - Additionals

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


- (void) mapViewSetup {

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

//#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            // Use one or the other, not both. Depending on what you put in info.plist
            //[self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }
    }
//#endif
    [self.locationManager startUpdatingLocation];

    //Default values in storyboard for MapView
//    self.mapView.showsUserLocation = YES;
//    [self.mapView setMapType:MKMapTypeStandard];
//    [self.mapView setZoomEnabled:YES];
//    [self.mapView setScrollEnabled:YES];
    
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"Segue!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
}


#pragma mark - MKMapViewDelegate methods.

//list of methods to track map state

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
    //NSLog(@"regionWillChangeAnimated");
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
   // NSLog(@"regionDidChangeAnimated");
    
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
//NSLog(@"mapViewWillStartLoadingMap");
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
   // NSLog(@"mapViewDidFinishLoadingMap");
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    
    //NSLog(@"mapViewDidFailLoadingMap");
}


- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView {
    
    //NSLog(@"mapViewWillStartRenderingMap");
}



- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
   // NSLog(@"mapViewDidFinishRenderingMap fullyRendered %d", fullyRendered);
}


// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //user position is annotation also,so we chech it
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *identifier = @"AnnotationIdentifier";
    
    
    MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
    }else{ //if pin exist we just change annotation
        
        pin.annotation = annotation;
    }
    
    return pin;
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
//    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startUpdatingLocation];
}



#warning check if this method do anything (NOT WORKING)
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        
        CLLocationCoordinate2D location = view.annotation.coordinate;
        MKMapPoint point = MKMapPointForCoordinate(location);
        
        self.longitude = location.longitude;
        self.latitude = location.latitude;
        
        NSLog(@"location = {%f, %f}\npoint = %@", location.latitude, location.longitude, MKStringFromMapPoint(point));
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
//    self.latitudeValue.text = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    self.longtitudeValue.text = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    NSLog(@"%@ %@", latitude, longitude);
    
}


#pragma mark - UITextFieldDelegate

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    //    UIView *view = [self.view viewWithTag:textField.tag + 1];
//    //    if (!view) {
//    //        [textField resignFirstResponder];
//    //    }else{
//    //        [view becomeFirstResponder];
//    //    }
//
//    [textField resignFirstResponder];
//
//    return YES;
//}


#pragma mark - Actions

- (IBAction)actionConfirmLocationOfCard:(UIButton*)sender {
    
    [[self navigationController] popViewControllerAnimated:YES];
    
    //save and\or return string location value
    //[self performSegueWithIdentifier:@"createCreateNewCardSegue" sender:nil];
}


- (void) setGestureForAddNewLocationForCard {
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(actionAddNewCardLocation:)];
    longGesture.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:longGesture];
    
}


- (void) actionAddNewCardLocation:(UIGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.annotationOfCard) {
            [self.mapView removeAnnotation:self.annotationOfCard];
            self.annotationOfCard = nil;
        }
        //        else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //            [self.mapView removeGestureRecognizer:recognizer];
        //        }
        
        self.annotationOfCard = [[ASMapAnnotation alloc]init];
        
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        self.longitude = touchMapCoordinate.longitude;
        self.latitude = touchMapCoordinate.latitude;
        
        //actions to determine user friendly info about location
        CLLocation *locationOfCard =
        [[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude
                                  longitude:touchMapCoordinate.longitude];
        
        if ([self.geoCoder isGeocoding]) {
            
            [self.geoCoder cancelGeocode];
        }
        NSLog(@"Geocoder = %@", self.geoCoder);
        [self.geoCoder reverseGeocodeLocation:locationOfCard completionHandler:^(NSArray *placemarks, NSError *error) {

            NSString *message = nil;
            
            if (error) {
                NSLog(@"Error");
               // message = [error localizedDescription];
                message = @"Undefined place";
                
            }else{
                
                if ([placemarks count] > 0) {
                    
                    //В этом классе вся информация о местоположении (улица,адресс,etc) Далее список информации:
                    /*@property (nonatomic, readonly, copy) NSDictionary *addressDictionary;
                     
                     // address dictionary properties
                     @property (nonatomic, readonly, copy) NSString *name; // eg. Apple Inc.
                     @property (nonatomic, readonly, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
                     @property (nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
                     @property (nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
                     @property (nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
                     @property (nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
                     @property (nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
                     @property (nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
                     @property (nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
                     @property (nonatomic, readonly, copy) NSString *country; // eg. United States
                     @property (nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
                     @property (nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
                     @property (nonatomic, readonly, copy) NSArray *areasOfInterest; // eg. Golden Gate Park*/
                    MKPlacemark *placeMark = [placemarks firstObject];
                    
                    //description метод описание,который выведет информацию с дикшионари (это @property у MKPlacemark)Хотя message и объект класса NSString,но благодаря методу description мы подгоняем dictionary под NSString.
                    //message = [placeMark.addressDictionary description];
                    //                    NSString *infoStringAboutLocation = [NSString stringWithFormat:@"%@,%@", [placeMark.addressDictionary objectForKey:@"Street"], [placeMark.addressDictionary objectForKey:@"SubAdministrativeArea"]];
                    
                    NSArray *infoLocationArray = [placeMark.addressDictionary objectForKey:@"FormattedAddressLines"];
                    
                    if ([infoLocationArray count] > 1) {
                        
                        NSString *locationStreet = [infoLocationArray objectAtIndex:0];
                        NSString *locationArea = [infoLocationArray objectAtIndex:1];
                        
                        NSString *infoStringAboutLocation = [NSString stringWithFormat:@"%@, %@", locationStreet, locationArea];
                        
                        message = infoStringAboutLocation;
                        
                    }else {
                        message = @"Undefined place";
                    }
                    
                }else{
                    message = @"No Placemarks Found";
                }
            }
            
            if ([message isEqualToString:@"Undefined place"]) {
                //self.selectedLocationForCardField.text = message;
                self.selectedLocationForCardField.text = message;
            }else {
                self.selectedLocationForCardField.text = message;
            }
            
        }];
        
        self.annotationOfCard.coordinate = touchMapCoordinate;
        
        [self.mapView addAnnotation:self.annotationOfCard];
    }
}


@end
