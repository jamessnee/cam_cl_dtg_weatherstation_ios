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

#import <UIKit/UIKit.h>

@class Weather;

@interface CurrentWeather_Controller : UIViewController

//UI
@property(strong)IBOutlet UIImageView *background;
@property(strong)IBOutlet UILabel *temp_label;
@property(strong)IBOutlet UILabel *humid_label;
@property(strong)IBOutlet UILabel *pressure_label;
@property(strong)IBOutlet UILabel *dew_sun_description;
@property(strong)IBOutlet UILabel *dew_label;
@property(strong)IBOutlet UILabel *rain_label;
@property(strong)IBOutlet UILabel *wind_label;
@property(strong)IBOutlet UILabel *update_label;
@property(strong)IBOutlet UIImageView *temp_arrow;
@property(strong)IBOutlet UIImageView *humid_arrow;
@property(strong)IBOutlet UIImageView *pressure_arrow;
@property(strong)IBOutlet UIImageView *dew_arrow;
@property(strong)IBOutlet UIImageView *rain_arrow;
@property(strong)IBOutlet UIImageView *wind_arrow;

@property(strong)Weather *current_weather;

-(void)invalidate_weather;
-(void)update_weather;
-(BOOL)check_reachability:(NSString *)url;
-(void)start_the_timer;

@end
