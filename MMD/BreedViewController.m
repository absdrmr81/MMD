//
//  BreedViewController.m
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "BreedViewController.h"
#import "MoodViewController.h"
#import <Parse/Parse.h>

@interface BreedViewController ()
{
    PFUser *user;
}

@end

@implementation BreedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dogNameLabel.text = self.dogNameString;
    user = [PFUser currentUser];

    self.breeds = @[@"Beagle", @"Boxer", @"Bulldog", @"Dachshund", @"German Shepherd", @"Golden Retriever", @"Labrador Retriever", @"Poodle", @"Rottweiler", @"Yorkshire Terrier"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.breeds.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.breeds[row];
}

- (IBAction)saveBreed:(id)sender
{
    PFObject *dogBreed = [PFUser currentUser];
    dogBreed[@"dogBreed"] = self.breeds;
    
    [dogBreed saveInBackground];
}

@end
