//
//  HistoricalViewController.m
//  DTG_Weather
//
//  Created by James Snee on 25/07/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "Historical_Controller.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
