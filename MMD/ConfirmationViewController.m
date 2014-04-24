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
    self.ownerNameLabel.text = self.ownerNameString;
    self.dogNameLabel1.text = self.dogNameString;
    self.dogNameLabel2.text = self.dogNameString;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ageID"])
    {
        CalculateAgeViewController *cvc = (CalculateAgeViewController *)segue.destinationViewController;
        cvc.dogNameString = self.dogNameLabel1.text;
    }
}

@end
