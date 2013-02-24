//
//  SecondViewController.m
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Charts_Controller.h"
#import "DTG_WeatherStation.h"
#import "Weather.h"
#import <QuartzCore/QuartzCore.h>

@interface Charts_Controller ()
	@property(strong)NSArray *temperatures;
@end

@implementation Charts_Controller

float max_y;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"About";
		self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:0.2];
	[[self view] insertSubview:grey_bg atIndex:1];
	
	MKCoordinateRegion CSC;
    
    // Defines the center point of the map
    CSC.center.latitude = 52.210953;
    CSC.center.longitude = 0.091946;
    
    // Defines the viewable area of the map. Lower numbers zoom in!
    CSC.span.latitudeDelta = .05;
    CSC.span.longitudeDelta = .05;
    [[self mapView] setRegion:CSC animated:YES];
	[[self mapView] setScrollEnabled:NO];
	[[self mapView] setZoomEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
