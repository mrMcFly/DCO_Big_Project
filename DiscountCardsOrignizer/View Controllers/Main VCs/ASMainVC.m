//
//  ViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 6/26/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASMainVC.h"
#import "SWRevealViewController.h"
#import "ASCategoryCollectionCell.h"
#import "ASCategory.h"
#import "ASDatabaseManager.h"
#import "ASAddNewCardVC.h"
#import "ASAllCardListVC.h"


@interface ASMainVC ()  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//items storage without database
@property (strong, nonatomic) NSMutableArray *itemsArray;

//array of sections for catefories;
@property (strong, nonatomic) NSMutableArray *sectionsArray;


@property (assign, nonatomic) NSInteger numberOfSections;

@end


@implementation ASMainVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self downloadDataFromDataBase];
    [self defineSectionsForCategories];
    //[self setTextAndColorForNavigationBarAndStatusBar];
    self.navigationItem.title = @"CATEGORIES";
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //if we make popToRootViewController (example AddNewCard-Save-popToRootViewController->) we lose navigation bar
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void) downloadDataFromDataBase {
    
    self.itemsArray = [[ASDatabaseManager sharedManager] getAllDataFromDBtableName:@"category"];
    
    ASCategory *allCardsCategory = [ASCategory createNewCategoryWithTitle:@"All cards" image:@"all.png" andSelfID:-1];
    ASCategory *newCategory = [ASCategory createNewCategoryWithTitle:@"New Category" image:@"newCategory.png" andSelfID:-1];
    
    
    //Add 2 default categories (they are not at DB)
    [self.itemsArray insertObject:allCardsCategory atIndex:0];
    [self.itemsArray insertObject:newCategory atIndex:2];
    
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.sectionsArray count];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.sectionsArray[section] count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer = @"ASCategoryCollectionCell";
    
    ASCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    ASCategory *category = [[self.sectionsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.categoryTitle.text = category.name;
    cell.layer.cornerRadius = 3;
    [self setIconForCurrentCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        
        [self performSegueWithIdentifier:@"createNewCategorySegue" sender:nil];
        
    }else {
        
        ASAllCardListVC *allCardsListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASAllCardListVC"];

        if (indexPath.section == 0 && indexPath.row == 0) {
            
            allCardsListVC.title = @"All cards";
            
        }else {
            
            ASCategory *chosenCategory = [[self.sectionsArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            allCardsListVC.specificChosenCategory = chosenCategory;
            allCardsListVC.title = chosenCategory.name;
        }
        [self.navigationController pushViewController:allCardsListVC animated:YES];
    }
}


//Ovveride from parent (!!!!!!! realization in ASBase!!!!!!!)
//- (void)actionAddNewCard:(UIBarButtonItem*)sender {
//
//    NSLog(@"actionAddNewCard");
//    [self performSegueWithIdentifier:@"createNewCardSegue" sender:nil];
//}


#pragma mark - ????

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //if other insets then checkout needed.
    if (section == 0) {
        return UIEdgeInsetsMake(8, 0, 4, 0);
    }
    return UIEdgeInsetsMake(4, 0, 4, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
// 
//    
//}


//====================================
- (CGSize) collectionView:(UICollectionView*)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    CGSize size;
    
    CGSize smallIconSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / 2 - 27, CGRectGetHeight(self.collectionView.bounds) / 3 - 11);
    CGSize bigIconSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / 2 + 17, CGRectGetHeight(self.collectionView.bounds) / 3 - 11);
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            size = smallIconSize;
        }else {
            size = bigIconSize;
        }
        
    } else if (indexPath.section == 1 || (indexPath.section == self.numberOfSections - 1 && [self.itemsArray count] % 2 == 0)) {
        size = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.collectionView.bounds) / 3 - 11);
        
    }else {
        
        if (indexPath.section % 2 == 0) {
            
            if (indexPath.row == 0) {
                size = bigIconSize;
            }else {
                size = smallIconSize;
            }
        }else {
            
            if (indexPath.row == 0) {
                size = smallIconSize;
            }else {
                size = bigIconSize;
            }
        }
    }
    return size;
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"createNewCardSegue"]) {
        
        ASAddNewCardVC *newCardVC = nil;
        
        //check for iOS ? < 8.0 (occur error on iOS 7.1)
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            NSLog(@"UINavigationController");
            UINavigationController *navVC = segue.destinationViewController;
            newCardVC = (ASAddNewCardVC*)(navVC.topViewController);
        }else {
            NSLog(@"ASAddNewCardViewController");
            newCardVC = segue.destinationViewController;
        }
        
        newCardVC.navigationTitle = @"Add New Card";
    }
}


