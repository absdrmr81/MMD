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
@property (strong, nonatomic) IBOutlet UIButton *enterButtonPressed;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f]}];

    self.title = @"Sign Up";

    self.enterButtonPressed.layer.borderColor = [UIColor colorWithRed:124/255.0f green:140/255.0f blue:48/255.0f alpha:1.0f].CGColor;
    self.enterButtonPressed.layer.borderWidth = 1;
    self.enterButtonPressed.layer.cornerRadius = 5;
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
