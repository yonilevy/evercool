//
//  ECViewController.m
//  evercool
//
//  Created by Yoni Levy on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ECViewController.h"
#import "ECUtils.h"

@interface ECViewController ()
@property (weak, nonatomic) IBOutlet UITextField *lonTextField;
@property (weak, nonatomic) IBOutlet UITextField *latTextField;

@end

@implementation ECViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"Your'e in the zone BROTHA"];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"Bye ;_;"];
}

- (IBAction)onSmalla:(id)sender
{
    double lon = [self.lonTextField.text doubleValue];
    double lat = [self.latTextField.text doubleValue];
    BOOL didRegister = [self registerGeoFenceWithLon:lon lat:lat];
    if (didRegister) {
        [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"Geofencing activated"];
    } else {
        [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"No Geofencing for you!"];
    }
}

- (BOOL)registerGeoFenceWithLon:(double)lon lat:(double)lat 
{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return NO;
    }


    self.locationManager.delegate = self;

    CLLocationDistance RADIUS_IN_METERS = 10.0;
    NSString *HOME_IDENTIFIER = @"home";
    CLLocationCoordinate2D center;
    center.latitude = lon;
    center.latitude = lat;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:RADIUS_IN_METERS identifier:HOME_IDENTIFIER];
    [self.locationManager startMonitoringForRegion:region];

    return YES;
}

@end
