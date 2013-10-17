//
// Created by guti on 10/17/13.
//
// No bugs for you!
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ECConfiguration : NSObject

+ (ECConfiguration *)instance;

- (CLLocationCoordinate2D)getHomeLocation;
- (void)setHomeLocationTo:(CLLocationCoordinate2D)coordinate2D;

- (BOOL)hasHome;
@end