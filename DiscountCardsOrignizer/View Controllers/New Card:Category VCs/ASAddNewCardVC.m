//
//  ASAddNewCardViewController.m
//  DiscountCardsOrginizerDCO
//
//  Created by Alexandr Sergienko on 7/2/15.
//  Copyright (c) 2015 AlexanderSergienko. All rights reserved.
//

#import "ASAddNewCardVC.h"
#import "ActionSheetPicker.h"
#import "ASDatabaseManager.h"
//----------- Models------------
#import "ASCard.h"
#import "ASPhoto.h"
#import "ASLocation.h"
#import "ASCategory.h"
#import "ASPlace.h"
//------------------------------
#import "ASCardImageCell.h"
#import "ASTextFieldCell.h"
#import "ASNotificationsCell.h"
#import "ASMapSelectLocationVC.h"
#import "ASShowAllNearestPlacesVC.h"

//#import <Photos/PHFetchOptions.h>
#import <Photos/Photos.h>

//#import "UTCoreTypes.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "FMDatabase.h"

#import "ASImagePickerVC.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


typedef enum {
    ASAlertTypeForCameraIsNotAvailable,
    ASAlertTypeForCardShouldHaveNameAndPhoto
} ASAlertType;


@interface ASAddNewCardVC () <UITableViewDataSource, UITableViewDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, ASCardImageCellDelegate>

//custom action sheet
@property (strong, nonatomic) AbstractActionSheetPicker *actionSheetPicker;

//for database
@property (strong, nonatomic) NSDate *selectedDate;

@property (strong, nonatomic) ASCard *card;
@property (strong, nonatomic) ASPhoto *photo;
@property (strong, nonatomic) ASLocation *location;
@property (strong, nonatomic) ASCategory *category; //check if needed!!!!!!
@property (strong, nonatomic) ASPlace *place;

//list of categories to choose in category selection
@property (strong, nonatomic) NSArray *availableCategories;

//tableView
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UIAlertController   *alertController;
@property (strong, nonatomic) UIActionSheet *actionSheet;
//@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) ASImagePickerVC *imagePicker;

@property (strong, nonatomic) NSIndexPath *choosenCellPath;

@property (strong, nonatomic) UITextField *activeField;

//arrays for vary locations and places.
@property (strong, nonatomic) NSArray *locationsArray;
@property (strong, nonatomic) NSArray *placesArray;

@property (strong, nonatomic) UITextField *nameField;

@property (strong, nonatomic) NSMutableIndexSet *indexSetFroButton;

@end


@implementation ASAddNewCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationTitle;
    
    [self initializeAllModels];
    [self setupDefaultTableSettings];
    [self defineAllAvailableCategories];
    [self checkAndSetIfCardHaveDefaultCategory];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboardTable)];
//    
//    [self.view addGestureRecognizer:tap];
    //NSLog(@"namefield = ")
    }


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //if we make popToRootViewController (example AddNewCard-Save-popToRootViewController->) we lose navigation bar
    [self.navigationController.navigationBar setHidden:NO];
    [self checkAndSetIfCardHaveDefaultCategory];
    //[self registerForKeyboardNotifications];
}


-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    //[self disableForKeyboardNotifications];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


#pragma mark - Save to DB

- (IBAction)actionSaveNewCard:(id)sender {
    
    if ([self isNewCardHaveName] && [self isNewCardHaveAtLeastOneImage]) {
        
        [self saveAllCardFillInfoToDataBase];
        
        [self performSegueWithIdentifier:@"unwindToMainVC" sender:nil];
        
    }else {
        
        //[self showAlertCardShouldHaveNameAndPhoto];
        [self showAlertForType:ASAlertTypeForCardShouldHaveNameAndPhoto];
    }
}


