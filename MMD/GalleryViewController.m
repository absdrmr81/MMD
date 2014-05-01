//
//  GalleryViewController.m
//  MMD
//
//  Created by Drmrboy on 4/30/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "GalleryViewController.h"
#import <Parse/Parse.h>

@interface GalleryViewController () <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
    UIImageView *imageView;
    NSArray *imageViews;
    IBOutlet UIScrollView *myScrollView;
}
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation GalleryViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];

    CGFloat width = 0.0f;
    
//    imageViews = [];
//    imageViews = @[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"milkyWay.png"]],
//                   [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number2.jpg"]]];
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
- (IBAction)camerButtonPressed:(id)sender
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
	if((UIButton *) sender == self.cameraButton)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    // saving a uiimage to pffile
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData* data = UIImageJPEGRepresentation(pickedImage,1.0f);
    PFFile *imageFile = [PFFile fileWithData:data];
    PFUser *user = [PFUser currentUser];
    user[@"avatar"] = imageFile;
    
    // getting a uiimage from pffile
    [self.currentUser[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            imageView.image = photo;
        }
    }];
    
    [user save];
}

//returning the view we intend to zoom (doing this is case of multiple views (scrollview need to know specifically which view to scroll)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

@end
