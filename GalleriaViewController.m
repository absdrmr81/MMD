//
//  GalleriaViewController.m
//  MMD
//
//  Created by Drmrboy on 5/1/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "GalleriaViewController.h"
#import <Parse/Parse.h>

@interface GalleriaViewController () <UIScrollViewDelegate>

{
    UIImageView *imageView;
    NSArray *imageViews;
    IBOutlet UIScrollView *myScrollView;
}
@end

@implementation GalleriaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = 0.0f;
    
    imageViews = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gal0"]],
                   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gal1"]],
                   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gal2"]],
                   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gal3"]]];
    for (UIImageView *_imageView in imageViews)
    {
        [myScrollView addSubview:_imageView];
        _imageView.frame = CGRectMake(width, 0, self.view.frame.size.width, self.view.frame.size.height);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //aggregating widths
        width += _imageView.frame.size.width;
    }
    
    
    myScrollView.contentSize = CGSizeMake(width, myScrollView.frame.size.height);
    //instantieated imageVIew with an image
    //imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milkyWay.png"]];
    //[myScrollView addSubview:imageView];
    //setting scrollview's content size (CGsize) to imageView size (enables scrolling around to view whole image
    //myScrollView.contentSize = imageView.frame.size;
    
    //setting min/max scrollsize
    myScrollView.minimumZoomScale = 1.0;
    myScrollView.maximumZoomScale = 6.0;
    
    //setting up scrollview delegate
    myScrollView.delegate = self;
}

//returning the view we intend to zoom (doing this is case of multiple views (scrollview need to know specifically which view to scroll)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

@end