//test for hide keyboard if we tap on 'Menu' when textField is editing.
- (IBAction)actionSelectMenu:(id)sender {
    
    if (self.choosenCellPath) {
        ASTextFieldCell *textField = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
        [textField resignFirstResponder];
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //[self animateTextField:textField up:NO];
    [self animateTableViewPositionForItem:textField up:NO];

    if ( [textField.inputView isKindOfClass:[ActionSheetDatePicker class]] )
        ((ActionSheetDatePicker*)textField.inputView).target = nil;
    
    [textField endEditing:YES];
    
    //remove active field (keyboard notifications).
    self.activeField = nil;
    
    CGPoint buttonPosition = [textField convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath) {
        NSLog(@"index path = %@", indexPath);
        self.choosenCellPath = indexPath;

        if (indexPath.row == 2) {
            self.card.name = textField.text;
            //[textField resignFirstResponder];
            //self.nameField = textField;
        }
          }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField.placeholder isEqualToString:@"Exp.date"]) {
        [self.nameField resignFirstResponder]; //important line (without-keyboard stay)
        return YES;
    }
    
    return  YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldRaplace = true;
    
    return shouldRaplace;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
     //[self animateTextField:textField up:YES];
    [self animateTableViewPositionForItem:textField up:YES];
    
    //set active field for keyboard handler methods (notifications)
    self.activeField = textField;
    
    if ( [textField.inputView isKindOfClass:[ActionSheetDatePicker class]] )
        ((ActionSheetDatePicker*)textField.inputView).target = textField;
    

    if ([textField.placeholder isEqualToString:@"Card Name"])  {
        self.nameField = textField;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                       initWithTarget:self
//                                       action:@selector(dismissKeyboardTable)];
//        
//        [self.nameField addGestureRecognizer:tap];
    }
    
    if([textField.placeholder isEqualToString:@"Exp.date"]) {
        
        [textField endEditing:YES];
        [textField resignFirstResponder];
        [self dismissKeyboardTable];

        [self selectADate];
        
    }else if ([textField.placeholder isEqualToString:@"Location"]) {
        [textField endEditing:YES];

        //[textField resignFirstResponder];
        [self performSegueWithIdentifier:@"createSelectLocationSegue" sender:nil];
        
    }else if ([textField.placeholder isEqualToString:@"Category"]) {
        [textField endEditing:YES];
        
        [self animateTableViewPositionForItem:textField up:YES];

        //[textField resignFirstResponder];
        [self selectCategory];
        
    }else if ([textField.placeholder isEqualToString:@"Add place"]) {
     
        [textField endEditing:YES];

        //[textField resignFirstResponder];
        //NSLog(@"Add place");
        
        ASShowAllNearestPlacesVC *placesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ASShowAllNearestPlacesVC"];

        placesVC.longitude = self.location.longitude;
        placesVC.latitude = self.location.latitude;
        
        
        [self presentViewController:placesVC animated:YES completion:^{
            // NSLog(@"Completion");
        }];

    }else {
        
        NSLog(@"default");
    }
}


#pragma mark - Additional for textFields
- (void) selectCategory {
    
    [ActionSheetStringPicker
     showPickerWithTitle:@"Select a Category"
     rows:self.availableCategories
     initialSelection:0
     doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
         
         NSLog(@"Picker: %@", picker);
         NSLog(@"Selected Index: %ld", (long)selectedIndex);
         NSLog(@"Selected Value: %@", selectedValue);
         //NSLog(@"Frame %@", )
         
         ASCategory *chosenCategory = [self.availableCategories objectAtIndex:selectedIndex];
         
         //=============================
         self.categoryForNewCard = chosenCategory;
         //=============================
         
         self.card.category_id = chosenCategory.iD;
         
         ASTextFieldCell *currentChosenCell = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
         currentChosenCell.textField.text = [NSString stringWithFormat:@"%@",selectedValue];
         
         [self animateTableViewPositionForItem:currentChosenCell up:NO];
     }
     
     cancelBlock:^(ActionSheetStringPicker *picker) {
         NSLog(@"Block Picker Canceled");
     }
          origin:self.view];
    
    // You can also use self.view if you don't have a sender
    

}


