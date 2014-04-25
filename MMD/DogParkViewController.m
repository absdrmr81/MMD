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


@interface DogParkViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *foundDogParks;
}

@end

@implementation DogParkViewController
@property CLLocationManager *locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    }


@end
