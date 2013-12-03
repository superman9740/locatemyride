//
//  MainViewController.m
//  Locatemyride
//
//  Created by sdickson on 12/2/13.
//  Copyright (c) 2013 dickson. All rights reserved.
//

#import "MainViewController.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios_linen.png"]];
    _locManager = [[CLLocationManager alloc] init];
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locManager startUpdatingLocation];
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
 
    //Check to see if we have a saved location
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* lat = [defaults objectForKey:@"savedLatitude"];
    NSNumber* lon = [defaults objectForKey:@"savedLongitude"];
    NSString* imagePathStr = [defaults objectForKey:@"imagePath"];
    UIImage* image = [UIImage imageWithContentsOfFile:imagePathStr];
    _imageView.image = image;
    _imageView.layer.cornerRadius = 8.0;
    _imageView.layer.masksToBounds = YES;
    
    
    
    if(lat)
    {
        _savedLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
        
        _locationLabel.text = [NSString stringWithFormat:@"lat - %+.6f lon - %+.6f",_savedLocation.coordinate.latitude, _savedLocation.coordinate.longitude];
        _currentLocationLabel.text = @"Saved Location";
        
        [_saveLocationButton setTitle:@" " forState:UIControlStateNormal];
        [_takeAPhotoButton setTitle:@" " forState:UIControlStateNormal];
        
        _saveLocationButton.titleLabel.text = @"Location has been saved.";
        _saveLocationButton.enabled = NO;
        haveSavedLocation = YES;
        
        
    }
    else
    {
        
        _currentLocationLabel.text = @"Current Location";
        [_saveLocationButton setTitle:@"Save My Location " forState:UIControlStateNormal];
        
        _saveLocationButton.enabled = YES;
        
        
        [_takeAPhotoButton setTitle:@"Take a Photo " forState:UIControlStateNormal];
        
        haveSavedLocation = NO;
        
    }
    

    
}
-(IBAction)saveLocation:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* lat = [NSNumber numberWithDouble:_location.coordinate.latitude];
    NSNumber* lon = [NSNumber numberWithDouble:_location.coordinate.longitude];
    
    _savedLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
    
    
    [defaults setObject:lat forKey:@"savedLatitude"];

    [defaults setObject:lon forKey:@"savedLongitude"];
    [defaults setObject:imagePath forKey:@"imagePath"];
    
    [defaults synchronize];
    
    _locationLabel.text = [NSString stringWithFormat:@"lat - %+.6f lon - %+.6f",_savedLocation.coordinate.latitude, _savedLocation.coordinate.longitude];
    [_saveLocationButton setTitle:@" " forState:UIControlStateNormal];
    [_takeAPhotoButton setTitle:@" " forState:UIControlStateNormal];
    
    _currentLocationLabel.text = @"Saved Location";
    
    _saveLocationButton.enabled = NO;
    haveSavedLocation = YES;
    
}
-(IBAction)takeToRide:(id)sender
{
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_savedLocation.coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    [mapItem setName:@"My Ride"];
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
    
    
    
}
-(IBAction)takeAPhoto:(id)sender
{

    pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    pickerController.mediaTypes =     [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    
    [self presentModalViewController:pickerController animated:YES];
    
   
    


}
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        //Rotate image to view coordinates
        
        UIGraphicsBeginImageContext(imageToSave.size);
        
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, imageToSave.size.width/2, imageToSave.size.height/2);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, radians(90));
        CGContextScaleCTM(bitmap, 1.0f, -1.0f);
        // Now, draw the rotated/scaled image into the context
        CGContextDrawImage(bitmap, CGRectMake(-imageToSave.size.width / 2, -imageToSave.size.height / 2, imageToSave.size.width, imageToSave.size.height), [imageToSave CGImage]);
        
        UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        
        _imageView.image = rotatedImage;
        
    
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        imagePath = [documentDirectory stringByAppendingPathComponent:@"image.png"];
        NSData *png=UIImagePNGRepresentation(rotatedImage);
        
        
        [png writeToFile:imagePath atomically:YES];
        
    }
    
    [_takeAPhotoButton setTitle:@" " forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    [defaults setObject:imagePath forKey:@"imagePath"];
    
    [defaults synchronize];
    
    
    [pickerController dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker
{
    [pickerController dismissViewControllerAnimated:YES completion:nil];//Or call YES if you want the nice dismissal animation
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _location = [locations objectAtIndex:0];

    if(!haveSavedLocation)
    {
        _locationLabel.text = [NSString stringWithFormat:@"lat - %+.6f lon - %+.6f",_location.coordinate.latitude, _location.coordinate.longitude];
    }
    
    
    NSLog(@"Location has been updated:  lat - %+.6f lon - %+.6f",_location.coordinate.latitude, _location.coordinate.longitude);
          

    
    
}

@end