- (void)selectADate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    
    int yearsToAdd = 5;
    NSDate *maxDate = [minDate dateByAddingTimeInterval:60 * 60 * 24 * 365 * yearsToAdd];
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Expiraton date"
                                                           datePickerMode:UIDatePickerModeDate
                                                             selectedDate:self.selectedDate
                                                                   target:self
                                                                   action:@selector(dateWasSelected:element:)
                                                                   origin:self.view
                                                             cancelAction:@selector(dateWasCancelled)];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    self.actionSheetPicker.hideCancel = NO;
    [self.actionSheetPicker showActionSheetPicker];
    
    UITableViewCell *currentChosenCell = [self.tableView cellForRowAtIndexPath:self.choosenCellPath];
    //[self animateTextField:textField up:YES];
    [self animateTableViewPositionForItem:currentChosenCell up:YES];

}

- (void)selectADateForField:(UITextField*)textField {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    
    int yearsToAdd = 5;
    NSDate *maxDate = [minDate dateByAddingTimeInterval:60 * 60 * 24 * 365 * yearsToAdd];
    
    self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Expiraton date"
                                                           datePickerMode:UIDatePickerModeDate
                                                             selectedDate:self.selectedDate
                                                                   target:self
                                                                   action:@selector(dateWasSelected:element:)
                                                                   origin:self.view
                                                             cancelAction:@selector(dateWasCancelled)];
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    self.actionSheetPicker.hideCancel = NO;
    [self.actionSheetPicker showActionSheetPicker];
    
}




- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    
    self.selectedDate = selectedDate;
    
    if (!self.selectedDate) {
        self.selectedDate = [NSDate date];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    
    self.card.expDate = [dateFormatter stringFromDate:self.selectedDate];
    
    NSLog(@"choosenCellPath %@", self.choosenCellPath);
    ASTextFieldCell *currentChosenCell = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
    currentChosenCell.textField.text = [dateFormatter stringFromDate:self.selectedDate];
    
    //change content offset for textField when edit is end.
    //[self animateTextField:textField up:NO];
    [self animateTableViewPositionForItem:currentChosenCell up:NO];
}


- (void) dateWasCancelled {
    
    //    [self.expDateField resignFirstResponder];
    //    [self.locationField becomeFirstResponder];
    
    UITableViewCell *currentChosenCell = [self.tableView cellForRowAtIndexPath:self.choosenCellPath];
    //[self animateTextField:textField up:NO];
    [self animateTableViewPositionForItem:currentChosenCell up:NO];
}


#pragma mark - UITableViewDataSource

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cardImgCellIdentifier = @"ASCardImageCell";
    static NSString *textFieldCellIdentifier = @"ASTextFieldCell";
    static NSString *notificationCellIdentifier = @"ASNotificationsCell";
    
    UITableViewCell *cell;
    
    //First and second cells are for ChoseImageButtons.
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cardImgCellIdentifier];
       
        [((ASCardImageCell*)cell).imgButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if (((ASCardImageCell*)cell).chosenImage) {
            
            [((ASCardImageCell*)cell).imgButton setImage:((ASCardImageCell*)cell).chosenImage forState:UIControlStateNormal];
        }else{
            
        if (indexPath.row == 0) {
            
            [((ASCardImageCell*)cell).imgButton setImage:[UIImage imageNamed:@"ChoseImageButtonFront"] forState:UIControlStateNormal];
            
        }else if (indexPath.row == 1) {
            
            [((ASCardImageCell*)cell).imgButton setImage:[UIImage imageNamed:@"ChoseImageButtonRear"] forState:UIControlStateNormal];
        }
    }
        
    //Rest of table cells.
    }else if (indexPath.row == [self.itemsArray count] - 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
        [((ASNotificationsCell*)cell).confirmNotificationsButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
        [((ASTextFieldCell*)cell).textField addTarget:self action:@selector(checkButtonTapped:)  forControlEvents:UIControlEventTouchUpInside];//UIControlEventEditingDidBegin
        
        NSString *placeholderText = nil;
        
        if (indexPath.row == 2) {
            placeholderText = @"Card Name";
        }else if (indexPath.row == [self.itemsArray count] - 2) {
            placeholderText = @"Category";
        }else if (indexPath.row == 3) {
            placeholderText = @"Exp.date";
        }else if (indexPath.row % 2 == 0) {
            placeholderText = @"Location";
        }else if (indexPath.row % 2 == 1) {
            placeholderText = @"Add place";
        }
        
        ((ASTextFieldCell*)cell).textField.placeholder = placeholderText;
    }
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.row == 0 || indexPath.row == 1) {
//        return 110.f;
//    }else {
//        return 44.f;
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 110.f;
    } if (indexPath.row == [self.itemsArray count] - 2) {
        return 70.f;
    }
    else {
        return 44.f;
    }
}

