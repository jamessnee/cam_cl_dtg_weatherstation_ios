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
#import "PopupChart_ControllerViewController.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface CurrentWeather_Controller ()
	@property long update_timestamp;
@end

@implementation CurrentWeather_Controller
@synthesize dial_temp,dial_temp_pin,temp_label;
@synthesize dial_humid,dial_humid_pin,humid_label;
@synthesize dial_pressure,dial_pressure_pin,pressure_label;
@synthesize dial_dew,dial_dew_pin,dew_label;
@synthesize dial_rain,dial_rain_pin,rain_label;
@synthesize dial_wind,dial_wind_pin,wind_label;
@synthesize wind_dir_label,sun_label;
@synthesize current_weather;
@synthesize update_timestamp;
@synthesize tempChart,humidChart,pressureChart,dewChart,rainChart,windChart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Current Weather";
		self.tabBarItem.image = [UIImage imageNamed:@"first"];
		[self setCurrent_weather:nil];
		[self setUpdate_timestamp:-1];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	[temp_label setText:@""];
	[humid_label setText:@""];
	[pressure_label setText:@""];
	[dew_label setText:@""];
	[rain_label setText:@""];
	[wind_label setText:@""];
	[wind_dir_label setText:@""];
	[sun_label setText:@""];
	
	//The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:0.2];
	[[self view] insertSubview:grey_bg atIndex:1];
	
	/*
	//Rotate the pins
	dial_temp_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	dial_humid_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	dial_pressure_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	dial_dew_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	dial_rain_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	dial_wind_pin.transform = CGAffineTransformMakeRotation(-1.570796327);
	 */
}

-(void)viewDidAppear:(BOOL)animated{
	[self update_weather];
}

-(IBAction)showChart_selected:(id)sender{
	UIButton *caller = (UIButton *)sender;
	PopupChart_ControllerViewController *popup_temp = [[PopupChart_ControllerViewController alloc] initWithNibName:@"PopupChart_ControllerViewController" bundle:nil];
	//Set the chart type
	if(caller==tempChart)
		[popup_temp setChartType:CHART_TEMP];
	else if(caller==humidChart)
		[popup_temp setChartType:CHART_HUMID];
	else if(caller==pressureChart)
		[popup_temp setChartType:CHART_PRESSURE];
	else if(caller==dewChart)
		[popup_temp setChartType:CHART_DEW];
	else if(caller==rainChart)
		[popup_temp setChartType:CHART_RAIN];
	else if(caller==windChart)
		[popup_temp setChartType:CHART_WIND];
	
	[self presentViewController:popup_temp animated:YES completion:nil];
}


-(void)update_weather{
	long curr_time = [NSDate timeIntervalSinceReferenceDate];
	if(update_timestamp==-1||(curr_time-update_timestamp)>30){
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
		dispatch_async(queue, ^{
			DTG_WeatherStation *weather_station = [[DTG_WeatherStation alloc] init];
			Weather *temp_weather = [weather_station get_currentWeather];
			
			if(temp_weather!=nil){
				//Setup all of the text and radians
				NSString *curr_temp = [NSString stringWithFormat:@"%.01fC",[temp_weather temp]];
				NSString *curr_humid = [NSString stringWithFormat:@"%d%%",[temp_weather humidity]];
				NSString *curr_press = [NSString stringWithFormat:@"%.f mBar",[temp_weather pressure]];
				NSString *curr_dew = [NSString stringWithFormat:@"%.1f%%",[temp_weather dew_point]];
				NSString *curr_rain = [NSString stringWithFormat:@"%.1fmm",[temp_weather rain]];
				NSString *curr_wind = [NSString stringWithFormat:@"%.0fkts",[temp_weather wind_speed]];
				NSString *curr_wind_dir = [NSString stringWithFormat:@"Wind direction: %@",[temp_weather wind_direction]];
				NSString *curr_sun = [NSString stringWithFormat:@"Sunshine today: %.1fhrs",[temp_weather sun_hours]];

				/*
				//Calculate the post anim positions
				float total_dial = 270.0f;
				
				//Temperature
				float temp_per = ([temp_weather temp]+10)/50;
				temp_per = temp_per * 100;
				float temp_dial_deg = temp_per*total_dial;
				temp_dial_deg = temp_dial_deg/100;
				temp_dial_deg = temp_dial_deg - 135.0f;
				float temp_dial_rad = degreesToRadians(temp_dial_deg);
				
				//Humidity
				float humid_dial_deg = (float)([temp_weather humidity]*total_dial);
				humid_dial_deg = humid_dial_deg/100;
				humid_dial_deg = humid_dial_deg - 135.0f;
				float humid_dial_rad = degreesToRadians(humid_dial_deg);
				
				//Pressure
				float pres_per = ([temp_weather pressure]-890)/170;
				pres_per = pres_per * 100;
				float pres_dial_deg = pres_per*total_dial;
				pres_dial_deg = pres_dial_deg/100;
				pres_dial_deg = pres_dial_deg-135.0f;
				float pres_dial_rad = degreesToRadians(pres_dial_deg);
				
				//Dew Point
				float dew_per = ([temp_weather dew_point]+5)/22;
				dew_per = dew_per * 100;
				float dew_dial_deg = dew_per*total_dial;
				dew_dial_deg = dew_dial_deg/100;
				dew_dial_deg = dew_dial_deg-135.0f;
				float dew_dial_rad = degreesToRadians(dew_dial_deg);
				
				//Rainfall
				float rain_per = [temp_weather rain]/318;
				rain_per = rain_per * 100;
				float rain_dial_deg = rain_per*total_dial;
				rain_dial_deg = rain_dial_deg-135.0f;
				float rain_dial_rad = degreesToRadians(rain_dial_deg);
				
				//Wind
				float wind_per = [temp_weather wind_speed]/50;
				wind_per = wind_per * 100;
				float wind_dial_deg = wind_per*total_dial;
				wind_dial_deg = wind_dial_deg-135.0f;
				float wind_dial_rad = degreesToRadians(wind_dial_deg);
				 */
				
				dispatch_sync(dispatch_get_main_queue(), ^{
					/*
					//Setup the labels
					current_weather = temp_weather;
					update_timestamp = [NSDate timeIntervalSinceReferenceDate];
					
					[temp_label setText:curr_temp];
					[humid_label setText:curr_humid];
					[pressure_label setText:curr_press];
					[dew_label setText:curr_dew];
					[rain_label setText:curr_rain];
					[wind_label setText:curr_wind];
					[wind_dir_label setText:curr_wind_dir];
					[sun_label setText:curr_sun];
					
					[UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
						dial_temp_pin.transform = CGAffineTransformMakeRotation(temp_dial_rad);
						dial_humid_pin.transform = CGAffineTransformMakeRotation(humid_dial_rad);
						dial_pressure_pin.transform = CGAffineTransformMakeRotation(pres_dial_rad);
						dial_dew_pin.transform = CGAffineTransformMakeRotation(dew_dial_rad);
						dial_rain_pin.transform = CGAffineTransformMakeRotation(rain_dial_rad);
						dial_wind_pin.transform = CGAffineTransformMakeRotation(wind_dial_rad);
					}completion:nil];
					 */
					[temp_label setText:curr_temp];
					[humid_label setText:curr_humid];
					[pressure_label setText:curr_press];
					[dew_label setText:curr_dew];
					[rain_label setText:curr_rain];
					[wind_label setText:curr_wind];
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
