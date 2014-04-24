//
//  MapViewController.m
//  X
//
//  Created by Marlon Simeus on 4/21/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "BreedViewController.h"
#import <Parse/Parse.h>





@interface MapViewController () <CLLocationManagerDelegate>
{
    CLLocationManager *localManager;
    CLLocation *currentLocation;
    NSArray *Name;
}
@property MKPointAnnotation *currentPlaceAnnotation;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSMutableArray *title;




@end

@implementation MapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser)
    {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else
    {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    //define span of map
    MKCoordinateSpan span;
    span.latitudeDelta = .008;
    span.longitudeDelta = .008;
    
    //define starting point for map
    CLLocationCoordinate2D start;
    start.latitude = 41.89373984;
    start.longitude = -87.63532979;

    
    //create region
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
  
    //move the map to our location
    [self.mapView setRegion:region animated:YES];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
   

    
    // Add pan gesture to hide the sidebar
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            [[PFUser currentUser] setObject:geoPoint forKey:@"current location"];
            [[PFUser currentUser] saveInBackground];
            
            PFQuery *User = [PFUser query];
            [User selectKeys:@[@"username"]];
            [User findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                Name = results;
            }];
        }
    }];
    
    PFQuery *Location = [PFUser query];
    [Location selectKeys:@[@"currentLocation",]];
    [Location findObjectsInBackgroundWithBlock:^(NSArray *location, NSError *error) {
        
    }];
    
    
    MKMapView * map = [[MKMapView alloc] initWithFrame:self.view.bounds];
//    map.delegate = self;
    
//    [self.view addSubview:map];
    
    //Call this method
    [self CurrentLocationIdentifier];
}

//Current Location Address
- (void) CurrentLocationIdentifier
{
    //Getting current GPS location
    localManager = [CLLocationManager new];
    localManager.delegate = self;
    localManager.distanceFilter = kCLDistanceFilterNone;
    localManager.desiredAccuracy = kCLLocationAccuracyBest;
    [localManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [localManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             
             //Showing current address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             //             CountryArea = NULL;
         }
         
         
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
}

@end