//Doestn work becouse we tap on TextField, not in cell.
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"IndexPath = %@",indexPath);
//}


#pragma mark - Alert setup

- (void)setupAlertCtrl {
    
    self.alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction =
    [UIAlertAction actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               [self handleCamera];
                           }];
    
    UIAlertAction *imageGalleryAction =
    [UIAlertAction actionWithTitle:@"Photo Gallery"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               [self handleImageGallery];
                           }];
    
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action) {
                               [self dismissViewControllerAnimated:YES completion:nil];
                           }];
    [self.alertController addAction:cameraAction];
    [self.alertController addAction:imageGalleryAction];
    [self.alertController addAction:cancelAction];
}


- (void) setAndShowActionSheetForChoseImageFolder {
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"Camera",@"Photo Gallery",nil];
    self.actionSheet.tag = 1;
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (void)showAlertForType:(ASAlertType)alertType {
    
    NSString *alertTitle = @"Note";
    NSString *alertMessage = nil;
    NSString *alertCancelButton = @"Ok";
    
    if (alertType == ASAlertTypeForCameraIsNotAvailable) {
        
        alertMessage = @"Camera is not available on simulator";
        
        
    }else if (alertType == ASAlertTypeForCardShouldHaveNameAndPhoto) {
        
        alertMessage = @"Card should have a name and at least one photo";
        
    }else{
        
        NSLog(@"For future posible extension");
    }
    
    //alert implementation
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


#pragma mark - handle actions

- (void) handleCamera {
    
#if TARGET_IPHONE_SIMULATOR
    
    //[self showAlertCameraIsNotAvailableOnSimulator];
    [self showAlertForType:ASAlertTypeForCameraIsNotAvailable];
    
#elif TARGET_OS_IPHONE
    
    [self setAndShowImagePicker];
    
#endif
}


- (void) handleImageGallery {
    
    //self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker = [[ASImagePickerVC alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
/*#warning Right or wrong !!?!?!?!?!
 - (void)imagePickerControllerfault:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
 
 static NSInteger imageIncrementNumber = 1;
 
 ASCardImageCell *cell = (ASCardImageCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
 
 // Get the image from the result
 UIImage* image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
 
 // Get the data for the image as a PNG
 NSData* imageData = UIImagePNGRepresentation(image);
 
 
 //    NSData *imageData = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
 //    UIImage *img = [[UIImage alloc]initWithData:imageData];
 
 
 // Now, we have to find the documents directory so we can save it
 NSString* imageName = [NSString stringWithFormat:@"MyImage%ld.png", (long)imageIncrementNumber];
 imageIncrementNumber ++;
 
 // Now, we have to find the documents directory so we can save it
 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString* documentsDirectory = [paths objectAtIndex:0];
 
 // Now we get the full path to the file
 NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
 
 if (self.choosenCellPath.row == 0) {
 self.photo.frontPhotoPath = fullPathToFile;
 NSLog(@"Front");
 }else if (self.choosenCellPath.row == 1){
 self.photo.backPhotoPath = fullPathToFile;
 NSLog(@"Back");
 
 }
 
 NSLog(@"fullPathToFile = %@", fullPathToFile);
 
 // and then we write it out
 [imageData writeToFile:fullPathToFile atomically:NO];
 
 
 [cell.imgButton setBackgroundImage:image forState:UIControlStateNormal];
 cell.imgButton.titleLabel.layer.opacity = 0.0f;
 [self dismissViewControllerAnimated:YES completion:nil];
 
 
 
 
 
 /*    //================ Last working variant (below) =================
 
 //    ASCardImageCell *cell = (ASCardImageCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
 //
 //    NSData *dataImage = UIImagePNGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
 //    UIImage *img = [[UIImage alloc]initWithData:dataImage];
 //
 //    if (self.choosenCellPath == 0) {
 //        //self.photo.frontPhoto =
 //    }else if (self.choosenCellPath == 1){
 //        //self.photo.backPhoto =
 //    }
 //
 //    [cell.imgButton setBackgroundImage:img forState:UIControlStateNormal];
 //    cell.imgButton.titleLabel.layer.opacity = 0.0f;
 //    [self dismissViewControllerAnimated:YES completion:nil];
 
 }
 */ //old realization

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        //if ([mediaType isEqualToString:UIImagePickerControllerMediaURL]) {
        
        NSLog(@"You choose image");
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *referenceUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            NSString *imageName = [imagePath lastPathComponent];
            
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            
            // Now we get the full path to the file
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
            
            [self setImageForButton:originalImage andSaveImageFilePath:fullPathToFile];
            
        }else{
            
            [self pickMediaWithImage:originalImage url:referenceUrl];
        }
#warning implement alert for picking Movie.
    }
    else if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        
        NSLog(@"ALARM MOVIE !!!");
    }
}


