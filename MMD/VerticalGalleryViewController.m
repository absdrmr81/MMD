//
//  VerticalGalleryViewController.m
//  MMD
//
//  Created by Drmrboy on 5/1/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "VerticalGalleryViewController.h"
#import "SWRevealViewController.h"

@interface VerticalGalleryViewController ()

@end

@implementation VerticalGalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dogPix = [@[@"gal0",
                 @"gal1",
                 @"gal2",
                 @"gal3",
                 @"gal4"] mutableCopy];

    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f]}];

    

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dogPix.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *myCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    
    UIImage *image;
    long row = [indexPath row];
    
    image = [UIImage imageNamed:_dogPix[row]];
    
    myCell.imageView.image = image;
    
    return myCell;
}


@end
