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
@property (strong, nonatomic) IBOutlet UIButton *doneButtonPressed;

@end

@implementation BreedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    
    
    self.doneButtonPressed.layer.borderColor = [UIColor colorWithRed:124/255.0f green:140/255.0f blue:48/255.0f alpha:1.0f].CGColor;
    self.doneButtonPressed.layer.borderWidth = 1;
    self.doneButtonPressed.layer.cornerRadius = 5;
    
    self.dogNameLabel.text = self.dogNameString;
    user = [PFUser currentUser];

    
    //Hardcoding different breeds
    NSArray *breeds = @[@"Afghan Hound", @"Aidi", @"Airedale Terrier", @"Akita Inu", @"Alaskan Klee Kai", @"Alaskan Malamute", @"American Cocker Spaniel",  @"Beagle", @"Boston Terrier", @"Boxer", @"Bulldog", @"Dachshund", @"German Shepherd", @"Golden Retriever", @"Great Dane", @"Greyhound", @"Komondor", @"Labrador Retriever", @"Maltese", @"Miniature Schnauzer", @"Poodle", @"Rottweiler", @"Shar Pei", @"Yorkshire Terrier"];
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
