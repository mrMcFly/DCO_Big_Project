//
//  ASGooglePlacesAPI.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/15/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASGooglePlacesAPI.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GooglePlacesObject.h"


@interface ASGooglePlacesAPI ()

@property (strong, nonatomic) GMSPlacesClient *placesClient;

@end


@implementation ASGooglePlacesAPI

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.placesClient = [GMSPlacesClient sharedClient];
    }
    return self;
}


- (void)getFirstInfoFromCoordinates:(CLLocationCoordinate2D)coordinate {
    
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;
    
    NSString* gurl  = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=500&key=%@", latitude, longitude, kGOOGLE_API_KEY];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:gurl]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
    
    [self cancelGetPlacesObjects];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (self.connection)
    {
        self.responseData = [NSMutableData data];
        self.connectionIsActive = YES;
    }
    else {
        NSLog(@"connection failed");
    }

}


- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}


- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}


- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    self.connectionIsActive = NO;
    //[delegate googlePlacesConnection:self didFailWithError:error];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    self.connectionIsActive = NO;
    
    NSString *responseString    = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSError *jsonError          = nil;
    
    //==================================================================
    NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    //then simply use the JSONObjectWithData method to convert it to JSON
    
    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //NSLog(@"parsedJSON : %@", parsedJSON);
    //==================================================================
    
    if ([jsonError code]==0)
    {
        NSString *responseStatus = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
        
        if ([responseStatus isEqualToString:@"OK"])
        {
            if ([parsedJSON objectForKey: @"results"] == nil) {
                //Perform Place Details results
                NSDictionary *gResponseDetailData = [parsedJSON objectForKey: @"result"];
                NSMutableArray *googlePlacesDetailObject = [NSMutableArray arrayWithCapacity:1];  //Hard code since ONLY 1 result will be coming back
                
                NSLog(@"Responce Json = %@", gResponseDetailData);
                
//                GooglePlacesObject *detailObject = [[GooglePlacesObject alloc] initWithJsonResultDict:gResponseDetailData andUserCoordinates:userLocation];
//                [googlePlacesDetailObject addObject:detailObject];
                
                //[delegate googlePlacesConnection:self didFinishLoadingWithGooglePlacesObjects:googlePlacesDetailObject];
                
            } else {
                //Perform Place Search results
                NSArray *gResponseData  = [parsedJSON objectForKey: @"results"];
                NSMutableArray *googlePlacesObjects = [NSMutableArray arrayWithCapacity:[[parsedJSON objectForKey:@"results"] count]];
                
                /*
                //-=================================================================
                NSLog(@"gResponseData !!!!+++=%@", gResponseData);
                //NSLog(@"object_id = %@", [gResponseData objectForKey:@"place_id"]);
                NSLog(@"%lu",(unsigned long)[gResponseData count]);
                //NSArray ar = [NSArray arrayWithArray:gResponseData];
                NSString *str = [gResponseData objectAtIndex:1];
                NSLog(@"------------------------------------------------------%@",str);
                
                NSDictionary *dic = [gResponseData objectAtIndex:0];
                NSLog(@"===============================================DICTYONARY %@",dic);
                NSString *placeID = [dic objectForKey:@"place_id"];
                NSLog(@"place_id = %@",placeID);
                 //===================================================================
                */
                
                for (NSDictionary *result in gResponseData)
                {
                    [googlePlacesObjects addObject:result];
                }
                
                for (int x=0; x<[googlePlacesObjects count]; x++)
                {
//                GooglePlacesObject *object = [[GooglePlacesObject alloc] initWithJsonResultDict:[googlePlacesObjects objectAtIndex:x] andUserCoordinates:userLocation];
//                [googlePlacesObjects replaceObjectAtIndex:x withObject:object];
                }
//                
//                [delegate googlePlacesConnection:self didFinishLoadingWithGooglePlacesObjects:googlePlacesObjects];
                
            }
            
        }
        else if ([responseStatus isEqualToString:@"ZERO_RESULTS"])
        {
            NSString *description = nil;
            int errCode;
            
            description = NSLocalizedString(@"No locations were found.", @"");
            errCode = 404;
            
            // Make underlying error.
            NSError *underlyingError = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain
                                                                  code:errno userInfo:nil];
            // Make and return custom domain error.
            NSArray *objArray = [NSArray arrayWithObjects:description, underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,
                                 NSUnderlyingErrorKey, nil];
            NSDictionary *eDict = [NSDictionary dictionaryWithObjects:objArray
                                                              forKeys:keyArray];
            
            NSError *responseError = [NSError errorWithDomain:@"GoogleLocalObjectDomain"
                                                         code:errCode
                                                     userInfo:eDict];
            
            //[delegate googlePlacesConnection:self didFailWithError:responseError];
        } else {
            // no results
            NSString *responseDetails = [NSString stringWithFormat:@"%@",[parsedJSON objectForKey:@"status"]];
            NSError *responseError = [NSError errorWithDomain:@"GoogleLocalObjectDomain"
                                                         code:500
                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:responseDetails,@"NSLocalizedDescriptionKey",nil]];
            
            //[delegate googlePlacesConnection:self didFailWithError:responseError];
        }
    }
    else
    {
        //[delegate googlePlacesConnection:self didFailWithError:jsonError];
    }
}


- (void)cancelGetPlacesObjects
{
    if (self.connectionIsActive == YES) {
        self.connectionIsActive = NO;
    }
}


@end
