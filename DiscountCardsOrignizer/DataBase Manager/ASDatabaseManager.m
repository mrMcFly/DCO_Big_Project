//
//  ASDatabaseManager.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/30/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASDatabaseManager.h"
#import "FMDatabase.h"

//Models
#import "ASCategory.h"
#import "ASCard.h"
#import "ASLocation.h"
#import "ASPlace.h"
#import "ASPhoto.h"

@interface ASDatabaseManager ()

@property (assign, nonatomic) NSInteger lastInsertedRowID;

@end


@implementation ASDatabaseManager
{
    FMDatabase *database;
}

+ (instancetype) sharedManager {
    
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        singleton = [[self alloc]init];
    });
    
    return singleton;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *path = [docDir stringByAppendingPathComponent:@"DCOdataBase.sqlite"];
        database = [[FMDatabase alloc]initWithPath:path];
        NSLog(@"Path = %@", path);
    }
    return self;
}




- (void) initializeDataBase {
    
    [database open];
    
    NSInteger version = 0;
    FMResultSet *versionSet = [database executeQuery:@"PRAGMA user_version;"];
    if ([versionSet next]) {
        version = [versionSet longForColumnIndex:0];
    }
    
    if (version == 0) {
        
        //========================== Category ==================================
        NSString *sqlCreateCategoryTable = @"create table IF NOT EXISTS Category (id INTEGER primary key autoincrement, name text not null, image text);";
        
        BOOL success;
        
        //Create category table.
        success = [database executeUpdate:sqlCreateCategoryTable];
        if (success) {
            NSLog(@"Success create category");
        }else {
            NSLog(@"Failure create category");
        }
        
        //========================== Card ==================================

        NSString *sqlCreateCardTable = @"create table IF NOT EXISTS Card (id integer primary key autoincrement, name text not null, expDate text, category_id INTEGER not null, photo_id INTEGER not null, FOREIGN KEY (category_id) REFERENCES category(id) on update cascade on delete cascade, FOREIGN KEY(photo_id) REFERENCES photo(id));";
        
        success = [database executeUpdate:sqlCreateCardTable];
        if (success) {
            NSLog(@"Success create card");
        }else {
            NSLog(@"Failure create card");
        }
        
        //========================== Location ==================================

        NSString *sqlCreateLocationTable = @"create table IF NOT EXISTS Location (id INTEGER primary key autoincrement, locationTitle text, longitude double, latitude double, card_id INTEGER not null, place_id INTEGER not null, FOREIGN KEY(card_id) REFERENCES card(id) on update cascade on delete cascade,FOREIGN KEY(place_id) REFERENCES place(id));";
        
        success = [database executeUpdate:sqlCreateLocationTable];
        if (success) {
            NSLog(@"Success create Location");
        }else {
            NSLog(@"Failure create Location");
        }
        
        //========================== Photo ==================================

        NSString *sqlCreatePhotoTable = @"create table IF NOT EXISTS Photo (id INTEGER primary key autoincrement, frontPhoto text, backPhoto text);";
        success = [database executeUpdate:sqlCreatePhotoTable];
        if (success) {
            NSLog(@"Success create Photo");
        }else {
            NSLog(@"Failure create Photo");
        }
        
        
        //========================== Place ==================================

        NSString *sqlCreatePlaceTable = @"create table IF NOT EXISTS Place (id INTEGER primary key autoincrement, name text, address text, types text, phoneNumber text, website text, openingHourse text, vicinity text, place_id text);";
        success = [database executeUpdate:sqlCreatePlaceTable];
        if (success) {
            NSLog(@"Success create Place");
        }else {
            NSLog(@"Failure create Place");
        }

        
        [self initializeDefaultcategories];
    }
    
    NSInteger newVersion = 1;
    NSString *sqlVersionCommand = [NSString stringWithFormat:@"PRAGMA user_version=%ld;", (long)newVersion];
    [database executeUpdate:sqlVersionCommand];
}


