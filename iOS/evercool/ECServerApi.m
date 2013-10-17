//
// Created by yoni on 10/17/13.
//
// \( ﾟ◡ﾟ)/
//


#import "ECServerApi.h"

#import <MapKit/MapKit.h>

@implementation ECServerApi

static NSString *BASE_URL = @"http://infinite-fortress-1821.herokuapp.com/";

+ (void)turnACOn
{
    [ECServerApi doGet:[ECServerApi serverUrl:@"turn_on"]];
}

+ (void)turnACOff
{
    [ECServerApi doGet:[ECServerApi serverUrl:@"turn_off"]];
}

+ (NSString *)getCurrentWeatherWithLat:(CLLocationDegrees)lat lon:(CLLocationDegrees)lon
{
    NSString *urlPath = [NSString stringWithFormat:@"current_weather?lat=%f&lon=%f", lat, lon];
    return [ECServerApi doGet:[ECServerApi serverUrl:urlPath]];
}

+ (NSString *)doGet:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];


    NSURLResponse* response = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)serverUrl:(NSString *)path
{
    return [NSString stringWithFormat:@"%@%@", BASE_URL, path];
}

@end