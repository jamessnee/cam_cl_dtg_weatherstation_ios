//
//  Settings_ControllerViewController.m
//  DTG_Weather
//
//  Created by James Snee on 24/02/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Settings_Controller.h"
#import "AppDelegate.h"
#import "CurrentWeather_Controller.h"
#import <QuartzCore/QuartzCore.h>

@interface Settings_Controller ()
@end

@implementation Settings_Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
		self.tabBarItem.image = [UIImage imageNamed:@"tab_settings.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Get the current poll value & set the label
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger poll_time = [defaults integerForKey:kPOLL_TIME];
	if(poll_time)
		[[self update_time] setText:[NSString stringWithFormat:@"%d",poll_time]];
	else{
		[[self update_time] setText:@"1"];
		poll_time = 1;
	}

	[[self stepper] setValue:(double)poll_time];
	
	//Setup the switch
	int show_sun = [defaults integerForKey:@"SHOW_SUN"];
	if(show_sun == 0)
		[[self sun_switch] setOn:NO];
	else
		[[self sun_switch] setOn:YES];
    
    //Set the stepper background
    [[self stepper] setTintColor:[UIColor whiteColor]];
	
	
	//The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:kGREY_BG_ALPHA];
	[[self view] insertSubview:grey_bg atIndex:1];
	
}

-(IBAction)value_changed:(id)sender{
	UIStepper *stepper = (UIStepper *)sender;	//We're sure that this is the only thing that will call this method.
	double stepper_value = [stepper value];
	[[self update_time] setText:[NSString stringWithFormat:@"%d",(int)stepper_value]];
	
	//Store the new time
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:(int)stepper_value forKey:kPOLL_TIME];
	[defaults synchronize];
}

-(IBAction)switch_changed:(id)sender{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[[self sun_switch] isOn] forKey:kSHOW_SUN];
	
	AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	NSArray *view_cs = [[delegate tabBarController] viewControllers];
	for(UIViewController *vc in view_cs){
		if([vc isKindOfClass:[CurrentWeather_Controller class]]){
			[((CurrentWeather_Controller *)vc) invalidate_weather];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
