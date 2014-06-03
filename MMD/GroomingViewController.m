//
//  PhotoViewController.m
//  MMD
//
//  Created by Drmrboy on 4/23/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "GroomingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>


@interface GroomingViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) NSArray *foundGroomer;
@property (strong, nonatomic) NSString *address;
@property CLLocationManager *locationManager;

@end

@implementation GroomingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f]}];

    
    MKCoordinateSpan span;
    CLLocationCoordinate2D start;
    
    //create region
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    //Pulsing blue locator dot
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

- (void)viewWillAppear:(BOOL)animated
{
    //Automatically search for Groomers in area
    [self.locationManager startUpdatingLocation];
    
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
        [self foundGroomer:placemarks.firstObject];
        
        NSLog(@"%@", placemarks);
    }];
}


- (void)foundGroomer: (CLPlacemark *)placemark
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"groomers";
    request.region = MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpanMake(.7, .8));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
    {
        
        NSArray   *mapitems = response.mapItems;
        MKMapItem *mapitem  = mapitems.firstObject;
        
        _foundGroomer = mapitems;
        [self.myTableView reloadData];
        
        CLLocationCoordinate2D min, max;
        min = max = placemark.location.coordinate;
        
        //Setting annotations
        for (MKMapItem *item in mapitems)
        {
            MKPointAnnotation *pin = [MKPointAnnotation new];
            pin.coordinate = item.placemark.location.coordinate;
            pin.title = item.name;
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
            NSLog(@"%@", _address);
    }];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"ic_grooming_pressed"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showGroomers" sender:view];
}


#pragma mark -- TableView Logic

//setting rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foundGroomer.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    MKMapItem *parkLocations = _foundGroomer[indexPath.row];
    
    
    cell.textLabel.text = parkLocations.name;
    cell.detailTextLabel.text = parkLocations.name;
    
    //Showing Address in subtitle in cell
    cell.detailTextLabel.text = [[parkLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"]
                                 componentsJoinedByString:@"\n"];
    
    return cell;
}


@end
