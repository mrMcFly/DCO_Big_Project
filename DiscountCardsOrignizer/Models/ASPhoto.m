//
//  ASPhoto.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/8/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASPhoto.h"

@implementation ASPhoto

+(instancetype)createNewPhotoWithFrontImage:(NSString *)frontImg
                                 andBackImg:(NSString *)backImg {
    
    ASPhoto *newPhoto = [[ASPhoto alloc]init];
    newPhoto.frontPhotoPath = frontImg;
    newPhoto.backPhotoPath  = backImg;
    
    return newPhoto;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.frontPhotoPath, self.backPhotoPath];
}

@end
