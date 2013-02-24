//
//  SecondViewController.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import <MapKit/MapKit.h>

@interface Charts_Controller : UIViewController <MKMapViewDelegate>

@property(strong)IBOutlet MKMapView *mapView;

@end

