//
//  GreetingsViewController.m
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "GreetingsViewController.h"

@interface GreetingsViewController ()
@property (strong, nonatomic) IBOutlet UIButton *startButtonPressed;

@end

@implementation GreetingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];



    self.startButtonPressed.layer.borderColor = [UIColor redColor].CGColor;
    self.startButtonPressed.layer.borderWidth = 1;
    self.startButtonPressed.layer.cornerRadius = .25;
}

@end
