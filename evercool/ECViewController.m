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

@interface ECViewController () <CLLocationManagerDelegate>
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
    [self displayLocalNotification:@"Entered region!"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self displayLocalNotification:@"Left region ;_;"];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:2];
}

- (void)displayLocalNotification:(NSString *)text
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    notification.alertBody = text;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (IBAction)onSmalla:(id)sender
{
    double lon = [self.lonTextField.text doubleValue];
    double lat = [self.latTextField.text doubleValue];
    CLCircularRegion *region = [self registerGeoFenceWithLon:lon lat:lat];
    if (region == nil) {
        [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"No Geofencing for you!"];
    } else {
        [self.locationManager requestStateForRegion:region];
    }
}

- (CLCircularRegion *)registerGeoFenceWithLon:(double)lon lat:(double)lat
{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return nil;
    }

    self.locationManager.delegate = self;

    CLLocationDistance RADIUS_IN_METERS = 10.0;
    NSString *HOME_IDENTIFIER = @"home";
    CLLocationCoordinate2D center;
    center.latitude = lon;
    center.latitude = lat;
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:RADIUS_IN_METERS identifier:HOME_IDENTIFIER];
    [self.locationManager startMonitoringForRegion:region];

    return region;
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    [ECUtils displayNotificationAlertWithTitle:@"Notice"
                                       message:[NSString stringWithFormat:@"region state: %d!", state]];
}


@end
