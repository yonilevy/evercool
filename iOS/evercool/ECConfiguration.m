//
// Created by guti on 10/17/13.
//
// No bugs for you!
//


#import "ECConfiguration.h"

static ECConfiguration *_instance = nil;

@implementation ECConfiguration

+ (ECConfiguration *)instance
{
    if (!_instance) {
        _instance = [[ECConfiguration alloc] init];
    }

    return _instance;
}

- (CLLocationCoordinate2D)getHomeLocation
{
    CLLocationCoordinate2D homeLocation;
    homeLocation.longitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"eclong"];
    homeLocation.latitude = [[NSUserDefaults standardUserDefaults] doubleForKey:@"eclat"];

    return homeLocation;
}

- (void)setHomeLocationTo:(CLLocationCoordinate2D)coordinate2D
{
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate2D.longitude forKey:@"eclong"];
    [[NSUserDefaults standardUserDefaults] setDouble:coordinate2D.latitude forKey:@"eclat"];
}

- (BOOL)hasHome {
    return YES;
}
@end