- (void) initializeDefaultcategories {
    
    // NSString *addDefaultCategoryWithNameAll =
    //[NSString stringWithFormat:@"INSERT INTO Category (name, image) VALUES ('All', 'IconImageAddNewCategory')"];
    
    NSString *addDefaultCategoryWithNameClothing =
    [NSString stringWithFormat:@"INSERT INTO Category (name, image) VALUES ('Clothing', 'clothing.png')"];
    
    //NSString *addDefaultCategoryWithNameNewCategory =
    //[NSString stringWithFormat:@"INSERT INTO Category (name, image) VALUES ('New category', 'IconImage1')"];
    
    NSString *addDefaultCategoryWithNameHealth =
    [NSString stringWithFormat:@"INSERT INTO Category (name, image) VALUES ('Health', 'health.png')"];
    
    NSString *addDefaultCategoryWithNameOther =
    [NSString stringWithFormat:@"INSERT INTO Category (name, image) VALUES ('Other', 'other.png')"];
    
    //[database executeUpdate:addDefaultCategoryWithNameAll];
    [database executeUpdate:addDefaultCategoryWithNameClothing];
    //[database executeUpdate:addDefaultCategoryWithNameNewCategory];
    [database executeUpdate:addDefaultCategoryWithNameHealth];
    [database executeUpdate:addDefaultCategoryWithNameOther];
}


- (NSInteger) returnLastInsertedRowID {
    
    //    [database open];
    //    NSInteger returnValue = (NSInteger)[database lastInsertRowId];
    //    NSLog(@"Last ID from DB %ld",(long)returnValue);
    //    [database close];
    
    return self.lastInsertedRowID;
}


#pragma mark - Insert actions
//Insert Data In Tables
- (void)insertCategoryRecordDataInDBtableWithName:(NSString*)name
                                         andImage:(NSString*)image {
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO category (name, image) VALUES ('%@', '%@')", name, image,nil];
    [self performQueryWithSQLCommand:insertQuery];
}


- (void)insertCardRecordDataInDBtableWithName:(NSString*)cardName
                             inCategoryWithID:(NSUInteger)categoryID
                                  withExpDate:(NSString*)expDate
                                   andPhotoID:(NSUInteger)photoID {
    
    NSString *insertQuery =
    [NSString stringWithFormat:@"INSERT INTO card (name, expDate, category_id, photo_id) VALUES ('%@', '%@', '%@','%@')", cardName, expDate, [NSNumber numberWithUnsignedInteger:categoryID], [NSNumber numberWithUnsignedInteger:photoID], nil];
    
    [self performQueryWithSQLCommand:insertQuery];
}


- (void)insertLocationRecordDataInDBtableWithLocationTitle:(NSString*)locationTitle
                                                withCardID:(NSInteger)cardID
                                               withPlaceID:(NSInteger)placeID
                                             withLongitude:(double)longitute
                                               andLatitude:(double)latitude {
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Location (locationTitle, longitude, latitude, card_id, place_id) VALUES ('%@','%@','%@','%@','%@')",locationTitle, [NSNumber numberWithDouble:longitute],[NSNumber numberWithDouble: latitude], [NSNumber numberWithInteger:cardID], [NSNumber numberWithInteger:placeID]];
    
    [self performQueryWithSQLCommand:insertQuery];
}


- (void)insertPhotoRecordDataInDBtableWithFrontPhoto:(NSString*)frontPhoto
                                        andBackPhoto:(NSString*)backPhoto {
    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Photo (frontPhoto, backPhoto) VALUES ('%@','%@')",frontPhoto, backPhoto];
    [self performQueryWithSQLCommand:insertQuery];
}


- (void)insertPlaceRecordDataInDBtableWithName:(NSString *)name
                                   withAddress:(NSString *)address
                                     withTypes:(NSString *)types
                               withPhoneNumber:(NSString *)phoneNumber
                                   withWebsite:(NSString *)website
                             withOpeningHourse:(NSString *)hourse
                                  withVicinity:(NSString *)vicinity
                                    andPlaceID:(NSString *)placeID {
    
    NSLog(@"%@",name);
    NSLog(@"%@",address);
    NSLog(@"%@",types);
    NSLog(@"%@",website);
    NSLog(@"%@",hourse);
    NSLog(@"%@",placeID);

    
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO Place (name, address, types, phoneNumber,website, openingHourse,vicinity, place_id) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@')",name, address, types, phoneNumber, website, hourse,vicinity, placeID];
    [self performQueryWithSQLCommand:insertQuery];
}


