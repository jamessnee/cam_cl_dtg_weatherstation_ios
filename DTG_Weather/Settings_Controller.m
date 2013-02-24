//
//  Settings_ControllerViewController.m
//  DTG_Weather
//
//  Created by James Snee on 24/02/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Settings_Controller.h"
#import <QuartzCore/QuartzCore.h>

@interface Settings_Controller ()

@end

@implementation Settings_Controller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
		self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
