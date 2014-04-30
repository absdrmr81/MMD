//
//  ParkDetailTableViewController.m
//  MMD
//
//  Created by Drmrboy on 4/30/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "ParkDetailTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DogParkViewController.h"

@interface ParkDetailTableViewController ()

@property (strong, nonatomic) NSArray *foundDogParks;
@property (strong, nonatomic) NSString *address;

@end

@implementation ParkDetailTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parkCellID"];
    MKMapItem *parkLocations =  self.foundDogParks[indexPath.row];
    
    
    cell.textLabel.text = parkLocations.name;
    cell.detailTextLabel.text = parkLocations.name;
    
    //Showing Address in subtitle in TableView cell
    cell.detailTextLabel.text = [[parkLocations.placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@"\n"];
    
    
    //    cell.detailTextLabel.text = parkLocations.description;
    
    
    return cell;
}


@end
