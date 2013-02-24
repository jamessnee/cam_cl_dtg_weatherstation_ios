//
//  FirstViewController.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Weather;

@interface CurrentWeather_Controller : UIViewController

//UI
@property(strong)IBOutlet UILabel *temp_label;
@property(strong)IBOutlet UILabel *humid_label;
@property(strong)IBOutlet UILabel *pressure_label;
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

-(void)update_weather;

@end
