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
#import "ECConfiguration.h"

@interface ECViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *lonTextField;
@property (weak, nonatomic) IBOutlet UITextField *latTextField;
@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;

@end

static NSString *BASE_URL = @"http://infinite-fortress-1821.herokuapp.com/";

@implementation ECViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    [self setNavigationBarButtons];
}

- (void)updateCurrentWeather
{
    NSString *urlPath = [NSString stringWithFormat:@"current_weather?lat=%@&lon=%@", self.latTextField.text, self.lonTextField.text];
    NSString *currentWeather = [self doGet:[self serverUrl:urlPath]];

    self.currentWeatherLabel.text = [currentWeather stringByAppendingString:@"°"];
    NSLog(urlPath);
    NSLog(currentWeather);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setHomeLocation];
    [self updateCurrentWeather];
}


- (void)setHomeLocation
{
    if ([[ECConfiguration instance] hasHome]) {
        CLLocationCoordinate2D homeLocation = [[ECConfiguration instance] getHomeLocation];
        self.latTextField.text = [NSString stringWithFormat:@"%f", homeLocation.latitude];
        self.lonTextField.text = [NSString stringWithFormat:@"%f", homeLocation.longitude];
    }
}


- (void)setNavigationBarButtons
{
    self.navigationItem.title = @"Evercool";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Set Home"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(setHome)];
}

- (void)setHome
{
    [self performSegueWithIdentifier:@"setHomeSegue" sender:self];
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

- (void)askServerToTurnOn
{
    [self doGet:[self serverUrl:@"turn_on"]];
}

- (void)askServerToTurnOff
{
    [self doGet:[self serverUrl:@"turn_off"]];
}

- (NSString *)doGet:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];


    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)serverUrl:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, path];
}


@end