#pragma mark - Unwind Segue

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
    NSLog(@"Return from add new card to main");
    // [self.navigationController.navigationBar setHidden:NO];
    [self downloadDataFromDataBase];
    [self defineSectionsForCategories];

}


#pragma mark - Additional

-(void) defineSectionsForCategories {
    
    
    NSInteger itemsCount = [self.itemsArray count];
    NSInteger numberOfSection = (itemsCount / 2) + 1;
    self.numberOfSections = numberOfSection;
    
    NSRange range;
    range.length = 2;
    range.location = 0;
    
    self.sectionsArray = [NSMutableArray array];

    
    for (NSInteger i = 0; i < numberOfSection; i ++) {
        
        NSMutableArray *sectionForCategoryArray = [NSMutableArray array];
        
        if (i == 1) {
            
            range.length = 1;
            sectionForCategoryArray = (NSMutableArray*)[self.itemsArray subarrayWithRange:range];
            range.location ++;
            range.length = 2;
            
        }else {
            
            if (i == numberOfSection - 1) {
                
                if ([self.itemsArray count] % 2 == 0) {
                    range.length = 1;
                    sectionForCategoryArray = (NSMutableArray*)[self.itemsArray subarrayWithRange:range];
                    
                }else {
                    
                    range.length = 2;
                    sectionForCategoryArray = (NSMutableArray*)[self.itemsArray subarrayWithRange:range];
                    
                    range.location +=2;
                }
                
            } else {
                
                sectionForCategoryArray = (NSMutableArray*)[self.itemsArray subarrayWithRange:range];
                range.location +=2;
            }
            
        }
        [self.sectionsArray addObject:sectionForCategoryArray];
    }
    
    //NSLog(@"SectionsArray = %@", self.sectionsArray);
}



- (void) setIconForCurrentCell:(ASCategoryCollectionCell*)cell  atIndexPath:(NSIndexPath*)indexPath {
    
    if (indexPath.section == 0) {

        if (indexPath.row == 0){
            cell.backgroundColor = [UIColor colorWithRed:1.000 green:0.700 blue:0.096 alpha:1.000];
        }else {
            cell.backgroundColor = [UIColor colorWithRed:0.921 green:0.419 blue:0.123 alpha:1.000];
        }
    }else if (indexPath.section == 1) {
        cell.backgroundColor = [UIColor colorWithRed:0.414 green:0.761 blue:0.218 alpha:1.000];
        //cell.categoryImage.image = [UIImage imageNamed:@"all"];
        
    }else if (indexPath.section % 2 == 0) {
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:0.754 green:0.201 blue:0.316 alpha:1.000];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:0.215 green:0.521 blue:0.790 alpha:1.000];
        }
    }else {
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:0.647 green:0.806 blue:0.911 alpha:1.000];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:0.880 green:0.757 blue:0.144 alpha:1.000];
        }
    }
    
    ASCategory *category = [[self.sectionsArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.categoryImage.image = [UIImage imageNamed:category.imageTitle];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)setTextAndColorForNavigationBarAndStatusBar {
    
    self.navigationItem.title = @"CATEGORIES";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.000 green:0.418 blue:0.099 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20,[UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
}

@end
