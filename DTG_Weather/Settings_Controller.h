//
//  Settings_ControllerViewController.h
//  DTG_Weather
//
//  Created by James Snee on 24/02/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings_Controller : UIViewController

@property(strong)IBOutlet UILabel *update_time;
@property(strong)IBOutlet UIStepper *stepper;

-(IBAction)value_changed:(id)sender;

@end
