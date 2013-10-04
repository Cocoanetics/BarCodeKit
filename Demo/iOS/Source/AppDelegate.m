//
//  AppDelegate.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 8/9/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

+ (void)initialize
{
	NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
	NSDictionary *defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

@end
