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
@property(strong)IBOutlet UIImageView *dial_temp;
@property(strong)IBOutlet UIImageView *dial_temp_pin;
@property(strong)IBOutlet UILabel *temp_label;
@property(strong)IBOutlet UIImageView *dial_humid;
@property(strong)IBOutlet UIImageView *dial_humid_pin;
@property(strong)IBOutlet UILabel *humid_label;
@property(strong)IBOutlet UIImageView *dial_pressure;
@property(strong)IBOutlet UIImageView *dial_pressure_pin;
@property(strong)IBOutlet UILabel *pressure_label;
@property(strong)IBOutlet UIImageView *dial_dew;
@property(strong)IBOutlet UIImageView *dial_dew_pin;
@property(strong)IBOutlet UILabel *dew_label;
@property(strong)IBOutlet UIImageView *dial_rain;
@property(strong)IBOutlet UIImageView *dial_rain_pin;
@property(strong)IBOutlet UILabel *rain_label;
@property(strong)IBOutlet UIImageView *dial_wind;
@property(strong)IBOutlet UIImageView *dial_wind_pin;
@property(strong)IBOutlet UILabel *wind_label;
@property(strong)IBOutlet UILabel *wind_dir_label;
@property(strong)IBOutlet UILabel *sun_label;

@property(strong)IBOutlet UIButton *tempChart;
@property(strong)IBOutlet UIButton *humidChart;
@property(strong)IBOutlet UIButton *pressureChart;
@property(strong)IBOutlet UIButton *dewChart;
@property(strong)IBOutlet UIButton *rainChart;
@property(strong)IBOutlet UIButton *windChart;

@property(strong)Weather *current_weather;

-(void)update_weather;

-(IBAction)showChart_selected:(id)sender;

@end
