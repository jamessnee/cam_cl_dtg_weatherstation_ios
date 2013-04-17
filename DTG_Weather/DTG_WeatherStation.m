//
//  DTG_WeatherStation.m
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "DTG_WeatherStation.h"
#import "Weather.h"

@implementation DTG_WeatherStation

- (Weather *)get_currentWeather{
	NSError *error;
	NSString *weather_string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.cl.cam.ac.uk/research/dtg/weather/current-obs.txt"] encoding:NSUTF8StringEncoding error:&error];
	weather_string = [weather_string stringByReplacingOccurrencesOfString:@" " withString:@""];
	if(error){
		return nil;
	}

	NSArray *weather_comps = [weather_string componentsSeparatedByString:@"\n"];
//	NSLog(@"%@",[weather_comps description]);

	//Check that we actually have some weather data.
	if([weather_comps count]<2)
		return nil;
	
	Weather *weather = [[Weather alloc] init];
	
	//Temperature
	NSString *temp_str = [weather_comps objectAtIndex:2];
	temp_str = [[temp_str componentsSeparatedByString:@":"] objectAtIndex:1];
	temp_str = [temp_str stringByReplacingOccurrencesOfString:@"C" withString:@""];
	[weather setTemp:[temp_str floatValue]];
//	NSLog(@"%f",[weather temp]);
	
	//Pressure
	NSString *pressure_str = [weather_comps objectAtIndex:3];
	pressure_str = [[pressure_str componentsSeparatedByString:@":"] objectAtIndex:1];
	pressure_str = [pressure_str stringByReplacingOccurrencesOfString:@"mBar" withString:@""];
	[weather setPressure:[pressure_str floatValue]];
//	NSLog(@"%f",[weather pressure]);
	
	//Humidity
	NSString *humidity_str = [weather_comps objectAtIndex:4];
	humidity_str = [[humidity_str componentsSeparatedByString:@":"] objectAtIndex:1];
	humidity_str = [humidity_str stringByReplacingOccurrencesOfString:@"%" withString:@""];
	[weather setHumidity:[humidity_str intValue]];
//	NSLog(@"%d",[weather humidity]);
	
	//Dewpoint
	NSString *dew_str = [weather_comps objectAtIndex:5];
	dew_str = [[dew_str componentsSeparatedByString:@":"] objectAtIndex:1];
	dew_str = [dew_str stringByReplacingOccurrencesOfString:@"C" withString:@""];
	[weather setDew_point:[dew_str floatValue]];
//	NSLog(@"%f",[weather dew_point]);
	
	//Wind
	NSString *wind_str = [weather_comps objectAtIndex:6];
	wind_str = [[wind_str componentsSeparatedByString:@":"] objectAtIndex:1];
	NSArray *wind_comps = [wind_str componentsSeparatedByString:@"knotsfromthe"];
	[weather setWind_speed:[[wind_comps objectAtIndex:0] floatValue]];
	[weather setWind_direction:[wind_comps objectAtIndex:1]];
//	NSLog(@"%f, %@",[weather wind_speed],[weather wind_direction]);
	
	//Sunshine
	NSString *sun_str = [weather_comps objectAtIndex:7];
	sun_str = [[sun_str componentsSeparatedByString:@":"] objectAtIndex:1];
	sun_str = [[sun_str componentsSeparatedByString:@"hours"] objectAtIndex:0];
	[weather setSun_hours:[sun_str floatValue]];
//	NSLog(@"%f",[weather sun_hours]);
	
	//Rainfall
	NSString *rain_str = [weather_comps objectAtIndex:8];
	rain_str = [[rain_str componentsSeparatedByString:@":"] objectAtIndex:1];
	rain_str = [[rain_str componentsSeparatedByString:@"mm"] objectAtIndex:0];
	[weather setRain:[rain_str floatValue]];
//	NSLog(@"%f",[weather rain]);
	
	//Summary
	NSString *summary_str = [weather_comps objectAtIndex:10];
	summary_str = [[summary_str componentsSeparatedByString:@":"] objectAtIndex:1];
	[weather setSummary:summary_str];
//	NSLog(@"%@",[weather summary]);
	
	return weather;
}

- (NSArray *)get_weatherFrom:(NSDate *)start_date to:(NSDate *)end_date{	
	return nil;
}

- (NSArray *) get_weatherForToday{
	//NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSError *error;
	NSString *weather_string = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.cl.cam.ac.uk/research/dtg/weather/daily-text.cgi?2013-02-02"] encoding:NSUTF8StringEncoding error:&error];
	if(error){
		return nil;
	}
	
	weather_string = [weather_string stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
	error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
	weather_string = [regex stringByReplacingMatchesInString:weather_string options:0 range:NSMakeRange(0, [weather_string length]) withTemplate:@" "];
	
	NSMutableArray *weathers = [[NSMutableArray alloc] init];
	NSArray *lines = [weather_string componentsSeparatedByString:@"\n"];
	NSString *line;
	for(int i=8;i<[lines count]-1;i++){ //+1 because there's a carrige return at the end
		line = [lines objectAtIndex:i];
		
		Weather *weather = [[Weather alloc] init];
		
		//Parse
		NSArray *line_comps = [line componentsSeparatedByString:@" "];
		
			//Temp
		[weather setTemp:[[line_comps objectAtIndex:1] floatValue]];
			//Humid
		[weather setHumidity:[[line_comps objectAtIndex:2] intValue]];
			//Dew
		[weather setDew_point:[[line_comps objectAtIndex:3] floatValue]];
			//Pressure
		[weather setPressure:[[line_comps objectAtIndex:4] floatValue]];
			//Wind Speed
		[weather setWind_speed:[[line_comps objectAtIndex:5] floatValue]];
			//Wind Dir
		[weather setWind_direction:[line_comps objectAtIndex:6]];
			//Sun
		[weather setSun_hours:[[line_comps objectAtIndex:7] floatValue]];
			//Rain
		[weather setRain:[[line_comps objectAtIndex:8] floatValue]];
		
		[weathers addObject:weather];
	}
	
	return weathers;
}

@end
