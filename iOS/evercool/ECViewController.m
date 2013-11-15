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
#import "ECServerApi.h"
#import "ECConsts.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface ECViewController () <CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (weak, nonatomic) IBOutlet UITextField *thresholdTextField;
@property (weak, nonatomic) IBOutlet FUIButton *turnOnButton;
@property (weak, nonatomic) IBOutlet FUIButton *turnOffButton;
@property (weak, nonatomic) IBOutlet UISwitch *evercoolSwitch;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    [self turnOnGeofencingIfNeeded];


    [self setNavigationBarButtons];
    [self setThresholdTemperature];

    [self superButton:self.turnOnButton];
    [self superButton:self.turnOffButton];

    self.currentWeatherLabel.font = [UIFont flatFontOfSize:64];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.evercoolSwitch.on = [[ECConfiguration instance] isGeofencing];
}

- (void)turnOnGeofencingIfNeeded
{
    // We need to register for geo-fencing again in case app was killed
    if ([[ECConfiguration instance] isGeofencing]) {
        CLLocationCoordinate2D coords = [[ECConfiguration instance] getHomeLocation];
        if (coords.longitude || coords.longitude) {
            [self registerGeoFenceWithLon:coords.longitude lat:coords.latitude];
        }
    }
}

- (void)superButton:(FUIButton *)button
{
    button.buttonColor = [UIColor cloudsColor];
    button.shadowColor = [UIColor cloudsColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont flatFontOfSize:16];
}

- (void)setThresholdTemperature
{
    self.thresholdTextField.text = [[ECConfiguration instance] getThresholdTemp];
}

- (void)updateCurrentWeather
{
    CLLocationCoordinate2D coords = [[ECConfiguration instance] getHomeLocation];
    NSString *currentWeather = [ECServerApi getCurrentWeatherWithLat:coords.latitude
                                                                 lon:coords.longitude];

    self.currentWeatherLabel.text = [currentWeather stringByAppendingString:@"°"];
    NSLog(@"Weather: %@", currentWeather);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateCurrentWeather];

    NSLog(@"Monitored regions: %@", self.locationManager.monitoredRegions);
}

- (void)setNavigationBarButtons
{
    self.navigationItem.title = @"";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"home"]
                        style:UIBarButtonItemStylePlain
                       target:self
                       action:@selector(setHome)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)setHome
{
    [self performSegueWithIdentifier:@"setHomeSegue" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    NSLog(@"didEnterRegion: %@", region);
    if ([self isInForeground]) {
        [self askUserWithCommand:ON_COMMAND];
    } else {
        [self displayLocalNotification:@"Tap to turn the AC on" command:ON_COMMAND];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"didExitRegion: %@", region);
    if ([self isInForeground]) {
        [self askUserWithCommand:OFF_COMMAND];
    } else {
        [self displayLocalNotification:@"Tap to turn the AC off" command:OFF_COMMAND];
    }
}

- (BOOL)isInForeground
{
    return [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
}

- (void)displayLocalNotification:(NSString *)text command:(NSUInteger)command
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = text;
    notification.userInfo = @{COMMAND_KEY: [NSNumber numberWithInt:command]};
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (IBAction)onTurnACOn:(id)sender
{
    [ECServerApi turnACOn];
}

- (IBAction)onTurnACOff:(id)sender
{
    [ECServerApi turnACOff];
}

- (CLCircularRegion *)registerGeoFenceWithLon:(double)lon lat:(double)lat
{
    NSLog(@"Registering geo-fencing with lon: %f lat: %f", lon, lat);
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        return nil;
    }

    self.locationManager.delegate = self;

    CLCircularRegion *region = [self getRegionForLong:lon lat:lat];
    [self.locationManager startMonitoringForRegion:region];

    return region;
}

- (CLCircularRegion *)getRegionForLong:(double)lon lat:(double)lat {
    CLLocationDistance RADIUS_IN_METERS = 10.0;
    NSString *HOME_IDENTIFIER = @"home";
    CLCircularRegion *region = [[CLCircularRegion alloc]
            initWithCenter:CLLocationCoordinate2DMake(lat, lon)
                    radius:RADIUS_IN_METERS
                identifier:HOME_IDENTIFIER];
    return region;
}

- (void)askUserWithCommand:(NSUInteger)command
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Confirm"];
    if (command == ON_COMMAND) {
        [alert setMessage:@"Would you like to turn the AC on?"];
    } else {
        [alert setMessage:@"Would you like to turn the AC off?"];
    }
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"No"];
    [alert addButtonWithTitle:@"Yes"];
    alert.tag = command;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) return;

    if (alertView.tag == ON_COMMAND) {
        [ECServerApi turnACOn];
    } else {
        [ECServerApi turnACOff];
    }
}

- (IBAction)textDidEndEditing:(id)sender
{
    NSLog(@"Setting threshold temp to %@", self.thresholdTextField.text);

    [[ECConfiguration instance] setThresholdTemperatureTo:self.thresholdTextField.text];
    [self.thresholdTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    UITouch *touch = [[event allTouches] anyObject];
    if ([[touch view] isKindOfClass:[UITextField class]]) {
        return;
    }

    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)evercoolSwitchChanged:(id)sender
{
    CLLocationCoordinate2D coords = [[ECConfiguration instance] getHomeLocation];
    if (self.evercoolSwitch.isOn) {
        CLCircularRegion *region = [self registerGeoFenceWithLon:coords.longitude lat:coords.latitude];
        if (region == nil) {
            [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"No Geofencing for you!"];
        }
        NSLog(@"Turned on geofencing");
    } else {
        [self.locationManager stopMonitoringForRegion:[self getRegionForLong:coords.longitude lat:coords.latitude]];
        NSLog(@"Turned off geofencing");
    }
    [[ECConfiguration instance] setIsGeofencing:self.evercoolSwitch.isOn];
}

@end
