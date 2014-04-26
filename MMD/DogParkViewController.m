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
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property CLLocationManager *locationManager;
@end

@implementation DogParkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
            
        }];
        
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
    cell.detailTextLabel.text = parkLocations.phoneNumber;
    cell.detailTextLabel.text = parkLocations.description;
    
    return cell;
}
- (IBAction)startFindingDogParksButton:(id)sender
{
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    }


@end
