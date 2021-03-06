//
//  SidebarViewController.m
//  X
//
//  Created by Marlon Simeus on 4/19/14.
//  Copyright (c) 2014 Marlon Simeus. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "GroomingViewController.h"
#import "BreedViewController.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:76/255.0f green:76/255.0f blue:66/255.0f alpha:1.0f];
  
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
//    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    //Showing headers of cells in sidebar
    _menuItems = @[@"Title", @"Home", @"Parks", @"Grooming", @"Vets", @"Gallery"];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id) sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    

    
    //Allow tabs to swing back and forth
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
      SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)unwindToMapViewController:(UIStoryboardSegue *)sender
{
    BreedViewController *source;
    source = [sender sourceViewController];
}


@end
