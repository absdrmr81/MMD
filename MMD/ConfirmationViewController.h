//
//  ConfirmationViewController.h
//  MMD
//
//  Created by Drmrboy on 4/16/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *ownerNameLabel;
@property (strong, nonatomic) NSString *ownerNameString;
@property (strong, nonatomic) IBOutlet UILabel *dogNameLabel1;
@property (strong, nonatomic) IBOutlet UILabel *dogNameLabel2;
@property (strong, nonatomic) NSString *dogNameString;

@end
