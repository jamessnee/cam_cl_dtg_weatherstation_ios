//
//  Weather.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property float time;
@property float temp;
@property int humidity;
@property float dew_point;
@property float pressure;
@property float wind_speed;
@property(strong) NSString *wind_direction;
@property float sun_hours;
@property float rain;
@property int max_wind_speed;

@end