#pragma mark - UIImagePickerController Additional

- (void)pickMediaWithImage:(UIImage *)image url:(NSURL *)url{
    
    if (image == nil){
        
        NSLog(@"Image == nil"); //this line for movie (may be deleted!!!)
    }
    else {
        
        if (url){
            
            // photo gallery
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.includeHiddenAssets = YES;
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:fetchOptions];
            PHAsset *asset = result.firstObject;
            
            PHImageRequestOptions * imageRequestOptions = [[PHImageRequestOptions alloc] init];
            imageRequestOptions.synchronous = YES;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                NSURL *fileUrl = [info objectForKey:@"PHImageFileURLKey"];
                NSString *fileName = [[fileUrl absoluteString] lastPathComponent];
                NSLog(@"FilePath or FileName %@", fileName);
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
                NSLog(@"FILEPATH %@",filePath);
                
                [self setImageForButton:image andSaveImageFilePath:filePath];
            }];
        }
        else{
            
            // photo from camera
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            
            //Timestamp attach to name (always unique).
            NSString * fileName = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
            
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
            
            NSLog(@"FilePath %@", filePath);
            
            [self setImageForButton:image andSaveImageFilePath:filePath];
        }
    }
}


- (void) saveChosenImagePathToCardModel:(NSString *)imagePath {
    
    //NSLog(@"saveChosenImageCardPathToModel");
    if (self.choosenCellPath.row == 0) {
        self.photo.frontPhotoPath = imagePath;
        NSLog(@"Front");
    }else if (self.choosenCellPath.row == 1){
        self.photo.backPhotoPath = imagePath;
        NSLog(@"Back");
    }
}


