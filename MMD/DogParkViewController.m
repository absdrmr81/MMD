//
//  DogParkViewController.m
//  MMD
//
//  Created by Marlon Simeus on 4/25/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "DogParkViewController.h"
#import "SWRevealViewController.h"

typedef void (^MyCompletion)(NSArray* objects, NSError* error);

@interface DogParkViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
{
        MKMapView *mapView;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PFGeoPoint *userLocation;
@property (strong, nonatomic) NSArray *tempUsers;
@property (strong, nonatomic) NSArray *foundDogParks;
@property (strong, nonatomic) NSString *address;
@property CLLocationManager *locationManager;

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

    //Implementing swipe gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    
    [self getUsersFromParse];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Automatically search for Dog Parks in area w/o button pressed
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
            
            _foundDogParks = mapitems;
            [self.myTableView reloadData];
            
            CLLocationCoordinate2D min, max;
            min = max = placemark.location.coordinate;
            
            //Setting annotations
            for (MKMapItem *item in mapitems) {
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

//Getting users from Parse
-(void)getUsersFromParse
{
    [self getUserFromParse:^(NSArray *objects, NSError *error)
    {
        __weak DogParkViewController* dvc = self;
        _tempUsers = objects;
        
    }];
    
}



-(void)getUserFromParse:(MyCompletion)completion
{
    
    //create a query for user in Parse
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId ]]; //do not get the current user
    [query includeKey:@"location"];
    
    //execute the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completion(objects,error);
    }];
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"showDogPark" sender:view];
}


#pragma mark -- TableView Logic
    
//Dog Parks showing up in cells
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foundDogParks.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myProtoCell"];
    MKMapItem *parkLocations = _foundDogParks[indexPath.row];
    
    
    cell.textLabel.text = parkLocations.name;
    cell.detailTextLabel.text = parkLocations.name;
    
    //Showing Address in subtitle in TableView cell
    cell.detailTextLabel.text = [[parkLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"]
                                                                            componentsJoinedByString:@"\n"];
    return cell;
}


@end
