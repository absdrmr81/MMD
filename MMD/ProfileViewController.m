//
//  ProfileViewController.m
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

@end
