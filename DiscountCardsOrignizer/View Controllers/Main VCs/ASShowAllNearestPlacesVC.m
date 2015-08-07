//
//  ASShowAllNearestPlacesVC.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/14/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#import "ASShowAllNearestPlacesVC.h"
#import "ASGooglePlacesAPI.h"


@interface ASShowAllNearestPlacesVC () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSMutableArray *nearestPlacesArray;
@property (strong, nonatomic) UIAlertController *alertController;


@end


@implementation ASShowAllNearestPlacesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.responseData = [[NSMutableData data] init];
    
    //[[self locationManager] startUpdatingLocation];
    
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:NO];
    
    // [searchBar setDelegate:self];
    
    //==================================================
    self.googlePlacesConnection = [[ASGooglePlacesConnection alloc] initWithDelegate:self];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    //NSLog(@"Coordinates %f %f", coord.latitude, coord.longitude);
    
    NSString *searchLocations =
    [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",
                                 kAquarium,
                                 kBar,
                                 kBeautySalon,
                                 kBicycleStore,
                                 kBookStore,
                                 kCarRental,
                                 kCarWash,
                                 kClothingStore,
                                 kRestaurant,
                                 kBakery,
                                 kFood,
                                 kLodging,
                                 kGym,
                                 kCafe,
                                 kHealth,
                                 kMealDelivery,
                                 kMealTakeaway,
                                 kMovieTheater,
                                 kNightClub
                                 kShoeStore,
                                 kShoppingMall,
                                 kZoo
                                 ];

    [self.googlePlacesConnection getGoogleObjects:coord andTypes:searchLocations];
    
    
    //==================================================

//    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
//    
//    ASGooglePlacesAPI *placesAPI = [ASGooglePlacesAPI sharedInstance];
//    [placesAPI getFirstInfoFromCoordinates:locationCoordinate];
    
    [self hideStatusBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Delegate

- (void)googlePlacesConnection:(ASGooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects
{
//    NSLog(@"objecrts count = %ld", (unsigned long)[objects count]);
//    NSLog(@"objects : %@", objects);
    
    if ([objects count] == 0) {
        
        NSString *alertTitle = @"No matches found near this location";
        NSString *alertMessage = @"Try another place name or address";
        NSString *alertCancelButton = @"OK";
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            [[[UIAlertView alloc]initWithTitle:alertTitle
                                       message:alertMessage
                                      delegate:nil
                             cancelButtonTitle:alertCancelButton
                             otherButtonTitles:nil]show];
        }else{
            
            self.alertController =
            [UIAlertController alertControllerWithTitle:alertTitle
                                                message:alertMessage
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction =
            [UIAlertAction actionWithTitle:alertCancelButton
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
            [self.alertController addAction:okAction];
            
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
        
        
    } else {
        self.locations = objects;
        [self.tableView reloadData];
    }
}


- (void) googlePlacesConnection:(ASGooglePlacesConnection *)conn didFailWithError:(NSError *)error
{

    NSString *alertTitle = @"Error finding place - Try again";
    NSString *alertMessage = [error localizedDescription];
    NSString *alertCancelButton = @"OK";
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        [[[UIAlertView alloc]initWithTitle:alertTitle
                                   message:alertMessage
                                  delegate:nil
                         cancelButtonTitle:alertCancelButton
                         otherButtonTitles:nil]show];
    }else{
        
        self.alertController =
        [UIAlertController alertControllerWithTitle:alertTitle
                                            message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:alertCancelButton
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
        [self.alertController addAction:okAction];
        
        [self presentViewController:self.alertController animated:YES completion:nil];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"locations count = %lu", (unsigned long)[self.locations count]);
    return [self.locations count];
}



- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LocationCell";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType  = UITableViewCellAccessoryCheckmark;
    }
    
    // Get the object to display and set the value in the cell.
//    GooglePlacesObject *place     = [[GooglePlacesObject alloc] init];
//    place = [self.locations objectAtIndex:[indexPath row]];
    
    GooglePlacesObject *place = [self.locations objectAtIndex:[indexPath row]];
    
    cell.textLabel.text                         = place.name;
    cell.textLabel.adjustsFontSizeToFitWidth    = YES;
    cell.textLabel.font                         = [UIFont systemFontOfSize:14.0];
    cell.textLabel.minimumScaleFactor           = 10;
    cell.textLabel.numberOfLines                = 4;
    cell.textLabel.lineBreakMode                = NSLineBreakByCharWrapping;
    cell.textLabel.textColor                    = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
    cell.textLabel.textAlignment                = NSTextAlignmentLeft;
    
    cell.detailTextLabel.text                   = place.vicinity;
    cell.detailTextLabel.textColor              = [UIColor darkGrayColor];
    cell.detailTextLabel.font                   = [UIFont systemFontOfSize:11.0];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    NSString *place = cell.textLabel.text;
//    self.chosenPlace = place;
    
    self.placeObj = [self.locations objectAtIndex:indexPath.row];
//    NSLog(@"locations count = %ld",(unsigned long)[self.locations count]);
//    NSLog(@"GooglePlaceObject %@", self.placeObj);
    
    [self performSegueWithIdentifier:@"unwindFromAllNearestPlaces" sender:nil];
}

#pragma mark - Actions

- (IBAction)actionConfirmSelection:(UIButton*)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Additional

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void) hideStatusBar {
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6 and above 7 
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

@end
