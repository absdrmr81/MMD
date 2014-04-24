////
////  ViewController.m
////  MMD
////
////  Created by Marlon Simeus on 4/14/14.
////  Copyright (c) 2014 Marlon Simeus. All rights reserved.
////
//
//#import "ViewController.h"
//#import <Parse/Parse.h>
//#import "MapKit/MapKit.h"
//#import "CoreLocation/CoreLocation.h"
//#import "BreedViewController.h"
//#import "SWRevealViewController.h"
//
//
////@interface ViewController () <UISearchBarDelegate>
////{
////    MKLocalSearch *localSearch;
////    MKLocalSearchResponse *results;
////}
////@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
////@property (strong, nonatomic) IBOutlet MKMapView *mapView;
////
////@end
//
//@implementation ViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.title = @"Home";
//    
//    //Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    
//    PFUser *currentUser = [PFUser currentUser];
//    if (currentUser)
//    {
//        NSLog(@"Current user: %@", currentUser.username);
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"showLogin" sender:self];
//    }
//    
//    
//    //define span of map
//    MKCoordinateSpan span;
//    span.latitudeDelta = .08;
//    span.longitudeDelta = .08;
//    
//    //define starting point for map
//    CLLocationCoordinate2D start;
//    start.latitude = 41.89373984;
//    start.longitude = -87.63532979;
//    
//    //create region
//    MKCoordinateRegion region;
//    region.span = span;
//    region.center = start;
//    
//    //move the map to our location
//    [self.mapView setRegion:region animated:YES];
//    self.mapView.showsUserLocation = YES;
//    
//    [self.mapView setUserInteractionEnabled:YES];
//    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
//    
//    [self.searchBar resignFirstResponder];
//    
//    
//    
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
//    request.naturalLanguageQuery = @"Dog Parks";
//    request.region = self.mapView.region;
//    
//    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        NSLog(@"response = %@", response);
//    }];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:NO];
//}
//
//- (IBAction)logOut:(id)sender
//{
//    [PFUser logOut];
//    [self performSegueWithIdentifier:@"showLogin" sender:self];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"showLogin"])
//    {
//        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    }
//}
//
//- (IBAction)unwindToMapView:(UIStoryboardSegue *)sender
//{
//    BreedViewController *source;
//    source = [sender sourceViewController];
//}


//@end
