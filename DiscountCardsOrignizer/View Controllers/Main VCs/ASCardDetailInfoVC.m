//
//  ASCardDetailInfoVC.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/14/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASCardDetailInfoVC.h"

//Cells
#import "ASCardDetailsImageCell.h"
#import "ASCardDetailsExpDateCell.h"
#import "ASCardDetailsLocationCell.h"
#import "ASCardDetailsLocationAndPlaceCell.h"
#import "ASCardDetailsEditCell.h"

//DB
#import "ASDatabaseManager.h"

//models
#import "ASPhoto.h"
#import "ASLocation.h"
#import "ASCard.h"
#import "ASPlace.h"


@interface ASCardDetailInfoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@end


@implementation ASCardDetailInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.itemsArray = [NSMutableArray array];
    
    NSLog(@"Card detail info %@",self.chosenCard);
    [self createDataArrayForTable];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static float height = 0.f;
    
    static NSString *imageIdentifier            = @"ASCardDetailsImageCell";
    static NSString *expDateIdentifier          = @"ASCardDetailsExpDateCell";
    static NSString *locationIdentifier         = @"ASCardDetailsLocationCell";
    static NSString *locationAndPlaceIdentifier = @"ASCardDetailsLocationAndPlaceCell";
//    static NSString *editIdentifier             = @"ASCardDetailsEditCell";
    
    UITableViewCell *cell = nil;
    //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    
    //get common object
    id obj = [self.itemsArray objectAtIndex:indexPath.row];
    
    //define class of object
    if ([obj isKindOfClass:[ASPhoto class]]) {
        
        ASPhoto *photo = obj;
         cell = [tableView dequeueReusableCellWithIdentifier:imageIdentifier];
        
        if (![photo.frontPhotoPath isEqualToString:@"(null)"]) {
            
            //UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            
            ((ASCardDetailsImageCell*)cell).cardImage.image = [UIImage imageWithContentsOfFile:photo.frontPhotoPath];   //path to image;
        }else if (![photo.backPhotoPath isEqualToString:@"(null)"]) {
            ((ASCardDetailsImageCell*)cell).cardImage.image = [UIImage imageWithContentsOfFile:photo.backPhotoPath];   //path to image;
        }
        
        
    }else if ([obj isKindOfClass:[NSString class]]){ //maybe better replace to Card object
        
        NSLog(@"Exp date");
        cell = [tableView dequeueReusableCellWithIdentifier:expDateIdentifier];
        ((ASCardDetailsExpDateCell*)cell).expDateLabel.text = obj;
        
        
    }else if ([obj isKindOfClass:[NSArray class]]){
        
        NSArray *locationAndPlaceInfo = obj;
        NSLog(@"adress and place");
        cell = [tableView dequeueReusableCellWithIdentifier:locationAndPlaceIdentifier];
        ((ASCardDetailsLocationAndPlaceCell*)cell).lacotionLabel.text = ((ASLocation*)[locationAndPlaceInfo objectAtIndex:0]).locationTitle;
         ((ASCardDetailsLocationAndPlaceCell*)cell).placeLabel.text = ((ASPlace*)[locationAndPlaceInfo objectAtIndex:1]).name;
        
    }else if ([obj isKindOfClass:[ASLocation class]]){
        NSLog(@"location");
        ASLocation *location = obj;
        cell = [tableView dequeueReusableCellWithIdentifier:locationIdentifier];
        ((ASCardDetailsLocationCell*)cell).lacotionLabel.text = location.locationTitle;
        
    }else{
        NSLog(@"default");
    }
    
    
    //===========================================================
    
    if (indexPath.row == [self.itemsArray count]-1 && ![self separateButton:height]) { //&& height
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50)];
        [cell.contentView addSubview:button];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(actionEditCard:) forControlEvents:UIControlEventTouchUpInside];
        height = 0.f;
        NSLog(@"WORKING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        
    }else if (indexPath.row <= [self.itemsArray count]-1 && [self separateButton:height]){
        
        
        
        if (indexPath.row == [self.itemsArray count] -1) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button setFrame:CGRectMake(0, self.tableView.frame.size.height - 50, CGRectGetWidth(self.tableView.frame), 50)];
            [self.tableView addSubview:button];
            button.backgroundColor = [UIColor redColor];
            [button addTarget:self action:@selector(actionEditCard:) forControlEvents:UIControlEventTouchUpInside];
            height = 0.f;
        }
    }
    //===========================================================
//    NSLog(@"OBJECT ====== %@", obj);
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Actions

- (IBAction)actionShowCategory:(UIButton*)sender {
    
    NSLog(@"actionShowCategory");
}


- (IBAction)actionShowMap:(UIButton*)sender {
    
    NSLog(@"actionShowMap");
}

- (void)actionEditCard:(UIButton*)sender {
    
    NSLog(@"Edit");
}


- (void) createDataArrayForTable {
    
    //2 becouse card table always have 1 row for name + 1 row for edit button
    //NSInteger numberOfRows = 2;
    
    ASCard *card = self.chosenCard;
    
    NSArray *photoArr = [[ASDatabaseManager sharedManager]getInfoFromPhotoTableWithIndexID:card.photo_id];
    ASPhoto *photo = [photoArr objectAtIndex:0];
    
    
    if (![photo.frontPhotoPath isEqualToString:@"(null)"]) {
        //numberOfRows ++;
        [self.itemsArray addObject:photo];
    }
    if (![photo.backPhotoPath isEqualToString:@"(null)"]) {
        //numberOfRows ++;
        [self.itemsArray addObject:photo];
    }
    
    if (card.expDate.length > 0) {
        [self.itemsArray addObject:card.expDate];
    }
    
    
    NSArray *locationsArray = [[ASDatabaseManager sharedManager]getInfoFromLocationTableWithIndexID:card.iD];
    for (ASLocation *location in locationsArray) {
        if (![location.locationTitle isEqualToString:@"(null)"]) {
            //[self.itemsArray addObject:location];
            
            NSLog(@"Location : %@", location);
            NSLog(@"location id : %ld", (long)location.placeId);
            
            
            if(location.placeId > 0){
                NSArray *placeArray = [[ASDatabaseManager sharedManager]getInfoFromPlaceTableWithIndexID:location.placeId];
                ASPlace *place = [placeArray firstObject];
                NSLog(@"place = %@", place);
                NSArray *arr = @[location,place];
                [self.itemsArray addObject:arr];
            }else{
                [self.itemsArray addObject:location];
            }
        }
    }
    
    NSLog(@"ITEMS ARRAY COUNT = %ld", (unsigned long)[self.itemsArray count]);
}


#pragma mark - Additional for define Button

- (BOOL) separateButton:(float)height {
    
    if (height < self.tableView.frame.size.height - 50) {
        NSLog(@"small height");
        return YES;
    }else {
        NSLog(@"big height");
        return NO;
    }
}


@end
