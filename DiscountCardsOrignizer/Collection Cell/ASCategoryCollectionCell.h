//
//  AScategoryCollectionCell.h
//  DelScrollView
//
//  Created by Alexander Sergienko on 23.06.15.
//  Copyright (c) 2015 Alexander Sergienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASCategoryCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;

@end
