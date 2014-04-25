//
//  LoginViewController.m
//  MMD
//
//  Created by Drmrboy on 4/16/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:61/255.0f green:50/255.0f blue:6/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];


}

- (IBAction)logIn:(id)sender
{
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Yikes!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 
                 [alertView show];
             }
             else
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }];
    }
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

@end
