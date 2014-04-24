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
    user = [PFUser currentUser];
}

- (IBAction)saveNames:(id)sender
{
    NSString *ownerFName = [self.ownerFirstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *ownerLName = [self.ownerLastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *dogName = [self.dogNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    PFObject *names = [PFUser currentUser];
    names[@"ownerFName"] = self.ownerFirstNameField.text;
    names[@"ownerLName"] = self.ownerLastNameField.text;
    names[@"dogName"] = self.dogNameField.text;
    
    [names saveInBackground];

    
    if ([ownerFName length] == 0 || [ownerLName length] == 0 || [dogName length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter your first name, last initial and of course your dog's name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
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
        cvc.ownerNameString = self.ownerFirstNameField.text;
        cvc.dogNameString = self.dogNameField.text;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.ownerFirstNameField resignFirstResponder];
    [self.ownerLastNameField resignFirstResponder];
    [self.dogNameField resignFirstResponder];
}

@end
