//
//  WeatherStation_Connection.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weather;

@protocol WeatherStation_Connection <NSObject>

- (Weather *) get_currentWeather;
- (NSArray *) get_weatherFrom:(NSDate *)start_date to:(NSDate *)end_date;
- (NSArray *) get_weatherForToday;

@end
