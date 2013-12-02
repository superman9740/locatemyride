//
//  FlipsideViewController.m
//  Locatemyride
//
//  Created by sdickson on 12/2/13.
//  Copyright (c) 2013 dickson. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)awakeFromNib
{
    self.preferredContentSize = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios_linen.png"]];
    _navBar.barTintColor = [UIColor lightGrayColor];
}

-(IBAction)reset:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:nil forKey:@"savedLatitude"];
    [defaults setObject:nil forKey:@"savedLongitude"];
    [defaults setObject:nil forKey:@"imagePath"];
    _imageView.image = nil;
    
    
    [defaults synchronize];
    

    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Reset" message:@"Your ride information has been reset." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
