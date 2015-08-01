//
//  GooglePlacesObject.m
// 
// Copyright 2011 Joshua Drew
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GooglePlacesObject.h"
#import <MapKit/MapKit.h>

@implementation GooglePlacesObject

@synthesize placeId;
@synthesize reference;
@synthesize name;
@synthesize icon;
@synthesize rating;
@synthesize vicinity;
@synthesize type;
@synthesize url;
@synthesize addressComponents;
@synthesize formattedAddress;
@synthesize formattedPhoneNumber;
@synthesize website;
@synthesize internationalPhoneNumber;
@synthesize coordinate;
//NEW
@synthesize distanceInFeetString;
@synthesize distanceInMilesString;
@synthesize searchTerms;

-(id)initWithName:(NSString *)theName 
         latitude:(double)lt 
        longitude:(double)lg 
        placeIcon:(NSString *)icn 
           rating:(NSString *)rate 
         vicinity:(NSString *)vic 
             type:(NSArray *)typ 
        reference:(NSString *)ref 
              url:(NSString *)www 
addressComponents:(NSArray *)addComp 
 formattedAddress:(NSString *)fAddrss 
formattedPhoneNumber:(NSString *)fPhone
          website:(NSString *)web
internationalPhone:(NSString *)intPhone
      searchTerms:(NSString *)search
   distanceInFeet:(NSString *)distanceFeet
  distanceInMiles:(NSString *)distanceMiles
         placeID:(NSString*)placeID
{
    
    if (self = [super init])
    {
        [self setName:theName];
        [self setIcon:icn];
        [self setRating:rate];
        [self setVicinity:vic];
        [self setType:typ];
        [self setReference:ref];
        [self setUrl:www];
        [self setAddressComponents:addComp];
        [self setFormattedAddress:fAddrss];
        [self setFormattedPhoneNumber:fPhone];
        [self setWebsite:web];
        [self setInternationalPhoneNumber:intPhone];
        [self setSearchTerms:search];
        
        [self setCoordinate:CLLocationCoordinate2DMake(lt, lg)];
        
        [self setDistanceInFeetString:distanceFeet];
        [self setDistanceInMilesString:distanceMiles];
        [self setPlaceId:placeId];
        
    }
    return self;
    
}



- (instancetype)initWithName:(NSString *)theName
                   placeIcon:(NSString *)thePlaceIcon
                    vicinity:(NSString *)theVicinity
                   reference:(NSString *)theReference
                         url:(NSString *)theUrl
                     placeID:(NSString *)thePlaceID
                    latitude:(double)theLatitude
                   longitude:(double)theLongitude
{
    
    if (self = [super init])
    {
        self.name       = theName;
        self.coordinate = CLLocationCoordinate2DMake(theLatitude, theLongitude);
        self.icon       = thePlaceIcon;
        self.vicinity   = theVicinity;
        self.reference  = theReference;
        self.url        = theUrl;
        self.placeId    = thePlaceID;
    }
    return self;
}

//=======================================================================================================

