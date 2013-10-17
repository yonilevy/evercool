//
//  ECSetHomeViewController.m
//  evercool
//
//  Created by Nimrod Gutman on 10/17/13.
//  Copyright (c) 2013 Evercool. All rights reserved.
//

#import "ECSetHomeViewController.h"
#import <MapKit/MapKit.h>

@interface ECSetHomeViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ECSetHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
