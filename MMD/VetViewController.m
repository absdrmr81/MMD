//
//  VetViewController.m
//  MMD
//
//  Created by Marlon Simeus on 4/26/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "VetViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SWRevealViewController.h"





@interface VetViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, MKAnnotation>
{
    NSArray *foundVetLocations;
    NSString *address;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationManager *locationManager;

@end

@implementation VetViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
    
    
    //Add UIBarButton button to Navigation bar programatically
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_nav_std"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    //Setting it to left-side of Navi bar
    self.navigationItem.leftBarButtonItem = flipButton;

    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate =self;
    
   
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
            
//            
//            MKCoordinateRegion region;
//            region.center = location;
//            
//            //Set Zoom level using Span
//            MKCoordinateSpan span;
//            span.latitudeDelta = 0.015;
//            span.longitudeDelta = 0.015;
//            region.span = span;
//            // Set the region here... but I want this to be a dynamic size
//            // Obviously this should be set after I've added my annotations
//            [mapView setRegion:region animated:YES];
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

-(void)findVetLocations: (CLPlacemark *)placemarks
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery = @"vet";
    request.region = MKCoordinateRegionMake(placemarks.location.coordinate, MKCoordinateSpanMake(1, 1));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        NSArray   *mapitems = response.mapItems;
        MKMapItem *mapitem  = mapitems.firstObject;
        
        
        foundVetLocations = mapitems;
        [self.myTableView reloadData];
        
        
        
        
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

//Button search for Vets in current location
- (IBAction)startFindingVetButton:(id)sender
{
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(MKAnnotationView *) mapView:(MKMapView *)mapMKMapView viewForAnnotation:       (id<MKAnnotation>)annotation
{
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation       reuseIdentifier:@"myCellID"];
    MyPin.pinColor = MKPinAnnotationColorPurple; // <--for coloring purpose
    
    UIButton *adverButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [adverButton addTarget:self action:@selector(button:)forControlEvents:UIControlEventTouchUpInside];
    
    MyPin.rightCalloutAccessoryView = adverButton;
    MyPin.draggable = YES;
    MyPin.highlighted = YES;
    MyPin.animatesDrop  = TRUE;
    MyPin.canShowCallout  = YES;
    
    return MyPin;
}



-(void)button:(id)sender
{
    //add your nextView you want to open here
}


@end
