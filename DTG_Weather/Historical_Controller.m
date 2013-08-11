//
//  HistoricalViewController.m
//  DTG_Weather
//
//  Created by James Snee on 25/07/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Historical_Controller.h"
#import "Graph_Controller.h"
#import "FlatUIKit.h"
#import "DTG_WeatherStation.h"

@interface Historical_Controller ()

@end

@implementation Historical_Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Historical";
//		self.tabBarItem.image = [UIImage imageNamed:@"tab_settings.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setup_ui];
}

-(void)setup_ui{
	// The gray background
	CGRect main_frame = [[UIScreen mainScreen] bounds];
	UIView *grey_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, main_frame.size.width, main_frame.size.height)];
	[grey_bg setBackgroundColor:[UIColor blackColor]];
	[grey_bg setAlpha:0.2];
	[[self view] insertSubview:grey_bg atIndex:1];
	
	// Setup the switches
	[self setFlat_type_line:[[FUISwitch alloc] initWithFrame:[[self type_line] frame]]];
	[self setFlat_type_point:[[FUISwitch alloc] initWithFrame:[[self type_pont] frame]]];
	[self setFlat_type_other:[[FUISwitch alloc] initWithFrame:[[self type_other] frame]]];
	
	NSArray *flat_switches = @[[self flat_type_line], [self flat_type_point], [self flat_type_other]];
	for (int i=0; i<[flat_switches count]; i++){
		((FUISwitch *)[flat_switches objectAtIndex:i]).onColor = [UIColor turquoiseColor];
		((FUISwitch *)[flat_switches objectAtIndex:i]).offColor = [UIColor cloudsColor];
		((FUISwitch *)[flat_switches objectAtIndex:i]).onBackgroundColor = [UIColor midnightBlueColor];
		((FUISwitch *)[flat_switches objectAtIndex:i]).offBackgroundColor = [UIColor midnightBlueColor];
		((FUISwitch *)[flat_switches objectAtIndex:i]).highlightedColor = [UIColor silverColor];
		[((FUISwitch *)[flat_switches objectAtIndex:i]) addTarget:self action:@selector(chart_val_changed:) forControlEvents:UIControlEventValueChanged];
		[[self view] addSubview:((FUISwitch *)[flat_switches objectAtIndex:i])];
	}
	// Make sure only one switch is on
	[[self flat_type_line] setOn:YES];
	[[self flat_type_point] setOn:NO];
	[[self flat_type_other] setOn:NO];
	
	// Setup the buttons
	NSArray *flat_btns = @[[self temp_gr], [self humid_gr], [self dewpt_gr], [self press_gr], [self windsp_gr], [self sunhrs_gr], [self rain_gr]];
	for (FUIButton *btn in flat_btns){
		btn.buttonColor = [UIColor turquoiseColor];
		btn.shadowColor = [UIColor greenSeaColor];
		btn.shadowHeight = 3.0f;
		btn.cornerRadius = 6.0f;
		[btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
	}
	
}

-(IBAction)show_picker:(id)sender{
	UIButton *btn = (UIButton *)sender;
	NSString *title = [[btn titleLabel] text];
	
	NSString *picker_title = @"";
	if ([title isEqualToString:@"From"])
		picker_title = @"Data from:";
	else
		picker_title = @"Data to:";
	
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:picker_title
													  delegate:self
											 cancelButtonTitle:@"Done"
										destructiveButtonTitle:nil
											 otherButtonTitles:nil];
	
    // Add the picker
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDate;
	[pickerView addTarget:self action:@selector(date_selection_finished:) forControlEvents:UIControlEventValueChanged];
	if ([title isEqualToString:@"From"])
		[pickerView setTag:0];
	else
		[pickerView setTag:1];
	
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    [menu setBounds:CGRectMake(0,0,320, 500)];
	[menu sendSubviewToBack:pickerView];
	
    CGRect pickerRect = pickerView.bounds;
    pickerRect.origin.y = -100;
    pickerView.bounds = pickerRect;
}

-(void)date_selection_finished:(id)sender{
	UIDatePicker *picker = (UIDatePicker *)sender;
	
	// Store it
	if ([picker tag] == 0) // From
		[self setDate_1:[picker date]];
	else
		[self setDate_2:[picker date]];
}

-(IBAction)chart_val_changed:(id)sender{
	FUISwitch *called = (FUISwitch *)sender;
	NSArray *all_switches = @[[self flat_type_line],[self flat_type_point],[self flat_type_other]];
	
	// Make sure the other switches behave
	if ([called isOn]){
		// Switch everything else off
		for (FUISwitch *curr_sw in all_switches){
			if (curr_sw != called)
				[curr_sw setOn:NO];
		}
	} else {
		//Switch one of the others on
		if (called != [self flat_type_line])
			[[self flat_type_line] setOn:YES];
		else
			[[self flat_type_point] setOn:YES];
	}
}

-(IBAction)show_graph:(id)sender{
	// Construct the url the javascript needs to parse
		// Date
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd"];
	
		// Type
	NSString *type = @"";
	if ([[self flat_type_line] isOn])
		type = @"line";
	else if ([[self flat_type_point] isOn])
		type = @"point";
	else if ([[self flat_type_other] isOn])
		type = @"other";
	
		// Value
	FUIButton *caller = (FUIButton *)sender;
	if (caller == [self temp_gr])
		[self setWeather_val:@"temp"];
	else if (caller == [self humid_gr])
		[self setWeather_val:@"humid"];
	else if (caller == [self dewpt_gr])
		[self setWeather_val:@"dewpt"];
	else if (caller == [self press_gr])
		[self setWeather_val:@"press"];
	else if (caller == [self windsp_gr])
		[self setWeather_val:@"wind"];
	else if (caller == [self sunhrs_gr])
		[self setWeather_val:@"sun"];
	else if (caller == [self rain_gr])
		[self setWeather_val:@"rain"];
	
	// Get the weather
	DTG_WeatherStation *ws = [[DTG_WeatherStation alloc] init];
	
	NSArray *weather = [ws get_weatherForDate:[df stringFromDate:[self date_1]] andType:[self weather_val]];
	NSMutableString *x = [[NSMutableString alloc] init];
	NSMutableString *y = [[NSMutableString alloc] init];
	NSArray *x_arr = [weather objectAtIndex:0];
	NSArray *y_arr = [weather objectAtIndex:1];
	for (int i=0; i<[[weather objectAtIndex:0] count]; i++){
		if (!(i==[x_arr count]-1)){
			[x appendFormat:@"%@,",[x_arr objectAtIndex:i]];
			[y appendFormat:@"%@,",[y_arr objectAtIndex:i]];
		} else {
			[x appendFormat:@"%@",[x_arr objectAtIndex:i]];
			[y appendFormat:@"%@",[y_arr objectAtIndex:i]];
		}
	}
	
	NSString *url_comps = [NSString stringWithFormat:@"?date=%@&type=%@&val=%@&x=%@&y=%@",[df stringFromDate:[self date_1]],
																						type,
																						[self weather_val],
																						x,
																						y];
	
	Graph_Controller *graph_controller = [[Graph_Controller alloc] initWithNibName:@"Graph_Controller" bundle:nil];
	[graph_controller setWeather_url:url_comps];
	[self presentViewController:graph_controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
