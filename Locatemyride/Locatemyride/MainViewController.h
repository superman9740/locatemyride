//
//  MainViewController.h
//  Locatemyride
//
//  Created by sdickson on 12/2/13.
//  Copyright (c) 2013 dickson. All rights reserved.
//

#import "FlipsideViewController.h"
@import CoreLocation;
@import MapKit;
@import MobileCoreServices;
@import QuartzCore;



@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{

    NSString* imagePath;
    UIImagePickerController* pickerController;
    
    
}

@property (strong, nonatomic) IBOutlet UILabel* locationLabel;
@property (strong, nonatomic) IBOutlet UILabel* currentLocationLabel;


@property (strong, nonatomic) IBOutlet UIImageView* imageView;


@property (strong, nonatomic) IBOutlet UIButton* saveLocationButton;
@property (strong, nonatomic) IBOutlet UIButton* takeAPhotoButton;


@property (strong, nonatomic) CLLocation* location;

@property (strong, nonatomic) CLLocation* savedLocation;

@property (strong, nonatomic) CLLocationManager* locManager;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;



-(IBAction)saveLocation:(id)sender;
-(IBAction)takeToRide:(id)sender;
-(IBAction)takeAPhoto:(id)sender;


@end
