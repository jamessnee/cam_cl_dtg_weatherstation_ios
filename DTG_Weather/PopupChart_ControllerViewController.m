//
//  PopupChart_ControllerViewController.m
//  DTG_Weather
//
//  Created by James Snee on 02/02/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "PopupChart_ControllerViewController.h"
#import "DTG_WeatherStation.h"
#import "Weather.h"

@interface PopupChart_ControllerViewController ()
@property(strong)NSArray *data;
@end

@implementation PopupChart_ControllerViewController
@synthesize data,graph,hostView,chartType;

float max_y;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul);
	dispatch_async(queue, ^{
		DTG_WeatherStation *weather_station = [[DTG_WeatherStation alloc] init];
		NSArray *todays_weather = [weather_station get_weatherForToday];
		NSMutableArray *temp_data = [[NSMutableArray alloc] init];
		
		max_y = 0;
		Weather *weather;
		for(int i=0;i<[todays_weather count];i++){
			weather = [todays_weather objectAtIndex:i];
			if(chartType==CHART_TEMP){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather temp])]];
				if([weather temp]>max_y)
					max_y = [weather temp];
			}else if(chartType==CHART_HUMID){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather humidity])]];
				if([weather humidity]>max_y)
					max_y = (float)[weather humidity];
			}else if(chartType==CHART_PRESSURE){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather pressure])]];
				max_y = [weather pressure];
			}else if(chartType==CHART_DEW){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather dew_point])]];
				max_y = [weather dew_point];
			}else if(chartType==CHART_RAIN){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather rain])]];
				max_y = [weather rain];
			}else if(chartType==CHART_WIND){
				[temp_data addObject:[NSValue valueWithCGPoint:CGPointMake(i, [weather wind_speed])]];
				max_y = [weather wind_speed];
			}
		}
		dispatch_sync(dispatch_get_main_queue(), ^{
			max_y = max_y + (max_y/4);
			data = temp_data;
			[self initPlot];
		});
	});
}

-(IBAction)close_selected:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Chart behavior
-(void)initPlot {
	// Create a graph object which we will use to host just one scatter plot.
    CGRect frame = [self.hostView bounds];
    self.graph = [[CPTXYGraph alloc] initWithFrame:frame];
	
    // Add some padding to the graph, with more at the bottom for axis labels.
    self.graph.plotAreaFrame.paddingTop = 0.0f;
    self.graph.plotAreaFrame.paddingRight = 0.0f;
    self.graph.plotAreaFrame.paddingBottom = 50.0f;
    self.graph.plotAreaFrame.paddingLeft = 50.0f;
	
    // Tie the graph we've created with the hosting view.
    self.hostView.hostedGraph = self.graph;
	
    // If you want to use one of the default themes - apply that here.
    //[self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
	
    // Create a line style that we will apply to the axis and data line.
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 1.0f;
	
	CPTMutableLineStyle *lineStyle_data = [CPTMutableLineStyle lineStyle];
    lineStyle_data.lineColor = [CPTColor blueColor];
    lineStyle_data.lineWidth = 1.0f;
	
    // Create a text style that we will use for the axis labels.
    CPTMutableTextStyle *textStyle_x = [CPTMutableTextStyle textStyle];
    textStyle_x.fontName = @"Helvetica";
    textStyle_x.fontSize = 14;
    textStyle_x.color = [CPTColor whiteColor];
	
	CPTMutableTextStyle *textStyle_y = [CPTMutableTextStyle textStyle];
    textStyle_y.fontName = @"Helvetica";
    textStyle_y.fontSize = 13;
    textStyle_y.color = [CPTColor whiteColor];
	
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol plotSymbol];
    plotSymbol.lineStyle = lineStyle;
    plotSymbol.size = CGSizeMake(8.0, 8.0);
	
    // Setup some floats that represent the min/max values on our axis.
    float xAxisMin = 0;
    float xAxisMax = [data count];
    float yAxisMin = 0;
    float yAxisMax = max_y;
	
    // We modify the graph's plot space to setup the axis' min / max values.
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xAxisMin) length:CPTDecimalFromFloat(xAxisMax - xAxisMin)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yAxisMin) length:CPTDecimalFromFloat(yAxisMax - yAxisMin)];
	
    // Modify the graph's axis with a label, line style, etc.
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
	
	axisSet.xAxis.title = @"Time of day";
    axisSet.xAxis.titleTextStyle = textStyle_x;
    axisSet.xAxis.titleOffset = 30.0f;
    axisSet.xAxis.axisLineStyle = lineStyle;
    axisSet.xAxis.majorTickLineStyle = lineStyle;
    axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.labelTextStyle = textStyle_x;
    axisSet.xAxis.labelOffset = 3.0f;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(2.0f);
    axisSet.xAxis.minorTicksPerInterval = 1;
    axisSet.xAxis.minorTickLength = 5.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
	axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	
	if(chartType==CHART_TEMP)
		axisSet.yAxis.title = @"Temperature (deg C)";
	else if(chartType==CHART_HUMID)
		axisSet.yAxis.title = @"Humidity (%)";
	else if(chartType==CHART_PRESSURE)
		axisSet.yAxis.title = @"Pressure (mBar)";
	else if(chartType==CHART_DEW)
		axisSet.yAxis.title = @"Dew Point (%)";
	else if(chartType==CHART_RAIN)
		axisSet.yAxis.title = @"Rain (mm)";
	else if(chartType==CHART_WIND)
		axisSet.yAxis.title = @"Wind Speed (kts)";
    axisSet.yAxis.titleTextStyle = textStyle_y;
    axisSet.yAxis.titleOffset = 35.0f;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.labelTextStyle = textStyle_y;
    axisSet.yAxis.labelOffset = 3.0f;
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(10.0f);
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
	axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	
    // Add a plot to our graph and axis. We give it an identifier so that we
    // could add multiple plots (data lines) to the same graph if necessary.
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self;
    plot.identifier = @"mainplot";
    plot.dataLineStyle = lineStyle_data;
    plot.plotSymbol = plotSymbol;
    [self.graph addPlot:plot];
}

#pragma mark - CPTPlotDataSource
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
	if([plot.identifier isEqual:@"mainplot"]){
		return [data count];
	}
	return 0;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx{
	if ( [plot.identifier isEqual:@"mainplot"] )
    {
        NSValue *value = [self.data objectAtIndex:idx];
        CGPoint point = [value CGPointValue];
		
        // FieldEnum determines if we return an X or Y value.
        if ( fieldEnum == CPTScatterPlotFieldX )
        {
            return [NSNumber numberWithFloat:point.x];
        }
        else    // Y-Axis
        {
            return [NSNumber numberWithFloat:point.y];
        }
    }
	
    return [NSNumber numberWithFloat:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
