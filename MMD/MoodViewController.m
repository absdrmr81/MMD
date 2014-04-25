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
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:132/255.0f green:128/255.0f blue:98/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    user = [PFUser currentUser];

    self.dogNameLabel.text = self.dogNameString;
}

@end
