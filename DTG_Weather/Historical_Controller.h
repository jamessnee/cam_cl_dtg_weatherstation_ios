//
//  HistoricalViewController.h
//  DTG_Weather
//
//  Created by James Snee on 25/07/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FUISwitch, FUIButton;
@interface Historical_Controller : UIViewController <UIActionSheetDelegate>

// Ivars
@property(strong)NSDate *date_1;
@property(strong)NSDate *date_2;
@property(strong)NSString *weather_val;

// UI
@property(strong)IBOutlet UISwitch *type_line;
@property(strong)IBOutlet UISwitch *type_pont;
@property(strong)IBOutlet UISwitch *type_other;

@property(strong)IBOutlet FUIButton *temp_gr;
@property(strong)IBOutlet FUIButton *humid_gr;
@property(strong)IBOutlet FUIButton *dewpt_gr;
@property(strong)IBOutlet FUIButton *press_gr;
@property(strong)IBOutlet FUIButton *windsp_gr;
@property(strong)IBOutlet FUIButton *sunhrs_gr;
@property(strong)IBOutlet FUIButton *rain_gr;

// Flat components
@property(strong)FUISwitch *flat_type_line;
@property(strong)FUISwitch *flat_type_point;
@property(strong)FUISwitch *flat_type_other;

-(void)setup_ui;

// Event handlers
-(void)date_selection_finished:(id)sender;
-(IBAction)show_picker:(id)sender;
-(IBAction)chart_val_changed:(id)sender;
-(IBAction)show_graph:(id)sender;

@end