- (void) setChosenImageToTappedImageChoiceButton:(UIImage *)chosenImage {
    
    
    NSLog(@"setChosenImageToTappedImageChoiceButton");
    ASCardImageCell *cell = (ASCardImageCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
    
    //=========================================
    cell.chosenImage = chosenImage;
    //=========================================

    //[cell.imgButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    //[cell.imgButton.imageView setImage:chosenImage];
    [cell.imgButton setImage:chosenImage forState:UIControlStateNormal];
    
    [cell.imgButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //cell.imgButton.contentMode = UIViewContentModeScaleAspectFit;
    //[cell.imgButton sizeToFit];
    cell.imgButton.titleLabel.layer.opacity = 0.0f;
}


- (void) saveChosenImageToFilePath:(UIImage *)image toFilePath:(NSString*)filePath {
    
#warning WRITE TO URL OR FILE (EXAMPL ABOVE,FIRST IMPLEMENTATION OF METHOD) ??????
    //[imageData writeToURL:[NSURL fileURLWithPath:filePath] atomically:YES];
    //[imageData writeToFile:fullPathToFile atomically:YES];
    NSLog(@"saveChosenImage toFilePath");
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [imageData writeToFile:filePath atomically:YES];
}


#pragma mark - Add new Fields to the table (location fill).
//- (IBAction)addNewField:(id)sender {
//
//    [self.itemsArray addObject:@10];
//    [self.itemsArray addObject:@10];
//    [self.tableView reloadData];
//}


#warning CHECK IF THIS METOD IS NEEDED.
- (void)checkButtonTapped:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath.row != 2){
        [self dismissKeyboardTable];
    }
    
    if (indexPath != nil) {
        
        self.choosenCellPath = indexPath;
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                
                [self setAndShowActionSheetForChoseImageFolder];
                
            }else {
                
                [self setupAlertCtrl];
                [self presentViewController:self.alertController
                                   animated:YES
                                 completion:nil];
            }
        }else if (indexPath.row == [self.itemsArray count] - 1) {
            NSLog(@"Notifications button action");
        }else {
            NSLog(@"Tap on textField");
        }
    }
}


#pragma mark - Navigation Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[ASMapSelectLocationVC class]]) {
        ASMapSelectLocationVC *mapLocationVC = segue.destinationViewController;
        mapLocationVC.indexPath = self.choosenCellPath;
    }
}


#pragma mark - Unwind Segue

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
    
     ASTextFieldCell *locationCell = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
    
    if ([segue.identifier isEqualToString:@"unwindFromAllNearestPlaces"]) {
        
        ASShowAllNearestPlacesVC *placesVC = segue.sourceViewController;
        //NSString *locationCardAdress = placesVC.chosenPlace;
        //locationCell.textField.text = locationCardAdress;
        //self.place.name = locationCardAdress;
        
        GooglePlacesObject *placesObj = placesVC.placeObj;
        NSLog(@"GooglePlacesObject = %@", placesObj);
        
        locationCell.textField.text = placesObj.name;
        self.place.name = placesObj.name;
        self.place.placeID = placesObj.placeId;
        NSLog(@"GOOGLE PLACES id: %@", placesObj.placeId);
        NSLog(@"google places name = %@", placesObj.name);
        
    }else if ([segue.identifier isEqualToString:@"unwindFromMapSelectLocation"]) {
    
    ASMapSelectLocationVC *mapVC = segue.sourceViewController;
        
    NSString *locationCardAdress = mapVC.selectedLocationForCardField.text;
        
//    ASTextFieldCell *locationCell = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:self.choosenCellPath];
        
        if (locationCardAdress && ![locationCardAdress isEqualToString:@"Undefined place"]) {
            locationCell.textField.text = locationCardAdress;
            self.location.locationTitle = locationCardAdress;
        }else{
            locationCell.textField.text = @""; //define constant with empty string
        }
    
    //set values for Location model
    self.location.longitude = mapVC.longitude;
    self.location.latitude = mapVC.latitude;
    
    self.choosenCellPath = mapVC.indexPath;
    
    //functional for "Add new fields (Add Place, Location) if field location is chose"
    [self addNewFieldsForLocationAndPlaceIfNeeded];
    
    }else{
        
        NSLog(@"prepareForUnwind UNKNOWN segue");
    }
}


