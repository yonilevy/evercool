//
//  ECViewController.h
//  evercool
//
//  Created by Yoni Levy on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "ECViewController.h"

@interface ECViewController : UIViewController;

@property(nonatomic, strong) CLLocationManager *locationManager;
@end
