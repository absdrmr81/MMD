//
//  DogParkViewController.m
//  MMD
//
//  Created by Marlon Simeus on 4/25/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "DogParkViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"

@interface DogParkViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
    NSArray *foundDogParks;
    NSString *address;
    MKMapView *mapView;
   
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) PFGeoPoint *userLocation;

@end

@implementation DogParkViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    MKCoordinateSpan span;
    CLLocationCoordinate2D start;
    
    //create region
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    [self.mapView setRegion:region animated:YES];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    
    
    [CLLocationManager locationServicesEnabled];

    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;

    //Implenting swipe action
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
}

#pragma mark -- Location Logic

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy <5000 && location.horizontalAccuracy < 5000)
        {
            
        [self startReverseGeocode:location];
        [self.locationManager stopUpdatingLocation];
        break;
        

        }
    }
}

- (void)startReverseGeocode: (CLLocation*)location
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [self foundDogParks:placemarks.firstObject];
        
        NSLog(@"%@", placemarks);
    }];
}


- (void)foundDogParks: (CLPlacemark *)placemark
    {
        MKLocalSearchRequest *request = [MKLocalSearchRequest new];
        request.naturalLanguageQuery = @"Dog parks";
        request.region = MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpanMake(5, 5));
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            
            NSArray   *mapitems = response.mapItems;
            MKMapItem *mapitem  = mapitems.firstObject;
            
            foundDogParks = mapitems;
            [self.myTableView reloadData];
            
            CLLocationCoordinate2D min, max;
            min = max = placemark.location.coordinate;
            //Setting annotations
            for (MKMapItem *item in mapitems) {
                MKPointAnnotation *pin = [MKPointAnnotation new];
                pin.coordinate = item.placemark.location.coordinate;
                [self.mapView addAnnotation:pin];

                //Setting a box perimeter for annotations
                min.latitude = MIN(pin.coordinate.latitude, min.latitude);
                max.latitude = MAX(pin.coordinate.latitude, min.latitude);
                min.longitude = MIN(pin.coordinate.longitude, min.longitude);
                max.longitude = MAX(pin.coordinate.longitude, min.longitude);
                
            }
            
            MKCoordinateSpan span = MKCoordinateSpanMake(max.latitude - min.latitude, max.longitude - min.longitude);
            MKCoordinateRegion region = MKCoordinateRegionMake(placemark.location.coordinate, span);
            [self.mapView setRegion:region animated:YES];
            
            
            
            
            NSLog(@"%@", mapitem);
            NSLog(@"%@", address);
        }];
        
    }

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation)
    {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"ic_parks_pressed"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"mySegue" sender:view];
}


#pragma mark -- TableView Logic
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return foundDogParks.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myProtoCell"];
    MKMapItem *parkLocations = foundDogParks[indexPath.row];
    
    
    cell.textLabel.text = parkLocations.name;
    cell.detailTextLabel.text = parkLocations.name;
    
    //Showing Address in subtitle in TableView cell
    cell.detailTextLabel.text = [[parkLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@"\n"];
    return cell;
}



- (PFQuery *)queryForTable
{
    if (!self.userLocation) {
        return nil;
    }

    PFGeoPoint *userGeoPoint = self.userLocation;

    PFQuery *query = [PFQuery queryWithClassName:@"MainInfo"];

    [query whereKey:@"geoPoint" nearGeoPoint:userGeoPoint];

    query.limit = 10;

//    _placesObjects = [query findObjects];

    return query;
}
- (IBAction)searchParks:(id)sender
{
    [self.locationManager startUpdatingLocation];
}



@end
