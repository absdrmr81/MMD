//
//  ConfirmationViewController.m
//  MMD
//
//  Created by Drmrboy on 4/16/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "CalculateAgeViewController.h"

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    self.dogNameLabel.text = self.dogNameString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ageID"])
    {
        CalculateAgeViewController *cvc = (CalculateAgeViewController *)segue.destinationViewController;
        cvc.dogNameString = self.dogNameLabel.text;
    }
}

@end
