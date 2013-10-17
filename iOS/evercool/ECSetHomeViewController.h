//
//  ECSetHomeViewController.h
//  evercool
//
//  Created by Nimrod Gutman on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class ECMultiAddressSelector;

@interface ECSetHomeViewController : UIViewController <CLLocationManagerDelegate, UISearchBarDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) UILongPressGestureRecognizer *lpgr;
@property(nonatomic, strong) MKPointAnnotation *homeLocationAnnotation;
@property(nonatomic, strong) CLGeocoder *geocoder;
@property(nonatomic, strong) ECMultiAddressSelector *addressSelector;

- (void)setAddressTo:(id)o;
@end
