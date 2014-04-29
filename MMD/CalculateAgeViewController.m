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
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    user = [PFUser currentUser];
    self.dogNameLabel.text = self.dogNameString;
}
    
- (IBAction)calculateDogsAgeButtonPressed:(id)sender
{
    NSString *retrievedDogAgeField = self.dogAgeField.text;
    
    if ([retrievedDogAgeField length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:[NSString stringWithFormat:@"Please put in %@'s age in human years", self.dogNameLabel.text] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        int convertAgetoInt = [retrievedDogAgeField intValue];
        int calculatedAge = (((convertAgetoInt -2) * 4) + 21);
        self.calculatedAgeField.text = [NSString stringWithFormat:@"%d", calculatedAge];
    }
}

- (IBAction)saveAge:(id)sender
{
    NSString *age = [self.dogAgeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *retrievedCalculatedAgeField = self.calculatedAgeField.text;
    
    int convertAgeToInt = [retrievedCalculatedAgeField intValue];
    self.calculatedAgeField.text = [NSString stringWithFormat:@"%d", convertAgeToInt];
    
    NSNumber *number = [NSNumber numberWithInt:convertAgeToInt];
    PFObject *currentUser = [PFUser currentUser];
    
    currentUser[@"dogAge"] = number;
    [currentUser saveInBackground];

    if ([age length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you calculate your dog's into doggie years." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        [self performSegueWithIdentifier:@"showBreeds" sender:self];
    }
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
