//
//  BreedViewController.m
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "BreedViewController.h"
#import <Parse/Parse.h>

@interface BreedViewController ()
{
    PFUser *user;
    NSArray *array;
}

@end

@implementation BreedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    self.dogNameLabel.text = self.dogNameString;
    user = [PFUser currentUser];

    NSArray *breeds = @[@"Beagle", @"Boxer", @"Bulldog", @"Dachshund", @"German Shepherd", @"Golden Retriever", @"Labrador Retriever", @"Poodle", @"Rottweiler", @"Yorkshire Terrier"];
    array = breeds;
    
}

#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return array.count;
}

#pragma mark Picker Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [array objectAtIndex:row];
}

- (IBAction)saveBreed:(id)sender
{
    NSString *breedString = [array objectAtIndex:[self.breedPicker selectedRowInComponent:0]];
    NSString *title = [[NSString alloc]initWithFormat:@"You have selected %@!", breedString];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"Yay!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alert show];
    PFObject *currentUser = [PFUser currentUser];
    currentUser[@"dogBreed"] = [NSString stringWithFormat:@"%@", breedString];
    
    [currentUser saveInBackground];
}

@end
