//
//  VetViewController.m
//  MMD
//
//  Created by Marlon Simeus on 4/26/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "VetViewController.h"
#import "SWRevealViewController.h"

@interface VetViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKAnnotation, MKMapViewDelegate>
{
    NSArray *foundVetLocations;
    NSString *address;
    CLLocationCoordinate2D coordinate;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation VetViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];//move the map to our location
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:252/255.0f blue:230/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];

    
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
    
    
    
    
    
    
    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;

    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate =self;
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    //Automatically search for Vets in area
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

-(void)findVetLocations: (CLPlacemark *)placemark
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"vet";
    request.region = MKCoordinateRegionMake(placemark.location.coordinate, MKCoordinateSpanMake(1, 1));
    
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSArray   *mapitems = response.mapItems;
        MKMapItem *mapitem  = mapitems.firstObject;
        
        
        foundVetLocations = mapitems;
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
        NSLog(@"%@", address);
        
        
    }];
    
}

#pragma mark -- TableView Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return foundVetLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCellID"];
    MKMapItem *vetLocations = foundVetLocations[indexPath.row];
  
    cell.textLabel.text = vetLocations.name;
//    cell.detailTextLabel.text = vetLocations.address;
    cell.detailTextLabel.text = vetLocations.name;//[@"formattedAddressLine"];
    //Showing Address in subtitle in TableView cell
    cell.detailTextLabel.text = [[vetLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@"\n"];
    
    return cell;
}




//Segued into detailview once selected
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    if (annotation == self.mapView.userLocation)
//    {
//        return nil;
//    }
//    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
////    pin.image = [UIImage imageNamed:@"ic_parks_pressed"];
//    pin.canShowCallout = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
//    return pin;
//}


//-(MKAnnotationView *) mapView:(MKMapView *)mapMKMapView viewForAnnotation: (id<MKAnnotation>)annotation
//{
//    MKPinAnnotationView *MyPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
////    MyPin.pinColor = MKPinAnnotationColorPurple; // <--for coloring purpose
//    
////    UIButton *adverButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
////    [adverButton addTarget:self action:@selector(button:)forControlEvents:UIControlEventTouchUpInside];
//    
//    MyPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////    MyPin.draggable = YES;
////    MyPin.highlighted = YES;
////    MyPin.animatesDrop  = TRUE;
//    MyPin.canShowCallout  = YES;
//    
//    return MyPin;
//}




@end
