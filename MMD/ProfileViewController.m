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
