//
//  SecondViewController.h
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface Charts_Controller : UIViewController <CPTPlotDataSource>

@property(strong)IBOutlet CPTGraphHostingView *hostView;
@property(strong)CPTXYGraph *graph;

-(void)initPlot;


@end

