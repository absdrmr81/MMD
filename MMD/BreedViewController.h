//
//  BreedViewController.h
//  MMD
//
//  Created by Drmrboy on 4/15/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreedViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *dogNameLabel;
@property (strong, nonatomic) NSString *dogNameString;
@property (strong, nonatomic) IBOutlet UIPickerView *breedPicker;

@end