#pragma mark - Additional methods

- (void) setupDefaultTableSettings {
    
#warning I think implementation is wrong!
    //table have defaults 7 fields, this array is just for numberOfRowsInSection.
    self.itemsArray = [@[@1,@2,@3,@4,@5,@6,@7]mutableCopy];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


- (void)initializeAllModels {
    
    self.card     = [[ASCard alloc]init];
    self.location = [[ASLocation alloc]init];
    self.photo    = [[ASPhoto alloc]init];
    self.place    = [[ASPlace alloc]init];
}


- (BOOL) isNewCardHaveAtLeastOneImage {
    
    BOOL isHaveAtLeastOneImage;
    if (self.photo.frontPhotoPath || self.photo.backPhotoPath) {
        isHaveAtLeastOneImage = YES;
    }else {
        isHaveAtLeastOneImage = NO;
    }
    
    return isHaveAtLeastOneImage;
}


- (BOOL) isNewCardHaveName {
    
    return self.card.name.length > 0;
}


- (void)addNewFieldsForLocationAndPlaceIfNeeded {
    
//    NSLog(@"chosenCellPath = %ld", (long)self.choosenCellPath.row);
//    NSLog(@"location PlaceTitle length : %ld", (unsigned long)self.location.locationTitle.length);
    
    if (self.choosenCellPath.row > 3 && self.choosenCellPath.row == [self.itemsArray count] - 3 && self.choosenCellPath.row % 2 == 0 && self.location.locationTitle.length > 0) {
        
        [self.itemsArray addObject:@"Object for new Place"];
        [self.itemsArray addObject:@"Object for new Location"];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.itemsArray count]- 4  inSection:0];
        
        ASTextFieldCell *cellWithCategoryTitle = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        cellWithCategoryTitle.textField.text = nil;
        
        [self.tableView reloadData];
    }
}


- (void) setImageForButton:(UIImage*) chosenImage andSaveImageFilePath:(NSString*)imageFilePath {
    
    [self saveChosenImagePathToCardModel:imageFilePath];
    [self setChosenImageToTappedImageChoiceButton:chosenImage];
    [self saveChosenImageToFilePath:chosenImage toFilePath:imageFilePath];
}


- (void)saveAllCardFillInfoToDataBase {
    
    //save all to database!
    
    //photo
    [[ASDatabaseManager sharedManager]
     insertPhotoRecordDataInDBtableWithFrontPhoto:self.photo.frontPhotoPath
                                     andBackPhoto:self.photo.backPhotoPath];
    
    NSInteger idForPhoto = [[ASDatabaseManager sharedManager]returnLastInsertedRowID];
    self.card.photo_id = idForPhoto;
    NSLog(@"%ld",(long)idForPhoto);
    //====================================================================
    
    
    //card
    //if user not chose category type for card then we set default from which (category viewer) come from
    if(!self.card.category_id){
        self.card.category_id = self.categoryForNewCard.iD;
    }
    
    [[ASDatabaseManager sharedManager]
     insertCardRecordDataInDBtableWithName:self.card.name
     inCategoryWithID:self.card.category_id
     withExpDate:self.card.expDate
     andPhotoID:self.card.photo_id];
//    NSLog(@"category_id = %lu", (unsigned long)self.card.category_id);
//    NSLog(@"exp date = %@", self.card.expDate);
//    NSLog(@"photo_id = %lu", (unsigned long)self.card.photo_id);
    NSInteger idForCard = [[ASDatabaseManager sharedManager]returnLastInsertedRowID];
    self.location.cardId = idForCard;

    //====================================================================
    
    
    //place
    
    [[ASDatabaseManager sharedManager]
     insertPlaceRecordDataInDBtableWithName:self.place.name
     withAddress:self.place.address
     withTypes:self.place.types
     withPhoneNumber:self.place.phoneNumber
     withWebsite:self.place.website
     withOpeningHourse:self.place.openinigHourse
     withVicinity:self.place.vicinity
     andPlaceID:self.place.placeID];
    
    NSInteger idForPlace = [[ASDatabaseManager sharedManager]returnLastInsertedRowID];
    NSLog(@"idForPlace = %ld", (long)idForPlace);
    NSLog(@"place name = %@",self.place.name);
    self.location.placeId = idForPlace;
    //====================================================================

    
    //location
    [[ASDatabaseManager sharedManager]
     insertLocationRecordDataInDBtableWithLocationTitle:self.location.locationTitle
                                             withCardID:self.location.cardId
                                            withPlaceID:self.location.placeId
                                          withLongitude:self.location.longitude
                                            andLatitude:self.location.latitude];
    NSLog(@"location place id = %ld", (long)self.location.placeId);
    //====================================================================


}