#pragma mark - Get data
//Fetch Data From Tables
- (NSMutableArray* )getAllDataFromDBtableName:(NSString *)name {
    
    //initialize array.
    NSMutableArray *resultArrayFromDB = [NSMutableArray array];
    
    [database open];
    
    //NSString *sqlSelectQuery = @"SELECT * FROM college";
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM %@", name];
    
    // Query result
    FMResultSet *queryResults = [database executeQuery:sqlSelectQuery];
    while([queryResults next]) {
        
        if ([name isEqualToString:@"category"]) {
            
            NSString *categoryName  = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"name"]];
            NSString *categoryImage = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"image"]];
            NSUInteger categoryID   = [queryResults intForColumn:@"id"];
            
            ASCategory *category = [ASCategory createNewCategoryWithTitle:categoryName
                                                                    image:categoryImage
                                                                andSelfID:categoryID];
            
            [resultArrayFromDB addObject:category];
        //===============================================
            
        }else if ([name isEqualToString:@"card"]){
            
            NSString *cardName    = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"name"]];
            NSString *cardExpDate = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"expDate"]];
            NSInteger categoryID  = [queryResults intForColumn:@"category_id"];
            NSInteger photoID     = [queryResults intForColumn:@"photo_id"];
            NSInteger selfID      = [queryResults intForColumn:@"id"];
            
            //Create new card
            ASCard *card = [ASCard createNewCardWithName:cardName
                                             withExpDate:cardExpDate
                                          withCategoryID:categoryID
                                                 photoID:photoID
                                               andSelfID:selfID];
            
            //add to results array
            [resultArrayFromDB addObject:card];
        //===============================================
   
        }else if ([name isEqualToString:@"location"]) {
            
            NSString *locationTitle =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"locationTitle"]];
            double longitude  = [queryResults doubleForColumn:@"longitude"];
            double latitude   = [queryResults doubleForColumn:@"latitude"];
            NSInteger placeID = [queryResults intForColumn:@"place_id"];
            NSInteger cardID  = [queryResults intForColumn:@"card_id"];
            NSInteger selfID  = [queryResults intForColumn:@"id"];

            
            ASLocation *location = [ASLocation createNewLocationWithLocationTitle:locationTitle
                                                                    withLongitude:longitude
                                                                     withLatitude:latitude
                                                                       withCardID:cardID
                                                                      withPlaceID:placeID
                                                                        andSelfID:selfID];
            
            [resultArrayFromDB addObject:location];
            
        }else if ([name isEqualToString:@"place"]) {
            
            NSString *name =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"name"]];
            NSString *address =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"address"]];
            NSString *types =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"types"]];
           
            NSString *phoneNumber =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"phoneNumber"]];
            NSString *website =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"website"]];
            NSString *openingHourse =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"openingHourse"]];
            
            NSString *vicinity =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"vicinity"]];
            NSInteger selfID =
            [queryResults intForColumn:@"id"];
            NSString *placeID =
            [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"place_id"]];

            ASPlace *place = [ASPlace createNewPlaceWithName:name
                                                 withAddress:address
                                                   withTypes:types
                                             withPhoneNumber:phoneNumber
                                                 withWebsite:website
                                               openingHourse:openingHourse
                                                    vicinity:vicinity
                                                     plaseID:placeID
                                                   andSelfID:selfID];
            [resultArrayFromDB addObject:place];
            
        }else {
            
            return nil;
        }
    }
    
    [database close];
    
    return resultArrayFromDB;
}


- (NSMutableArray*)getInfoFromCardTableWithIndexID:(NSInteger)indexID {
    
    //initialize array.
    NSMutableArray *resultArrayFromDB = [NSMutableArray array];
    
    [database open];
    
    //NSString *sqlSelectQuery = @"SELECT * FROM college";
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM card where category_id = %@", [NSNumber numberWithInteger:indexID]];
    
    // Query result
    FMResultSet *queryResults = [database executeQuery:sqlSelectQuery];
    while([queryResults next]) {
        
        NSString *cardName = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"name"]];
        NSString *cardExpDate = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"expDate"]];
        
        NSInteger categoryID = [queryResults intForColumn:@"category_id"];
        NSInteger photoID = [queryResults intForColumn:@"photo_id"];
        NSInteger selfID = [queryResults intForColumn:@"id"];

        ASCard *card = [ASCard createNewCardWithName:cardName
                                         withExpDate:cardExpDate
                                      withCategoryID:categoryID
                                             photoID:photoID
                                           andSelfID:selfID];
        
        [resultArrayFromDB addObject:card];
    }
    return resultArrayFromDB;
}


- (NSMutableArray*)getInfoFromPhotoTableWithIndexID:(NSInteger)indexID {
    
    NSMutableArray *resultArrayFromDB = [NSMutableArray array];
    
    [database open];
    
    //NSString *sqlSelectQuery = @"SELECT * FROM college";
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM photo where id = %@", [NSNumber numberWithInteger:indexID]];
    
    // Query result
    FMResultSet *queryResults = [database executeQuery:sqlSelectQuery];
    while([queryResults next]) {
        
        NSString *frontPhoto = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"frontPhoto"]];
        NSString *backPhoto  = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"backPhoto"]];

        ASPhoto *photo = [ASPhoto createNewPhotoWithFrontImage:frontPhoto andBackImg:backPhoto];
        
        [resultArrayFromDB addObject:photo];
    }
    
    return resultArrayFromDB;
}



