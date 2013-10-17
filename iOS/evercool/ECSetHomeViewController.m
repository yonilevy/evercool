//
//  ECSetHomeViewController.m
//  evercool
//
//  Created by Nimrod Gutman on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import "ECSetHomeViewController.h"
#import "ECConfiguration.h"
#import "ECMultiAddressSelector.h"

@interface ECSetHomeViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL hasHome;
@end

@implementation ECSetHomeViewController

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    MKCoordinateRegion region;
    region.center = [locations[0] coordinate];

    MKCoordinateSpan span;
    span.latitudeDelta  = 0.1;
    span.longitudeDelta = 0.1;
    region.span = span;

    [self.mapView setRegion:region animated:YES];

    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"Failed to Get Your Location"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Set Home";
    self.searchBar.delegate = self;
    self.geocoder = [[CLGeocoder alloc] init];

    [self setMapAndLocation];
    [self loadSavedHome];
    [self addMapTouchRecognizer];

}

- (void)loadSavedHome
{
    if ([[ECConfiguration instance] hasHome]) {
        [self setHomeLocationTo:[[ECConfiguration instance] getHomeLocation]];
    }
}

- (void)setHomeLocationTo:(CLLocationCoordinate2D)homeLocation
{
    NSLog(@"Setting home location to long %f lat %f", homeLocation.longitude, homeLocation.latitude);
    self.homeLocationAnnotation.coordinate = homeLocation;
    if (!self.hasHome) {
        self.hasHome = YES;
        [self.mapView addAnnotation:self.homeLocationAnnotation];
    }
}

- (void)addMapTouchRecognizer
{
    self.lpgr = [[UILongPressGestureRecognizer alloc]
            initWithTarget:self action:@selector(handleLongPress:)];
    self.lpgr.minimumPressDuration = 1.0;
    [self.mapView addGestureRecognizer:self.lpgr];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint
                                                      toCoordinateFromView:self.mapView];

    NSLog(@"Setting new home to %f %f", touchMapCoordinate.latitude, touchMapCoordinate.longitude);

    [[ECConfiguration instance] setHomeLocationTo:touchMapCoordinate];

    [self setHomeLocationTo:touchMapCoordinate];
}

- (void)setMapAndLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.homeLocationAnnotation = [[MKPointAnnotation alloc] init];
    [self.locationManager startUpdatingLocation];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];

    [self.geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Got response %@", placemarks);

        self.addressSelector = [[ECMultiAddressSelector alloc] init];
        [self.addressSelector showAlertForAddresses:placemarks inView:self.view withDelegate:self];

    }];
}

- (void)setAddressTo:(CLPlacemark *)placemark
{
    [[ECConfiguration instance] setHomeLocationTo:placemark.location.coordinate];
    [self setHomeLocationTo:placemark.location.coordinate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar) {
        [self.searchBar resignFirstResponder];
    }

}

@end
