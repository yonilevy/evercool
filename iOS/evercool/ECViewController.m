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

@interface ECViewController () <CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentWeatherLabel;
@property (weak, nonatomic) IBOutlet UITextField *thresholdTextField;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    [self setNavigationBarButtons];
    [self setThresholdTemperature];
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
    NSLog(currentWeather);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateCurrentWeather];
}

- (void)setNavigationBarButtons
{
    self.navigationItem.title = @"Evercool";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Set Home"
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
    if ([self isInForeground]) {
        [self askUserWithCommand:ON_COMMAND];
    } else {
        [self displayLocalNotification:@"Tap to turn the AC on" command:ON_COMMAND];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
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
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (IBAction)onSmalla:(id)sender
{
    CLLocationCoordinate2D coords = [[ECConfiguration instance] getHomeLocation];
    
    CLCircularRegion *region = [self registerGeoFenceWithLon:coords.longitude lat:coords.latitude];
    if (region == nil) {
        [ECUtils displayNotificationAlertWithTitle:@"Notice" message:@"No Geofencing for you!"];
    }
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

@end
