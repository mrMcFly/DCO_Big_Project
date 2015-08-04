//
//  ASCellInfo.h
//  DiscountCardsOrignizer
//
//  Created by Alexander Sergienko on 8/3/15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ASCellInfo : NSObject

@property (strong, nonatomic) UIImage *imageOfCell;
@property (strong, nonatomic) NSString *titleOfCell;
@property (assign, nonatomic) BOOL showNotifications;

@end
