
//
//  ASCategoryIconsViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASCategoryIconsVC.h"
#import "ASCategoryIconCell.h"

@interface ASCategoryIconsVC () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *iconsArray;

@end


@implementation ASCategoryIconsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.iconsArray = [NSMutableArray array];
    NSArray *arr1 = [NSArray arrayWithObjects:@"newCategory",@"all",nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"clothing",@"health",nil];
    NSArray *arr3 = [NSArray arrayWithObjects:@"other",@"food",nil];
//    NSArray *arr4 = [NSArray arrayWithObjects:@"clothing",@"food",nil];
//    NSArray *arr5 = [NSArray arrayWithObjects:@"health",@"other",nil];
    
//    self.iconsArray = [@[arr1,arr2,arr3,arr4,arr5]mutableCopy];
    self.iconsArray = [@[arr1,arr2,arr3]mutableCopy];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [self.iconsArray count];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 2;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer = @"ASCategoryIconCell";
    ASCategoryIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];

    cell.categoryIcon.image = [UIImage imageNamed:[[self.iconsArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
   
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Attention!!! with Dismiss unwind segue not working!!!
    
    //[self dismissViewControllerAnimated:YES completion:^{
        //submit data(image) to root controller.

        //[self.delegate saveChoosenIconForNewCategory:self withIndex:indexPath.row];
        self.categoryImage = [[self.iconsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSLog(@"Category Image = %@", self.categoryImage);
        [self performSegueWithIdentifier:@"unwindAddNewCategoryVC" sender:nil];

   // }];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3, 0, 5, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


- (CGSize) collectionView:(UICollectionView*)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath*)indexPath {

    CGSize cellSize = CGSizeMake(CGRectGetWidth(self.collectionView.bounds) / 2 - 5, CGRectGetHeight(self.collectionView.bounds) / 3 - 10);
    
    return cellSize;
}


@end
