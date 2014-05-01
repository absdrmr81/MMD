//
//  ProfileViewController.m
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "NamesViewController.h"
#import "CalculateAgeViewController.h"
#import "BreedViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@interface ProfileViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (strong, nonatomic) IBOutlet UIButton *profilePicButton;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:237/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:222/255.0f alpha:1.0f]}];
    
    self.title = @"Profile";
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.currentUser = [PFUser currentUser];

    if (self.currentUser)
    {
        NSLog(@"Current user: %@", self.currentUser.username);
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    
    CALayer *imageLayer = self.profilePicImageView.layer;
    [imageLayer setCornerRadius:51];
    [imageLayer setBorderWidth:1];
    [imageLayer setBorderColor:[UIColor colorWithRed:124/255.0f green:140/255.0f blue:48/255.0f alpha:1.0f].CGColor];
    [imageLayer setMasksToBounds:YES];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.currentUser = [PFUser currentUser];
    self.dogNameLabel.text = self.currentUser[@"dogName"];
    self.dogBreedLabel.text = self.currentUser[@"dogBreed"];
    self.dogAgeLabel.text = [self.currentUser[@"dogAge"] description];
    
    if (self.currentUser[@"avatar"])
    {
        [self.currentUser[@"avatar"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *photo = [UIImage imageWithData:data];
                self.profilePicImageView.image = photo;
            }
        }];
    }
    else
    {
        self.profilePicImageView.image = [UIImage imageNamed:@"ic_profile_pressed"];
    }
    self.profilePicImageView.clipsToBounds = YES;
    
}

- (IBAction)profilePicButtonPressed:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
	if((UIButton *) sender == self.profilePicButton)
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
            self.profilePicImageView.image = photo;
        }
    }];
    
    [user save];
}



- (IBAction)logOut:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLogin"])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
}

- (IBAction)unwindToMapViewController:(UIStoryboardSegue *)sender
{

}

@end
