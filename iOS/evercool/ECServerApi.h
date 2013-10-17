//
// Created by yoni on 10/17/13.
//
// \( ﾟ◡ﾟ)/
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ECServerApi : NSObject
+ (void)turnACOn;
+ (void)turnACOff;
+ (NSString *)getCurrentWeatherWithLat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon;
@end