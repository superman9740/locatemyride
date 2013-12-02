//
//  FlipsideViewController.h
//  Locatemyride
//
//  Created by sdickson on 12/2/13.
//  Copyright (c) 2013 dickson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController
{
    
    
}

@property (nonatomic, strong) IBOutlet UINavigationBar* navBar;

@property (nonatomic, strong) IBOutlet UIImageView* imageView;

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

-(IBAction)reset:(id)sender;

- (IBAction)done:(id)sender;

@end
