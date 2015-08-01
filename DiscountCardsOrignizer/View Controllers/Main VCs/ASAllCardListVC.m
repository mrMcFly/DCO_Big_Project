//
//  ASAllCardListVC.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/10/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASAllCardListVC.h"
#import "ASAddNewCardVC.h"
#import "ASDatabaseManager.h"
#import "ASCategory.h"
#import "ASCard.h"
#import "ASCardDetailInfoVC.h"

@interface ASAllCardListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *allCardsArray;

@end


@implementation ASAllCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    
    [self defineListOfCards];
    //    self.allCardsArray = [[ASDatabaseManager sharedManager] getAllDataFromDBtableName:@"card"];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //NSLog(@"viewWillAppear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Actions

- (IBAction)actionShowCategoryVC:(UIButton*)sender {
    
    NSLog(@"actionShowCategoryVC");
}


- (IBAction)actionShowMapWithAllCardsLocationsVC:(UIButton*)sender {
    
    NSLog(@"actionShowMapWithAllCardsLocationsVC");
}


#pragma mark - Ovveride from parent
- (void)actionAddNewCard:(UIBarButtonItem*)sender {
    
    NSLog(@"Add new Card ovveride from parent");
    ASAddNewCardVC *addNewcardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASAddNewCardVC"];
    
    addNewcardVC.categoryForNewCard = self.specificChosenCategory;
    
    [self.navigationController pushViewController:addNewcardVC animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allCardsArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"dequeue");
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cardCell) {
        cardCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ASCard *cardFromcurrentPath = [self.allCardsArray objectAtIndex:indexPath.row];
    
    cardCell.textLabel.text = cardFromcurrentPath.name;
    
    return cardCell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ASCardDetailInfoVC *cardDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASCardDetailInfoVC"];
    cardDetailsVC.chosenCard = [self.allCardsArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:cardDetailsVC animated:YES];
}


- (void) defineListOfCards {
    
    if (!self.specificChosenCategory) {
        self.allCardsArray = [[ASDatabaseManager sharedManager] getAllDataFromDBtableName:@"card"];
        NSLog(@"defineListOfCards ALL");
    }else {
        //self.allCardsArray = [ASDatabaseManager sharedManager] @"get all cards whre category_id == ?", self.specificChosenCategory.iD;
        NSInteger indexForRequest = self.specificChosenCategory.iD;
        self.allCardsArray = [[ASDatabaseManager sharedManager] getInfoFromCardTableWithIndexID:indexForRequest];
        NSLog(@"defineListOfCards SPECIFIC");
    }
}

@end
