//
//  ASDatabaseManager.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/30/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASDatabaseManager : NSObject

+ (instancetype) sharedManager;
- (void) initializeDataBase;
//- (void) initializeDefaultcategories;

//Fetch Data From Tables
- (NSMutableArray* )getAllDataFromDBtableName:(NSString *)name;

#warning combine in 1 method
//rethink and combine in 1 method.
- (NSMutableArray*)getInfoFromCardTableWithIndexID:(NSInteger)indexID;
- (NSMutableArray*)getInfoFromPhotoTableWithIndexID:(NSInteger)indexID;
- (NSMutableArray*)getInfoFromLocationTableWithIndexID:(NSInteger)indexID;
- (NSMutableArray*)getInfoFromPlaceTableWithIndexID:(NSInteger)indexID;

//delete
- (void)deleteDataInDBtableName:(NSString*)name withIndex:(NSInteger)indexOfRecord;
//- (void) deleteAll;


//insert
- (void)insertCategoryRecordDataInDBtableWithName:(NSString*)name
                                         andImage:(NSString*)image;


- (void)insertCardRecordDataInDBtableWithName:(NSString*)cardName
                             inCategoryWithID:(NSUInteger)categoryID
                                  withExpDate:(NSString*)expDate
                                   andPhotoID:(NSUInteger)photoID;

- (void)insertLocationRecordDataInDBtableWithLocationTitle:(NSString*)locationTitle
                                                withCardID:(NSInteger)cardID
                                               withPlaceID:(NSInteger)placeID
                                             withLongitude:(double)longitute
                                               andLatitude:(double)latitude;

- (void)insertPhotoRecordDataInDBtableWithFrontPhoto:(NSString*)frontPhoto
                                        andBackPhoto:(NSString*)backPhoto;


- (void)insertPlaceRecordDataInDBtableWithName:(NSString *)name
                                   withAddress:(NSString *)address
                                     withTypes:(NSString *)types
                               withPhoneNumber:(NSString *)phoneNumber
                                   withWebsite:(NSString *)website
                             withOpeningHourse:(NSString *)hourse
                                  withVicinity:(NSString *)vicinity
                                    andPlaceID:(NSString *)placeID;


//update
- (void)updateDataInDBCardTableWithIndex:(NSInteger)indexOfRecord name:(NSString*)name expDate:(NSString*)expDate andLocation:(NSString*)location;
- (void)updateDataInDBCategoryTableWithIndex:(NSInteger)indexOfRecord name:(NSString*)name andImage:(NSString*)image;


- (NSInteger) returnLastInsertedRowID;

@end