//UPDATED
-(id)initWithJsonResultDict:(NSDictionary *)jsonResultDict
                searchTerms:(NSString *)terms
         andUserCoordinates:(CLLocationCoordinate2D)userCoords
{
    
    NSDictionary *geo = [jsonResultDict objectForKey:@"geometry"];
    NSDictionary *loc = [geo objectForKey:@"location"];
    
    //Figure out Distance from POI and User
    CLLocation *poi = [[CLLocation alloc] initWithLatitude:[[loc objectForKey:@"lat"] doubleValue]  longitude:[[loc objectForKey:@"lng"] doubleValue]];
    CLLocation *user = [[CLLocation alloc] initWithLatitude:userCoords.latitude longitude:userCoords.longitude];
    CLLocationDistance inFeet = ([user distanceFromLocation:poi]) * 3.2808;
    
    CLLocationDistance inMiles = ([user distanceFromLocation:poi]) * 0.000621371192;
    
    NSString *distanceInFeet = [NSString stringWithFormat:@"%.f", round(2.0f * inFeet) / 2.0f];
    NSString *distanceInMiles = [NSString stringWithFormat:@"%.2f", inMiles];
    
    //NSLog(@"Total Distance %@ in feet, distance in files %@",distanceInFeet, distanceInMiles);
    
    NSString *places_id = [jsonResultDict objectForKey:@"place_id"];
    NSLog(@"place_id  = %@", places_id);
    
//	return [self initWithName:[jsonResultDict objectForKey:@"name"] 
//                     latitude:[[loc objectForKey:@"lat"] doubleValue]
//                    longitude:[[loc objectForKey:@"lng"] doubleValue]
//                    placeIcon:[jsonResultDict objectForKey:@"icon"]
//                       rating:[jsonResultDict objectForKey:@"rating"]
//                     vicinity:[jsonResultDict objectForKey:@"vicinity"]
//                         type:[jsonResultDict objectForKey:@"types"]
//                    reference:[jsonResultDict objectForKey:@"reference"]
//                          url:[jsonResultDict objectForKey:@"url"]
//            addressComponents:[jsonResultDict objectForKey:@"address_components"]
//             formattedAddress:[jsonResultDict objectForKey:@"formatted_address"]
//         formattedPhoneNumber:[jsonResultDict objectForKey:@"formatted_phone_number"]
//                      website:[jsonResultDict objectForKey:@"website"]
//           internationalPhone:[jsonResultDict objectForKey:@"international_phone_number"]
//                  searchTerms:[jsonResultDict objectForKey:terms]
//               distanceInFeet:distanceInFeet
//              distanceInMiles:distanceInMiles
//                     placesID:[jsonResultDict objectForKey:@"place_id"]
//            ];

    return [self initWithName:[jsonResultDict objectForKey:@"name"]
                    placeIcon:[jsonResultDict objectForKey:@"icon"]
                     vicinity:[jsonResultDict objectForKey:@"vicinity"]
                    reference:[jsonResultDict objectForKey:@"reference"]
                          url:[jsonResultDict objectForKey:@"url"]
                      placeID:[jsonResultDict objectForKey:@"place_id"]
                     latitude:[[loc objectForKey:@"lat"] doubleValue]
                    longitude:[[loc objectForKey:@"lng"] doubleValue]];
}


//Updated
-(id) initWithJsonResultDict:(NSDictionary *)jsonResultDict andUserCoordinates:(CLLocationCoordinate2D)userCoords
{
    return [self initWithJsonResultDict:jsonResultDict searchTerms:@"" andUserCoordinates:userCoords];

}


- (NSString *)description
{
    return [NSString stringWithFormat:@"palcesID = %@, reference = %@, name =  %@, icon = %@, rating = %@, vicinity =  %@, type = %@, url = %@, addresComponentns = %@, formattedAddress = %@, formattedPhoneNumber =  %@, website = %@,  internationalPhoneNumber = %@,  searchTerms = %@ , distanceInFeetString = %@ distanceInFeetString = %@", self.placeId, self.reference,self.name,self.icon,self.rating,self.vicinity,self.type,self.url, self.addressComponents, self.formattedAddress, self.formattedPhoneNumber, self.website, self.internationalPhoneNumber,self.searchTerms, self.distanceInFeetString, self.distanceInFeetString];
}



//@property (nonatomic, retain) NSString    *placesId;
//@property (nonatomic, retain) NSString    *reference;
//@property (nonatomic, retain) NSString    *name;
//@property (nonatomic, retain) NSString    *icon;
//@property (nonatomic, retain) NSString    *rating;
//@property (nonatomic, retain) NSString    *vicinity;
//@property (nonatomic, retain) NSArray     *type; //array
//@property (nonatomic, retain) NSString    *url;
//@property (nonatomic, retain) NSArray     *addressComponents; //array
//@property (nonatomic, retain) NSString    *formattedAddress;
//@property (nonatomic, retain) NSString    *formattedPhoneNumber;
//@property (nonatomic, retain) NSString    *website;
//@property (nonatomic, retain) NSString    *internationalPhoneNumber;
//@property (nonatomic, retain) NSString      *searchTerms;
//@property (nonatomic, assign) CLLocationCoordinate2D    coordinate;
////NEW
//@property (nonatomic, retain) NSString    *distanceInFeetString;
//@property (nonatomic, retain) NSString    *distanceInMilesString;

@end
