//
//  ProfileViewController.h
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dogNameLabel;
@property (strong, nonatomic) NSString *dogNameString;

@property (strong, nonatomic) IBOutlet UILabel *dogBreedLabel;
@property (strong, nonatomic) NSString *dogBreedString;

@property (strong, nonatomic) IBOutlet UILabel *dogAgeLabel;
@property (strong, nonatomic) NSNumber *dogAgeNumber;

- (IBAction)logOut:(id)sender;


@end
