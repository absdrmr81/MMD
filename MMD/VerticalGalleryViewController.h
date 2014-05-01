//
//  VerticalGalleryViewController.h
//  MMD
//
//  Created by Drmrboy on 5/1/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewCell.h"

@interface VerticalGalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *dogPix;

@end
