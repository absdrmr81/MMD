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
{
    NSString *string1;
    NSString *fullString;
}
@end

@implementation ConfirmationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    string1 = @"!";
    fullString = [self.dogNameString stringByAppendingString:string1];
    self.dogNameLabel.text = fullString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ageID"])
    {
        CalculateAgeViewController *cvc = (CalculateAgeViewController *)segue.destinationViewController;

    }
}

//<<<<<<< HEAD
//cvc.dogNameString = self.dogNameLabel.text;
//=======
//
//NSString *first = self.dogNameString;
//NSString *second = @"!";
////        self.fullString = [NSString stringWithFormat:@"%@%@", first, second];
//
////        cvc.dogNameString = self.dogNameLabel.text;
//
//>>>>>>> 92fcafab27b0d739b7166446047c8a3e8705d02f

@end
