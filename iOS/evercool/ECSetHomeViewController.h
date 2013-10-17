//
//  ECSetHomeViewController.h
//  evercool
//
//  Created by Nimrod Gutman on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ECSetHomeViewController : UIViewController <CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@property(nonatomic) CLLocationDegrees eclong;
@property(nonatomic) CLLocationDegrees eclat;
@property(nonatomic, strong) MKPointAnnotation *homeLocationAnnotation;
@end
