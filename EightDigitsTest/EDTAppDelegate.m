//
//  EDTAppDelegate.m
//  EightDigitsTest
//
//  Created by Seyithan Teymur on 30/07/12.
//  Copyright (c) 2012 Verisun Bilişim Danışmanlık. All rights reserved.
//

#import "EDTAppDelegate.h"

#import "EDTMasterViewController.h"

#import "EDTDetailViewController.h"

#import "EightDigits.h"

@implementation EDTAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	/**
		8digits visit start
	 */
//warning Fill in your own username and password here
//warning Don't forget to fill in your tracking code and url prefix as values for EDTrackingCode and EDURLPrefix keys inside EightDigits.plist
	[[EDVisit currentVisit] setLocationWithLongitude:@"41.39" andLatitude:@"29.46"];
    [[EDVisit currentVisit] startWithApiKey:@"202cb962ac59075b964b07152d234b70" trackingCode:@"mu16j18l" urlPrefix:@"http://us1-api.8digits.com/api/"];
    
    NSArray *keys = [[NSArray alloc] initWithObjects:@"GSM", nil];
    NSArray *objs = [[NSArray alloc] initWithObjects:@"Turkcell", nil];
    NSDictionary *dictForVisitor = [[NSDictionary alloc] initWithObjects:objs forKeys:keys];
    
	[[EDVisitor currentVisitor] setVisitorAttributesFromDictionary:dictForVisitor withCompletionHandler: ^(NSString *error) {}];
	/**
		We want 8digits to log the activity so we call the startLogging method of our currentVisit. 
		You might want to delete this line or disable logging anywhere in your application by calling stopLogging when you release the app.
	 */
//	[[EDVisit currentVisit] startLogging];

	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    EDTMasterViewController *masterViewController = [[EDTMasterViewController alloc] initWithNibName:@"EDTMasterViewController_iPhone" bundle:nil];
	    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
	    self.window.rootViewController = self.navigationController;
	} else {
	    EDTMasterViewController *masterViewController = [[EDTMasterViewController alloc] initWithNibName:@"EDTMasterViewController_iPad" bundle:nil];
	    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
	    
	    EDTDetailViewController *detailViewController = [[EDTDetailViewController alloc] initWithNibName:@"EDTDetailViewController_iPad" bundle:nil];
	    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
		
		masterViewController.detailViewController = detailViewController;
		
	    self.splitViewController = [[UISplitViewController alloc] init];
	    self.splitViewController.delegate = detailViewController;
	    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
	    
	    self.window.rootViewController = self.splitViewController;
	}
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
