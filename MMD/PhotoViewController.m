//
//  PhotoViewController.m
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "PhotoViewController.h"
#import "SWRevealViewController.h"


@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;

    //This is a new comment
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
//    self.photoImageView.image = [UIImage imageNamed:self.photoFilename];
}


@end
