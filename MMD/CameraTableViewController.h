//
//  CameraTableViewController.h
//  MMD
//
//  Created by Drmrboy on 4/26/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;

@end
