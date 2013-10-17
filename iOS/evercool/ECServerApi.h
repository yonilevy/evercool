//
// Created by yoni on 10/17/13.
//
// \( ﾟ◡ﾟ)/
//


#import <Foundation/Foundation.h>


@interface ECServerApi : NSObject
+ (void)turnACOn;
+ (void)turnACOff;
+ (NSString *)getCurrentWeatherWithLat:(NSString *)lat lon:(NSString *)lon;
@end