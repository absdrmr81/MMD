//
//  VetViewController.m
//  MMD
//
//  Created by Marlon Simeus on 4/26/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "VetViewController.h"
#import "SWRevealViewController.h"

@interface VetViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate>
{
    
    CLLocationCoordinate2D coordinate;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSArray *foundVetLocations;


@end

@implementation VetViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //setting background color to Nav bar
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f]}];

    //create span
    MKCoordinateSpan span;
    CLLocationCoordinate2D start;
    
    //create region
    MKCoordinateRegion region;
    region.span = span;
    region.center = start;
    
    //show user within map
    [self.mapView setRegion:region animated:YES];
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    
    
    
    
    
    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;

    //implenting swipe gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate =self;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    //Updates user location
    [self.locationManager startUpdatingLocation];
}

#pragma mark -- Location Logic

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            [self startReverseGeocode:location];
            [self.locationManager stopUpdatingLocation];
            break;
            
           
        }
    }
}

- (void) startReverseGeocode: (CLLocation *) location
{
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
    {
        [self findVetLocations:placemarks.firstObject];
        
        NSLog(@"%@", placemarks);
    }];
}

//Sends request to search for nearby vets
-(void)findVetLocations: (CLPlacemark *)placemark
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"vet";
    request.region = MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpanMake(1, 1));
    
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSArray   *mapitems = response.mapItems;
        MKMapItem *mapitem  = mapitems.firstObject;
        
        //Reloads data in tableview
        _foundVetLocations = mapitems;
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


#pragma mark -- TableView Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _foundVetLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellID"];
    MKMapItem *vetLocations = _foundVetLocations[indexPath.row];
  
    cell.textLabel.text = vetLocations.name;
//    cell.detailTextLabel.text = vetLocations.address;
    cell.detailTextLabel.text = vetLocations.name;//[@"formattedAddressLine"];
    //Showing Address in subtitle in TableView cell
    cell.detailTextLabel.text = [[vetLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@"\n"];
    
    return cell;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}



//Segued into detailview once selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}






@end
