//
//  Graph_Controller.h
//  DTG_Weather
//
//  Created by James Snee on 07/08/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Graph_Controller : UIViewController <UIWebViewDelegate>

@property(strong)NSString *weather_url;
@property(strong)IBOutlet UIWebView *web;

-(IBAction)close_graph:(id)sender;

@end
