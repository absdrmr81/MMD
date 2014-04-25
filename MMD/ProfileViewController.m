//
//  ProfileViewController.m
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "BreedViewController.h"
#import <Parse/Parse.h>


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    self.dogNameLabel.text = self.dogNameString;
    
    //This is a comment 
    self.title = @"Profile";
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    PFUser *currentUser = [PFUser currentUser];    
//    currentUser[@"dogName"] = self.dogNameLabel.text;

    if (currentUser)
    {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLogin"])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)unwindToMapViewController:(UIStoryboardSegue *)sender
{
    BreedViewController *source;
    source = [sender sourceViewController];
}

@end
