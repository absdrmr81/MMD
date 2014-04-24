//
//  CalculateAgeViewController.m
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "CalculateAgeViewController.h"
#import "BreedViewController.h"
#import <Parse/Parse.h>

@interface CalculateAgeViewController ()
{
    PFUser *user;
}
@end

@implementation CalculateAgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [PFUser currentUser];
    self.dogNameLabel.text = self.dogNameString;
}

- (IBAction)calculateDogsAgeButtonPressed:(id)sender
{
    NSString *retrievedDogsAgeField = self.dogAgeField.text;
    
    int convertAgetoInt = [retrievedDogsAgeField intValue];
    
    int calculatedAge = (((convertAgetoInt -2) * 4) + 21);
    
    self.calculatedAgeField.text = [NSString stringWithFormat:@"%d", calculatedAge];
}

- (IBAction)saveAge:(id)sender
{
    NSString *age = [self.dogAgeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    PFObject *dogAge = [PFUser currentUser];
    NSString *retrievedCalculatedAgeField = self.calculatedAgeField.text;
    int convertAgeToInt = [retrievedCalculatedAgeField intValue];
    self.calculatedAgeField.text = [NSString stringWithFormat:@"%d", convertAgeToInt];
    dogAge[@"dogAge"] = self.calculatedAgeField.text;
    
    [dogAge saveInBackground];

    if ([age length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you calculate your dog's into doggie years." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    [self performSegueWithIdentifier:@"showBreeds" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBreeds"])
    {
        BreedViewController *cvc = (BreedViewController *)segue.destinationViewController;
        cvc.dogNameString = self.dogNameLabel.text;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.dogAgeField resignFirstResponder];
}

@end
