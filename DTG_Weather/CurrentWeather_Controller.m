//
//  FirstViewController.m
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "CurrentWeather_Controller.h"
#import "DTG_WeatherStation.h"
#import "Weather.h"
#import <QuartzCore/QuartzCore.h>

@interface CurrentWeather_Controller ()
	@property long update_timestamp;
	@property (strong)NSTimer *timer;
	@property NSInteger poll_time;
@end

@implementation CurrentWeather_Controller
@synthesize background;
@synthesize temp_label;
@synthesize humid_label;
@synthesize pressure_label;
@synthesize dew_label;
@synthesize rain_label;
@synthesize wind_label;
@synthesize current_weather;
@synthesize update_timestamp;
@synthesize update_label;
@synthesize timer;
@synthesize temp_arrow,humid_arrow,pressure_arrow,dew_arrow,wind_arrow,rain_arrow;
@synthesize poll_time;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Current Weather";
		self.tabBarItem.image = [UIImage imageNamed:@"tab_cloud.png"];
		[self setCurrent_weather:nil];
		[self setUpdate_timestamp:-1];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[temp_label setText:@"-"];
	[humid_label setText:@"-"];
	[pressure_label setText:@"-"];
	[dew_label setText:@"-"];
	[rain_label setText:@"-"];
	[wind_label setText:@"-"];
	
	//The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:0.2];
	[[self view] insertSubview:grey_bg atIndex:1];
	
	//Fix the iphone 5 view
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	if (screenSize.height > 480.0f) {
		CGRect update_f = CGRectMake(16, 462, [update_label frame].size.width, [update_label frame].size.height);
		[update_label setFrame:update_f];
	}
	
	//Get the current poll time, set it if it's not there
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger pt = [defaults integerForKey:@"POLL_TIME"];
	if(pt)
		[self setPoll_time:pt];
	else{
		pt = 1;
		[defaults setInteger:pt forKey:@"POLL_TIME"];
		[defaults synchronize];
		[self setPoll_time:pt];
	}
	
	if(![self check_reachability:WS_URL]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"I cannot talk to the weather station. Please check your network settings, or try back later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	[self start_the_timer];
}

-(BOOL)check_reachability:(NSString *)url{
	NSError *error;
	[NSString stringWithContentsOfURL:[NSURL URLWithString:WS_URL] encoding:NSUTF8StringEncoding error:&error];
	if(error) {
		return NO;
	} else {
		return YES;
	}
}

-(void)start_the_timer{
	if(timer){
		[timer invalidate];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:([self poll_time]*60) target:self selector:@selector(update_weather) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated{
	[self update_weather];
	
	//Now check whether the poll time has changed since we last looked
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger pt = [defaults integerForKey:@"POLL_TIME"];
	if(pt!=[self poll_time]){
		//We need to store the new one, invalidate the timer and start it again (with the new time)
		[self setPoll_time:pt];
		[self start_the_timer];
	}
}

-(void)invalidate_weather {
	[self setUpdate_timestamp:-1];
}

-(void)update_weather{
	long curr_time = [NSDate timeIntervalSinceReferenceDate];
	if((update_timestamp==-1||(curr_time-update_timestamp)>30)&&[self check_reachability:WS_URL]){
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
		dispatch_async(queue, ^{
			DTG_WeatherStation *weather_station = [[DTG_WeatherStation alloc] init];
			Weather *temp_weather = [weather_station get_currentWeather];
			
			if(temp_weather!=nil){
				//Setup all of the text and radians
				NSString *curr_temp = [NSString stringWithFormat:@"%.01f℃",[temp_weather temp]];
				NSString *curr_humid = [NSString stringWithFormat:@"%d%%",[temp_weather humidity]];
				NSString *curr_press = [NSString stringWithFormat:@"%.f mBar",[temp_weather pressure]];
				NSString *curr_dew = [NSString stringWithFormat:@"%.1f℃",[temp_weather dew_point]];
				NSString *curr_sun = [NSString stringWithFormat:@"%.1fh",[temp_weather sun_hours]];
				NSString *curr_rain = [NSString stringWithFormat:@"%.1fmm",[temp_weather rain]];
				NSString *curr_wind = [NSString stringWithFormat:@"%.0fkts",[temp_weather wind_speed]];
				
				dispatch_sync(dispatch_get_main_queue(), ^{
					[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
					update_timestamp = [NSDate timeIntervalSinceReferenceDate];
					
					//Find out whether we should show dew point or sun
					NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
					int show_sun = [defaults integerForKey:@"SHOW_SUN"];
					
					[temp_label setText:curr_temp];
					[humid_label setText:curr_humid];
					[pressure_label setText:curr_press];
					
					if(show_sun == 0){
						[[self dew_sun_description] setText:@"Dew Pt"];
						[dew_label setText:curr_dew];
					} else {
						[[self dew_sun_description] setText:@"Sunshine"];
						[dew_label setText:curr_sun];
					}
					
					[rain_label setText:curr_rain];
					[wind_label setText:curr_wind];
					
					//The last update time
					[update_label setText:[temp_weather update_time]];
                    
					//Change the background image based on the current weather
					NSArray *summary_comps = [[temp_weather summary] componentsSeparatedByString:@","];
					if([summary_comps count]<4){
						//Cold, rainy or normal
						if([[summary_comps objectAtIndex:0] rangeOfString:@"rainy"].location!=NSNotFound){
							[[self background] setImage:[UIImage imageNamed:@"rain.png"]];
						}
						else if([[summary_comps objectAtIndex:1] rangeOfString:@"very cold"].location!=NSNotFound ||
								[[summary_comps objectAtIndex:1] rangeOfString:@"freezing cold"].location!=NSNotFound){
							[[self background] setImage:[UIImage imageNamed:@"cold.png"]];
						}
						else{
							[[self background] setImage:[UIImage imageNamed:@"bg_clouds.png"]];
						}
					}else{
						//Sunny
						[[self background] setImage:[UIImage imageNamed:@"bg_about.png"]];
					}
					
					if(current_weather){
						if([current_weather temp]>[temp_weather temp])
							[temp_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
						else if([current_weather temp]<[temp_weather temp])
							[temp_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						
						if([current_weather humidity]>[temp_weather humidity])
							[humid_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
						else if([current_weather humidity]<[temp_weather humidity])
							[humid_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						
						if([current_weather pressure]>[temp_weather pressure])
							[pressure_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
						else if([current_weather pressure]<[temp_weather pressure])
							[pressure_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						
						if(show_sun == 0){
							if([current_weather dew_point]>[temp_weather dew_point])
								[dew_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
							else if([current_weather dew_point]<[temp_weather dew_point])
								[dew_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						} else {
							if([current_weather sun_hours]>[temp_weather sun_hours])
								[dew_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
							else if([current_weather sun_hours]<[temp_weather sun_hours])
								[dew_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						}
						
						if([current_weather rain]>[temp_weather rain])
							[rain_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
						else if([current_weather rain]<[temp_weather rain])
							[rain_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
						
						if([current_weather wind_speed]>[temp_weather wind_speed])
							[wind_arrow setImage:[UIImage imageNamed:@"arrow_down.png"]];
						else if([current_weather wind_speed]<[temp_weather wind_speed])
							[wind_arrow setImage:[UIImage imageNamed:@"arrow_up.png"]];
					}
					current_weather = temp_weather;
				});
			}
		});
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
