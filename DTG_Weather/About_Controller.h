//
//  SecondViewController.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface About_Controller : UIViewController <MKMapViewDelegate>

@property(strong)IBOutlet MKMapView *mapView;
@property(strong)IBOutlet UIScrollView *scrollView;
@property(strong)IBOutlet UIView *content;

-(IBAction)dtg_site_clicked:(id)sender;

@end

