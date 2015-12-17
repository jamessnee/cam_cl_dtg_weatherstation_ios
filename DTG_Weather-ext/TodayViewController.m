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

#import "TodayViewController.h"
@import DTG_Weather_Connection;
#import <NotificationCenter/NotificationCenter.h>

#define kWS_LAST_UPDATE_KEY @"DTG_WS_LAST_UPDATE_KEY"
#define kWS_CACHED_TEMP_KEY @"WS_CACHED_TEMP_KEY"
#define kWS_CACHED_WIND_KEY @"WS_CACHED_WIND_KEY"

@interface TodayViewController () <NCWidgetProviding>
@property (strong) DTG_WeatherStation *wStation;
@end

@implementation TodayViewController

- (void)updateWeatherViewWithTemp:(float)temp andWind:(float)wind {
    [self.temp setText:[NSString stringWithFormat:@"Temp: %.01f℃", temp]];
    [self.wind setText:[NSString stringWithFormat:@"Wind: %.0fkts", wind]];
}

- (void)updateWeather {
    if (!self.wStation) {
        self.wStation = [DTG_WeatherStation new];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
    dispatch_async(queue, ^{
        Weather *currWeather = [self.wStation get_currentWeather];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateWeatherViewWithTemp:currWeather.temp andWind:currWeather.wind_speed];

            // Update caches
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@([NSDate timeIntervalSinceReferenceDate]) forKey:kWS_LAST_UPDATE_KEY];
            [defaults setObject:@(currWeather.temp) forKey:kWS_CACHED_TEMP_KEY];
            [defaults setObject:@(currWeather.wind_speed) forKey:kWS_CACHED_WIND_KEY];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(0, 35);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *wind = (NSNumber *)[defaults objectForKey:kWS_CACHED_WIND_KEY];
    NSNumber *temp = (NSNumber *)[defaults objectForKey:kWS_CACHED_TEMP_KEY];
    NSNumber *oTs = (NSNumber *)[defaults objectForKey:kWS_LAST_UPDATE_KEY];
    long cTs = [NSDate timeIntervalSinceReferenceDate];
    if (wind == nil || temp == nil || (cTs - [oTs longValue]) > 60) {
        [self updateWeather];
    } else {
        [self updateWeatherViewWithTemp:[temp floatValue] andWind:[wind floatValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    long cTs = [NSDate timeIntervalSinceReferenceDate];
    NSNumber *oTs = (NSNumber *)[defaults objectForKey:kWS_LAST_UPDATE_KEY];
    
    if (oTs == nil || (cTs - [oTs longValue]) > 60) {
        [self updateWeather];
        completionHandler(NCUpdateResultNewData);
    } else {
        completionHandler(NCUpdateResultNoData);
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 10.0;
    return margins;
}

@end
