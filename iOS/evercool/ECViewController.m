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

static NSString *BASE_URL = @"http://infinite-fortress-1821.herokuapp.com/";

@implementation ECViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self displayLocalNotification:@"Entered region!"];
    [self askServerToTurnOn];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self displayLocalNotification:@"Left region ;_;"];
    [self askServerToTurnOff];
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

- (IBAction)onTurnACOn:(id)sender
{
    [self askServerToTurnOn];
}

- (IBAction)onTurnACOff:(id)sender
{
    [self askServerToTurnOff];
}

- (CLCircularRegion *)registerGeoFenceWithLon:(double)lon lat:(double)lat
{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return nil;
    }

    self.locationManager.delegate = self;

    CLLocationDistance RADIUS_IN_METERS = 10.0;
    NSString *HOME_IDENTIFIER = @"home";
    CLCircularRegion *region = [[CLCircularRegion alloc]
            initWithCenter:CLLocationCoordinate2DMake(lat, lon)
                    radius:RADIUS_IN_METERS
                identifier:HOME_IDENTIFIER];
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

- (void)askServerToTurnOn
{
    [self doGet:[self serverUrl:@"turn_on"]];
}

- (void)askServerToTurnOff
{
    [self doGet:[self serverUrl:@"turn_off"]];
}

- (void)doGet:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];


    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
}

- (NSString *)serverUrl:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, path];
}


@end
