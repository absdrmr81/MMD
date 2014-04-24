//
//  SignUpViewController.m
//  MMD
//
//  Created by Drmrboy on 4/16/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "GreetingsViewController.h"

@interface SignUpViewController ()

@property (nonatomic, strong) PFUser *user;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)signUp:(id)sender
{
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Make sure you enter a username, password, and email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        self.user = [PFUser user];
        self.user.username = username;
        self.user.password = password;
        self.user.email = email;
        
        [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Yikes!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 
                 [alertView show];
             }
             else
             {
                 [self performSegueWithIdentifier:@"startRegistration" sender:self];
             }
         }];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

@end
