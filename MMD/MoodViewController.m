//
//  MoodViewController.m
//  MMD
//
//  Created by Drmrboy on 4/16/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "MoodViewController.h"
#import <Parse/Parse.h>

@interface MoodViewController ()
{
    PFUser *user;
}

@end

@implementation MoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    user = [PFUser currentUser];

    self.dogNameLabel.text = self.dogNameString;
}

@end
