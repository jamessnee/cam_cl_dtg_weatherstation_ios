//
//  PopupChart_ControllerViewController.h
//  DTG_Weather
//
//  Created by James Snee on 02/02/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

#define CHART_TEMP 0
#define CHART_HUMID 1
#define CHART_PRESSURE 2
#define CHART_DEW 3
#define CHART_RAIN 4
#define CHART_WIND 5

@interface PopupChart_ControllerViewController : UIViewController <CPTPlotDataSource>

@property int chartType;
@property(strong)IBOutlet CPTGraphHostingView *hostView;
@property(strong)CPTXYGraph *graph;

-(IBAction)close_selected:(id)sender;

@end