- (void)checkAndSetIfCardHaveDefaultCategory {
    
    if (self.categoryForNewCard) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.itemsArray count]-2 inSection:0];
        ASTextFieldCell *selectionCategoryField = (ASTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        selectionCategoryField.textField.text = self.categoryForNewCard.name;
    }
}


- (void)setAndShowImagePicker {
    
    [self setAndShowImagePicker];
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.delegate = self;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


- (void)animateTableViewPositionForItem:(id)item up:(BOOL)up {
    
    const int movementDistance = 110;
    //int movementDistance;
    const float movementDuration = 0.3f;
    
//    if ([item isKindOfClass:[UITableViewCell class]]) {
//        UITableViewCell *chosenCell = item;
//        NSArray *subviewsArray = [chosenCell subviews];
//        if ([subviewsArray count] > 0 && [subviewsArray count] < 2) {
//            UITextField *textFieldOnCell = [subviewsArray objectAtIndex:0];
//            
//            if ([textFieldOnCell.text isEqualToString:@"Category"]) {
//                movementDistance = 140;
//            }
//        }
//        
//    }else{
//        movementDistance = 110;
//    }
    
    
    
    int movement = (up ? -movementDistance : movementDistance);
    
    //scroll tableView when end editing occure
    CGPoint point = self.tableView.contentOffset;
    NSLog(@"Content offset = %@", NSStringFromCGPoint(point));
    point.y = self.tableView.rowHeight;
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.tableView.frame = CGRectOffset(self.tableView.frame, 0, movement);
    self.tableView.contentOffset = point;

    [UIView commitAnimations];
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (self.actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self handleCamera];
                    break;
                case 1:
                    [self handleImageGallery];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}


#pragma mark - Additional

- (void)defineAllAvailableCategories {
    
    self.availableCategories = [[ASDatabaseManager sharedManager]getAllDataFromDBtableName:@"category"];
}


#pragma mark - Keyboard notifications and handler methods.

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


- (void)disableForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    
    NSLog(@"%@",[aNotification userInfo]);
    //=====================================
//    CGRect frame = self.view.frame;
//    frame.origin.y = -30;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.frame = frame;
//    }];
//    
    //-===================
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
//        [self.tableView scrollRectToVisible:self.activeField.frame animated:YES];
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
    
}


-(void)dismissKeyboardTable{
    NSLog(@"======================================================================");
//    [self.nameField becomeFirstResponder];
//    [self.nameField endEditing:YES];
//    [self.nameField resignFirstResponder];
}


#pragma mark - ASCardImageCellDelegate

- (void)setImageForCell:(ASCardImageCell*)cell {
    
//    NSIndexPath *path = [self.tableView indexPathForCell:cell];
//    if(cell.imgButton){
//        [self.indexSetFroButton addIndex:path.row];
//    }else{
//        [self.indexSetFroButton removeIndex:path.row];
//    }
    NSLog(@"ASCardImageCellDelegate");
}

@end
