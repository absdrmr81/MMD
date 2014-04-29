//
//  NamesViewController.m
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "NamesViewController.h"
#import "ConfirmationViewController.h"
#import <Parse/Parse.h>

@interface NamesViewController ()
{
    PFUser *user;
}
@end

@implementation NamesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    user = [PFUser currentUser];
}

- (IBAction)saveNames:(id)sender
{
    NSString *dogName = [self.dogNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    PFObject *currentUser = [PFUser currentUser];
    currentUser[@"dogName"] = self.dogNameField.text;
    
    [currentUser saveInBackground];
    
    if ([dogName length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter dog's name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        [self performSegueWithIdentifier:@"showConfirmation" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showConfirmation"])
    {
        ConfirmationViewController *cvc = (ConfirmationViewController *)segue.destinationViewController;
        cvc.dogNameString = self.dogNameField.text;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dogNameField resignFirstResponder];
}

@end
