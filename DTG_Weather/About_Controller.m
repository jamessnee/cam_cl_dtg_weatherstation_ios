//Copyright 2015 James Snee
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "About_Controller.h"
#import "DTG_WeatherStation.h"
#import "Weather.h"
#import <QuartzCore/QuartzCore.h>

@interface About_Controller ()
	@property(strong)NSArray *temperatures;
@end

@implementation About_Controller

float max_y;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"About";
		self.tabBarItem.image = [UIImage imageNamed:@"tab_about.png"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self scrollView] addSubview:[self content]];
	[[self scrollView] setContentSize:[[self content] frame].size];
	
	//The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:kGREY_BG_ALPHA];
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
	
	// Place a single pin
	MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
	CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.210953, 0.091946);
	[annotation setCoordinate:coordinate];
	[annotation setTitle:@"Computer Laboratory"]; //You can set the subtitle too
	[annotation setSubtitle:@"University of Cambridge"];
	[self.mapView addAnnotation:annotation];
}

-(IBAction)dtg_site_clicked:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cl.cam.ac.uk/research/dtg/www"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
