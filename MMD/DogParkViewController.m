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
#import "SWRevealViewController.h"


@interface DogParkViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *foundDogParks;
    NSString *address;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationManager *locationManager;
@end

@implementation DogParkViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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


- (void)foundDogParks: (CLPlacemark *)placemarks
    {
        MKLocalSearchRequest *request = [MKLocalSearchRequest new];
        request.naturalLanguageQuery = @"Dog parks";
        request.region = MKCoordinateRegionMake(placemarks.location.coordinate, MKCoordinateSpanMake(1, 1));
        
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
            
            NSArray   *mapitems = response.mapItems;
            MKMapItem *mapitem  = mapitems.firstObject;
            
            foundDogParks = mapitems;
            [self.myTableView reloadData];
            
            NSLog(@"%@", mapitem);
            NSLog(@"%@", address);
        }];
        
    }

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"ic_geo_dog"];
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
    
    
//    cell.detailTextLabel.text = parkLocations.description;

    
    return cell;
}
- (IBAction)startFindingDogParksButton:(id)sender
{
    [self.locationManager startUpdatingLocation];
}



@end
