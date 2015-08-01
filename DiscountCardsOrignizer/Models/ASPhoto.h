//
//  ASPhoto.h
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/8/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPhoto : NSObject

@property (assign, nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString *frontPhotoPath;
@property (strong, nonatomic) NSString *backPhotoPath;


+(instancetype)createNewPhotoWithFrontImage:(NSString *)frontImg andBackImg:(NSString *)backImg;

@end
