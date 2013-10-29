//
// Created by guti on 10/17/13.
//
// No bugs for you!
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

static NSString *const IS_GEOFENCING_KEY = @"isGeofencing";

@interface ECConfiguration : NSObject

+ (ECConfiguration *)instance;

- (CLLocationCoordinate2D)getHomeLocation;
- (void)setHomeLocationTo:(CLLocationCoordinate2D)coordinate2D;

- (BOOL)hasHome;

- (NSString *)getThresholdTemp;

- (void)setThresholdTemperatureTo:(NSString *)text;

- (void)setIsGeofencing:(BOOL)isGeofencing;

- (BOOL)isGeofencing;
@end