- (NSMutableArray*)getInfoFromLocationTableWithIndexID:(NSInteger)indexID {
    
    NSMutableArray *resultArrayFromDB = [NSMutableArray array];
    
    [database open];
    
    //NSString *sqlSelectQuery = @"SELECT * FROM college";
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM location where card_id = %@", [NSNumber numberWithInteger:indexID]];
    
    // Query result
    FMResultSet *queryResults = [database executeQuery:sqlSelectQuery];
    while([queryResults next]) {
        
        NSString *locationTitle = [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"locationTitle"]];
        double longitude  = [queryResults doubleForColumn:@"longitude"];
        double latitude   = [queryResults doubleForColumn:@"latitude"];
        NSInteger placeID = [queryResults intForColumn:@"place_id"];
        NSInteger cardID  = [queryResults intForColumn:@"card_id"];
        NSInteger selfID  = [queryResults intForColumn:@"id"];
        
        ASLocation *location = [ASLocation createNewLocationWithLocationTitle:locationTitle
                                                                withLongitude:longitude
                                                                 withLatitude:latitude
                                                                   withCardID:cardID
                                                                  withPlaceID:placeID
                                                                    andSelfID:selfID];
        NSLog(@"location detail info = %@", location);
        [resultArrayFromDB addObject:location];
    }
    
    return resultArrayFromDB;
}


- (NSMutableArray*)getInfoFromPlaceTableWithIndexID:(NSInteger)indexID {
    
    NSMutableArray *resultArrayFromDB = [NSMutableArray array];
    
    [database open];
    
    //NSString *sqlSelectQuery = @"SELECT * FROM college";
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM place where id = %@", [NSNumber numberWithInteger:indexID]];
    
    // Query result
    FMResultSet *queryResults = [database executeQuery:sqlSelectQuery];
    while([queryResults next]) {
        
        NSString *name =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"name"]];
        NSString *address =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"address"]];
        NSString *types =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"types"]];
        NSString *phoneNumder =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"phoneNumber"]];
        NSString *website =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"website"]];
        NSString *openingHourse =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"openingHourse"]];
        NSString *vicinity =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"vicinity"]];
        NSString *placeID  =
        [NSString stringWithFormat:@"%@", [queryResults stringForColumn:@"place_id"]];
        NSInteger selfID  = [queryResults intForColumn:@"id"];

        ASPlace *place = [ASPlace createNewPlaceWithName:name
                                             withAddress:address
                                               withTypes:types
                                         withPhoneNumber:phoneNumder
                                             withWebsite:website
                                           openingHourse:openingHourse
                                                vicinity:vicinity
                                                 plaseID:placeID
                                               andSelfID:selfID];
        
        
        [resultArrayFromDB addObject:place];
    }
    
    return resultArrayFromDB;
}



#pragma mark - Update data
//Update Data In Tables
- (void)updateDataInDBCardTableWithIndex:(NSInteger)indexOfRecord
                                    name:(NSString*)name
                                 expDate:(NSString*)expDate
                             andLocation:(NSString*)location{
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE card SET name = '%@' expDate = '%@' location = '%@' WHERE ID = '%ld'", name, expDate, location, (long)indexOfRecord];
    
    [self performQueryWithSQLCommand:updateQuery];
    
}


- (void)updateDataInDBCategoryTableWithIndex:(NSInteger)indexOfRecord name:(NSString*)name andImage:(NSString*)image{
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE category SET name = '%@' image = '%@' WHERE ID = '%ld'", name, image,(long)indexOfRecord];
    
    [self performQueryWithSQLCommand:updateQuery];
    
}


//Delete Data From Tables

- (void)deleteDataInDBtableName:(NSString*)tableName entyName:(NSString*)entryName {
    
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = %@", tableName, entryName];
    
    [self performQueryWithSQLCommand:deleteQuery];
}


//- (void) deleteAll {
//
//    NSString *deleteQuery = @"DELETE FROM Card";
//    [self performQueryWithSQLCommand:deleteQuery];
//
//    deleteQuery = @"DELETE FROM Category";
//    [self performQueryWithSQLCommand:deleteQuery];
//}


//general method
- (void) performQueryWithSQLCommand:(NSString*) sqlStringCommand {
    
    [database open];
    [database executeUpdate:sqlStringCommand];
    
    //NSLog(@"Last ID %lld", [database lastInsertRowId]);
    self.lastInsertedRowID = (NSInteger)[database lastInsertRowId];
    
    [database close];
    
}


@end
