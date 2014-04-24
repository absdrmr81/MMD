//
//  NamesViewController.h
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NamesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *ownerFirstNameField;
@property (strong, nonatomic) IBOutlet UITextField *ownerLastNameField;
@property (strong, nonatomic) IBOutlet UITextField *dogNameField;

- (IBAction)saveNames:(id)sender;

@end
