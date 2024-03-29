//
//  GraphCalculatorAppDelegate.m
//  GraphCalculator
//
//  Created by Jinwoo Baek on 9/15/11.
//  Copyright 2011 Rose-Hulman Institute of Technology. All rights reserved.
//

#import "GraphCalculatorAppDelegate.h"

@implementation GraphCalculatorAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	
	CalculatorViewController *calculatorView = [[CalculatorViewController alloc] init];
	calculatorView.graphCalculatorViewController = [[GraphCalculatorViewController alloc] init];
	
	calculatorView.title = @"Calculator";
	calculatorView.graphCalculatorViewController.title = @"Graph";
	
	calculatorView.windowsSizeRetrieverDelegate = self;
	calculatorView.graphCalculatorViewController.windowsSizeRetrieverDelegate = self;
	
	UINavigationController *navigation = [[UINavigationController alloc] init];
	[navigation pushViewController:calculatorView animated:NO];
	[calculatorView release];
	
	if (self.window.bounds.size.height > 500)
	{
		UISplitViewController *splitView = [[UISplitViewController alloc] init];
		UINavigationController *rightView = [[UINavigationController alloc] init];
		splitView.delegate = calculatorView.graphCalculatorViewController;
		[rightView pushViewController:calculatorView.graphCalculatorViewController animated:NO];
		splitView.viewControllers = [NSArray arrayWithObjects:navigation, rightView, nil];
		[rightView release];
		[navigation release];
		[self.window addSubview:splitView.view];
	}
	else
	{
		[self.window addSubview:navigation.view];
	}
	[self.window makeKeyAndVisible];
    return YES;
}

- (CGRect) getCurrentWindowsCGRect:(UIViewController *)requestor
{
	CGRect theRect = [self.window bounds];
	return CGRectMake(theRect.origin.x, theRect.origin.y, theRect.size.width, theRect.size.height);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

@end
