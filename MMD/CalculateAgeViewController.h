//
//  CalculateAgeViewController.h
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculateAgeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dogNameLabel;
@property (strong, nonatomic) NSString *dogNameString;
@property (strong, nonatomic) IBOutlet UITextField *dogAgeField;
@property (strong, nonatomic) IBOutlet UILabel *calculatedAgeField;

- (IBAction)saveAge:(id)sender;

@end
