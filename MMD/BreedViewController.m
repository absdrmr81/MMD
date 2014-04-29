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
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    self.dogNameLabel.text = self.dogNameString;
    user = [PFUser currentUser];

    NSArray *breeds = @[@"Beagle", @"Boxer", @"Bulldog", @"Dachshund", @"German Shepherd", @"Golden Retriever", @"Labrador Retriever", @"Poodle", @"Rottweiler", @"Yorkshire Terrier"];
    array = breeds;
    self.breedPicker.delegate = self;
    
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

//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    self.breedLabel.text = [array objectAtIndex:row];
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [array objectAtIndex:row];
}

- (IBAction)saveBreed:(id)sender
{
    NSString *breedString = [array objectAtIndex:[self.breedPicker selectedRowInComponent:0]];
//    NSString *title = [[NSString alloc]initWithFormat:@"You have selected %@!", breedString];
    
    PFObject *currentUser = [PFUser currentUser];

    currentUser[@"dogBreed"] = [NSString stringWithFormat:@"%@", breedString];
    [currentUser saveInBackground];
//    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"Yay!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//            
//            [alert show];
//        }
//        else{
//            NSLog(@"error = %@", error);
//        }
//    }];
}

@end
