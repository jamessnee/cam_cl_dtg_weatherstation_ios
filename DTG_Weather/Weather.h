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

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property float time;
@property (strong) NSString *update_time;
@property float temp;
@property int humidity;
@property float dew_point;
@property float pressure;
@property float wind_speed;
@property(strong) NSString *wind_direction;
@property float sun_hours;
@property float rain;
@property int max_wind_speed;
@property (strong) NSString *summary;

@end
