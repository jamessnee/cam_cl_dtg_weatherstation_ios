//
//  AppDelegate.m
//  DTG_Weather
//
//  Created by James Snee on 31/01/2013.
//  Copyright (c) 2013 James Snee. All rights reserved.
//

#import "AppDelegate.h"

#import "CurrentWeather_Controller.h"
#import "About_Controller.h"
#import "Settings_Controller.h"
#import "DTG_WeatherStation.h"

@interface AppDelegate ()
@property (strong, nonatomic) CurrentWeather_Controller *current_weather_controller;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Setup the background fetch interval
    double poll_time = -1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    poll_time = [defaults doubleForKey:@"POLL_TIME"];
    poll_time = poll_time * 60;
    if (poll_time != -1)
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:poll_time];
    else
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:300];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self setCurrent_weather_controller:[[CurrentWeather_Controller alloc] initWithNibName:@"CurrentWeather_Controller" bundle:nil]];
	UIViewController *viewController2 = [[Settings_Controller alloc] initWithNibName:@"Settings_Controller" bundle:nil];
	UIViewController *viewController3 = [[About_Controller alloc] initWithNibName:@"About_Controller" bundle:nil];
	self.tabBarController = [[UITabBarController alloc] init];
	self.tabBarController.viewControllers = @[self.current_weather_controller, viewController2, viewController3];
	self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    DTG_WeatherStation *weather_station = [[DTG_WeatherStation alloc] init];
    Weather *temp_weather = [weather_station get_currentWeather];
    [self.current_weather_controller setCurrent_weather:temp_weather];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
