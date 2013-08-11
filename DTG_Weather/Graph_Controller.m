//
//  Graph_Controller.m
//  DTG_Weather
//
//  Created by James Snee on 07/08/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Graph_Controller.h"

@interface Graph_Controller ()

@end

@implementation Graph_Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSURL *url = [NSURL URLWithString:@"http://www.cl.cam.ac.uk/~jas250/weather/TestGraph.html"];
	NSString *absolute_url = [url absoluteString];
	NSString *absolute_w_query = [absolute_url stringByAppendingString:[self weather_url]];
	absolute_w_query = [absolute_w_query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"URL: %@",absolute_w_query);
	NSURL *final_url = [NSURL URLWithString:absolute_w_query];
	
	[[self web] loadRequest:[NSURLRequest requestWithURL:final_url]];
}

-(IBAction)close_graph:(id)sender{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
