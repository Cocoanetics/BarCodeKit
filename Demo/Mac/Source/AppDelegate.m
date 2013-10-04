//
//  AppDelegate.m
//  BarCodeKitMac
//
//  Created by Oliver Drobnik on 10/3/13.
//  Copyright (c) 2013 Oliver Drobnik. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoWindowController.h"


@implementation AppDelegate
{
	DemoWindowController *_windowController;
}

+ (void)initialize
{
	NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
	NSDictionary *defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_windowController = [[DemoWindowController alloc] initWithWindowNibName:@"DemoWindow"];
	[_windowController.window makeKeyAndOrderFront:nil];
}

@end
